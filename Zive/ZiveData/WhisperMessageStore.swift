import Foundation
import Combine

extension Notification.Name {
    static let whisperMessageStoreDidChange = Notification.Name("whisperMessageStoreDidChange")
}

struct WhisperMessageModel: Codable, Identifiable, Equatable {
    let id: String
    var whisperMessageRoomId: String
    var whisperMessageSenderId: String
    var whisperMessageText: String
    var whisperMessageImagePath: String
    var whisperMessageVoicePath: String
    var whisperMessageVoiceDuration: TimeInterval
    var whisperMessageSendTime: Date
}

final class WhisperMessageStore: ObservableObject {
    static let shared = WhisperMessageStore()

    @Published private(set) var whisperMessageItems: [WhisperMessageModel] = []

    private let whisperMessageFileName = "WhisperMessageModel.json"
    private var whisperMessageCancellables = Set<AnyCancellable>()

    init() {
        whisperMessageFetchAll()
        NotificationCenter.default.publisher(for: .whisperMessageStoreDidChange)
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.whisperMessageFetchAll()
            }
            .store(in: &whisperMessageCancellables)
    }

    func whisperMessageCreate(_ whisperMessageModel: WhisperMessageModel) {
        whisperMessageItems.append(whisperMessageModel)
        whisperMessagePersist()
    }

    func whisperMessageFetchAll() {
        whisperMessageItems = ZiveLocalFileStore.ziveLocalFileStoreLoad(
            from: whisperMessageFileName,
            as: [WhisperMessageModel].self
        ) ?? []
    }

    func whisperMessageFetch(by id: String) -> WhisperMessageModel? {
        whisperMessageItems.first { $0.id == id }
    }

    func whisperMessageFetchByRoomId(_ roomId: String) -> [WhisperMessageModel] {
        whisperMessageItems
            .filter { $0.whisperMessageRoomId == roomId }
            .sorted { $0.whisperMessageSendTime < $1.whisperMessageSendTime }
    }

    func whisperMessageUpdate(_ whisperMessageModel: WhisperMessageModel) {
        guard let whisperMessageIndex = whisperMessageItems.firstIndex(where: { $0.id == whisperMessageModel.id }) else {
            return
        }

        whisperMessageItems[whisperMessageIndex] = whisperMessageModel
        whisperMessagePersist()
    }

    func whisperMessageDelete(by id: String) {
        whisperMessageItems.removeAll { $0.id == id }
        whisperMessagePersist()
    }

    func whisperMessageDeleteByRoomId(_ roomId: String) {
        whisperMessageItems.removeAll { $0.whisperMessageRoomId == roomId }
        whisperMessagePersist()
    }

    func whisperMessageReplaceAll(with whisperMessageModels: [WhisperMessageModel]) {
        whisperMessageItems = whisperMessageModels
        whisperMessagePersist()
    }

    private func whisperMessagePersist() {
        ZiveLocalFileStore.ziveLocalFileStoreSave(whisperMessageItems, to: whisperMessageFileName)
        NotificationCenter.default.post(name: .whisperMessageStoreDidChange, object: nil)
    }
}
