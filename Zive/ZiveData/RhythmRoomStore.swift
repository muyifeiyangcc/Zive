import Foundation
import Combine

extension Notification.Name {
    static let rhythmRoomStoreDidChange = Notification.Name("rhythmRoomStoreDidChange")
}

struct RhythmRoomModel: Codable, Identifiable, Equatable {
    let id: String
    var rhythmRoomUserIds: [String]
    var rhythmRoomLastMessageTime: Date
    var rhythmRoomLastSenderId: String
    var rhythmRoomLastMessageText: String
    var rhythmRoomUnreadMessageCount: Int
}

final class RhythmRoomStore: ObservableObject {
    static let shared = RhythmRoomStore()

    @Published private(set) var rhythmRoomItems: [RhythmRoomModel] = []

    private let rhythmRoomFileName = "RhythmRoomModel.json"
    private var rhythmRoomCancellables = Set<AnyCancellable>()

    init() {
        rhythmRoomFetchAll()
        NotificationCenter.default.publisher(for: .rhythmRoomStoreDidChange)
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.rhythmRoomFetchAll()
            }
            .store(in: &rhythmRoomCancellables)
    }

    func rhythmRoomCreate(_ rhythmRoomModel: RhythmRoomModel) {
        rhythmRoomItems.append(rhythmRoomModel)
        rhythmRoomPersist()
    }

    func rhythmRoomFetchAll() {
        rhythmRoomItems = ZiveLocalFileStore.ziveLocalFileStoreLoad(
            from: rhythmRoomFileName,
            as: [RhythmRoomModel].self
        ) ?? []
    }

    func rhythmRoomFetch(by id: String) -> RhythmRoomModel? {
        rhythmRoomItems.first { $0.id == id }
    }

    func rhythmRoomFetchByUserId(_ userId: String) -> [RhythmRoomModel] {
        rhythmRoomItems.filter { $0.rhythmRoomUserIds.contains(userId) }
    }

    func rhythmRoomFetchBetweenUsers(_ userIds: [String]) -> RhythmRoomModel? {
        let rhythmRoomUserIdSet = Set(userIds)
        return rhythmRoomItems.first { Set($0.rhythmRoomUserIds) == rhythmRoomUserIdSet }
    }

    func rhythmRoomUpdate(_ rhythmRoomModel: RhythmRoomModel) {
        guard let rhythmRoomIndex = rhythmRoomItems.firstIndex(where: { $0.id == rhythmRoomModel.id }) else {
            return
        }

        rhythmRoomItems[rhythmRoomIndex] = rhythmRoomModel
        rhythmRoomPersist()
    }

    func rhythmRoomDelete(by id: String) {
        rhythmRoomItems.removeAll { $0.id == id }
        rhythmRoomPersist()
    }

    func rhythmRoomReplaceAll(with rhythmRoomModels: [RhythmRoomModel]) {
        rhythmRoomItems = rhythmRoomModels
        rhythmRoomPersist()
    }

    func rhythmRoomMarkAsRead(roomId: String) {
        guard var rhythmRoomModel = rhythmRoomFetch(by: roomId) else {
            return
        }

        rhythmRoomModel.rhythmRoomUnreadMessageCount = 0
        rhythmRoomUpdate(rhythmRoomModel)
    }

    func rhythmRoomUpdateLastMessage(
        roomId: String,
        senderId: String,
        messageText: String,
        sendTime: Date,
        unreadMessageCount: Int
    ) {
        guard var rhythmRoomModel = rhythmRoomFetch(by: roomId) else {
            return
        }

        rhythmRoomModel.rhythmRoomLastSenderId = senderId
        rhythmRoomModel.rhythmRoomLastMessageText = messageText
        rhythmRoomModel.rhythmRoomLastMessageTime = sendTime
        rhythmRoomModel.rhythmRoomUnreadMessageCount = unreadMessageCount
        rhythmRoomUpdate(rhythmRoomModel)
    }

    private func rhythmRoomPersist() {
        ZiveLocalFileStore.ziveLocalFileStoreSave(rhythmRoomItems, to: rhythmRoomFileName)
        NotificationCenter.default.post(name: .rhythmRoomStoreDidChange, object: nil)
    }
}
