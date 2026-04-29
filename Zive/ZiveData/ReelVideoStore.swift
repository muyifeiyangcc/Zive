import Foundation
import Combine

extension Notification.Name {
    static let reelVideoStoreDidChange = Notification.Name("reelVideoStoreDidChange")
}

struct ReelVideoModel: Codable, Identifiable, Equatable {
    let id: String
    var reelVideoPublisherId: String
    var reelVideoCoverUrl: String
    var reelVideoUrl: String
    var reelVideoContent: String
    var reelVideoLikeCount: Int
    var reelVideoGiftValue: Int
}

final class ReelVideoStore: ObservableObject {
    static let shared = ReelVideoStore()

    @Published private(set) var reelVideoItems: [ReelVideoModel] = []

    private let reelVideoFileName = "ReelVideoModel.json"
    private var reelVideoCancellables = Set<AnyCancellable>()

    init() {
        reelVideoFetchAll()
        NotificationCenter.default.publisher(for: .reelVideoStoreDidChange)
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.reelVideoFetchAll()
            }
            .store(in: &reelVideoCancellables)
    }

    func reelVideoCreate(_ reelVideoModel: ReelVideoModel) {
        reelVideoItems.append(reelVideoModel)
        reelVideoPersist()
    }

    func reelVideoFetchAll() {
        reelVideoItems = ZiveLocalFileStore.ziveLocalFileStoreLoad(
            from: reelVideoFileName,
            as: [ReelVideoModel].self
        ) ?? []
    }

    func reelVideoFetch(by id: String) -> ReelVideoModel? {
        reelVideoItems.first { $0.id == id }
    }

    func reelVideoUpdate(_ reelVideoModel: ReelVideoModel) {
        guard let reelVideoIndex = reelVideoItems.firstIndex(where: { $0.id == reelVideoModel.id }) else {
            return
        }

        reelVideoItems[reelVideoIndex] = reelVideoModel
        reelVideoPersist()
    }

    func reelVideoDelete(by id: String) {
        reelVideoItems.removeAll { $0.id == id }
        reelVideoPersist()
    }

    func reelVideoReplaceAll(with reelVideoModels: [ReelVideoModel]) {
        reelVideoItems = reelVideoModels
        reelVideoPersist()
    }

    func reelVideoFetchByPublisherId(_ publisherId: String) -> [ReelVideoModel] {
        reelVideoItems.filter { $0.reelVideoPublisherId == publisherId }
    }

    func reelVideoAdjustLikeCount(videoId: String, delta: Int) {
        guard var reelVideoModel = reelVideoFetch(by: videoId) else {
            return
        }

        reelVideoModel.reelVideoLikeCount = max(0, reelVideoModel.reelVideoLikeCount + delta)
        reelVideoUpdate(reelVideoModel)
    }

    func reelVideoAdjustGiftValue(videoId: String, delta: Int) {
        guard var reelVideoModel = reelVideoFetch(by: videoId) else {
            return
        }

        reelVideoModel.reelVideoGiftValue = max(0, reelVideoModel.reelVideoGiftValue + delta)
        reelVideoUpdate(reelVideoModel)
    }

    private func reelVideoPersist() {
        ZiveLocalFileStore.ziveLocalFileStoreSave(reelVideoItems, to: reelVideoFileName)
        NotificationCenter.default.post(name: .reelVideoStoreDidChange, object: nil)
    }
}
