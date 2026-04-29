import Foundation
import Combine

extension Notification.Name {
    static let echoCommentStoreDidChange = Notification.Name("echoCommentStoreDidChange")
}

struct EchoCommentModel: Codable, Identifiable, Equatable {
    let id: String
    var echoCommentVideoId: String
    var echoCommentPublisherId: String
    var echoCommentContent: String
    var echoCommentTime: Date
}

final class EchoCommentStore: ObservableObject {
    static let shared = EchoCommentStore()

    @Published private(set) var echoCommentItems: [EchoCommentModel] = []

    private let echoCommentFileName = "EchoCommentModel.json"
    private var echoCommentCancellables = Set<AnyCancellable>()

    init() {
        echoCommentFetchAll()
        NotificationCenter.default.publisher(for: .echoCommentStoreDidChange)
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.echoCommentFetchAll()
            }
            .store(in: &echoCommentCancellables)
    }

    func echoCommentCreate(_ echoCommentModel: EchoCommentModel) {
        echoCommentItems.append(echoCommentModel)
        echoCommentPersist()
    }

    func echoCommentFetchAll() {
        echoCommentItems = ZiveLocalFileStore.ziveLocalFileStoreLoad(
            from: echoCommentFileName,
            as: [EchoCommentModel].self
        ) ?? []
    }

    func echoCommentFetch(by id: String) -> EchoCommentModel? {
        echoCommentItems.first { $0.id == id }
    }

    func echoCommentUpdate(_ echoCommentModel: EchoCommentModel) {
        guard let echoCommentIndex = echoCommentItems.firstIndex(where: { $0.id == echoCommentModel.id }) else {
            return
        }

        echoCommentItems[echoCommentIndex] = echoCommentModel
        echoCommentPersist()
    }

    func echoCommentDelete(by id: String) {
        echoCommentItems.removeAll { $0.id == id }
        echoCommentPersist()
    }

    func echoCommentReplaceAll(with echoCommentModels: [EchoCommentModel]) {
        echoCommentItems = echoCommentModels
        echoCommentPersist()
    }

    func echoCommentFetchByVideoId(_ videoId: String) -> [EchoCommentModel] {
        echoCommentItems.filter { $0.echoCommentVideoId == videoId }
    }

    private func echoCommentPersist() {
        ZiveLocalFileStore.ziveLocalFileStoreSave(echoCommentItems, to: echoCommentFileName)
        NotificationCenter.default.post(name: .echoCommentStoreDidChange, object: nil)
    }
}
