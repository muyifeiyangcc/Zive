import Foundation
import Combine

extension Notification.Name {
    static let tempoPlanStoreDidChange = Notification.Name("tempoPlanStoreDidChange")
}

struct TempoPlanModel: Codable, Identifiable, Equatable {
    let id: String
    var tempoPlanPublisherId: String
    var tempoPlanPublishTime: Date
    var tempoPlanGoal: String
    var tempoPlanDurationMinutes: Int
    var tempoPlanIsFinished: Bool
}

final class TempoPlanStore: ObservableObject {
    static let shared = TempoPlanStore()

    @Published private(set) var tempoPlanItems: [TempoPlanModel] = []

    private let tempoPlanFileName = "TempoPlanModel.json"
    private var tempoPlanCancellables = Set<AnyCancellable>()

    init() {
        tempoPlanFetchAll()
        NotificationCenter.default.publisher(for: .tempoPlanStoreDidChange)
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.tempoPlanFetchAll()
            }
            .store(in: &tempoPlanCancellables)
    }

    func tempoPlanCreate(_ tempoPlanModel: TempoPlanModel) {
        tempoPlanItems.append(tempoPlanModel)
        tempoPlanPersist()
    }

    func tempoPlanFetchAll() {
        tempoPlanItems = ZiveLocalFileStore.ziveLocalFileStoreLoad(
            from: tempoPlanFileName,
            as: [TempoPlanModel].self
        ) ?? []
    }

    func tempoPlanFetch(by id: String) -> TempoPlanModel? {
        tempoPlanItems.first { $0.id == id }
    }

    func tempoPlanUpdate(_ tempoPlanModel: TempoPlanModel) {
        guard let tempoPlanIndex = tempoPlanItems.firstIndex(where: { $0.id == tempoPlanModel.id }) else {
            return
        }

        tempoPlanItems[tempoPlanIndex] = tempoPlanModel
        tempoPlanPersist()
    }

    func tempoPlanDelete(by id: String) {
        tempoPlanItems.removeAll { $0.id == id }
        tempoPlanPersist()
    }

    func tempoPlanReplaceAll(with tempoPlanModels: [TempoPlanModel]) {
        tempoPlanItems = tempoPlanModels
        tempoPlanPersist()
    }

    func tempoPlanFetchByPublisherId(_ publisherId: String) -> [TempoPlanModel] {
        tempoPlanItems.filter { $0.tempoPlanPublisherId == publisherId }
    }

    private func tempoPlanPersist() {
        ZiveLocalFileStore.ziveLocalFileStoreSave(tempoPlanItems, to: tempoPlanFileName)
        NotificationCenter.default.post(name: .tempoPlanStoreDidChange, object: nil)
    }
}
