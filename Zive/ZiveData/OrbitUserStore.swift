import Foundation
import Combine

extension Notification.Name {
    static let orbitUserStoreDidChange = Notification.Name("orbitUserStoreDidChange")
}

struct OrbitUserModel: Codable, Identifiable, Equatable {
    let id: String
    var orbitUserEmail: String
    var orbitUserPassword: String
    var orbitUserAvatar: String
    var orbitUserName: String
    var orbitUserFollowerIds: [String]
    var orbitUserFollowingIds: [String]
    var orbitUserBlockedIds: [String]
    var orbitUserLikedVideoIds: [String]
    var orbitUserCoinCount: Int
    var orbitUserReceivedGiftValue: Int

    init(
        id: String,
        orbitUserEmail: String,
        orbitUserPassword: String,
        orbitUserAvatar: String,
        orbitUserName: String,
        orbitUserFollowerIds: [String],
        orbitUserFollowingIds: [String],
        orbitUserBlockedIds: [String],
        orbitUserLikedVideoIds: [String],
        orbitUserCoinCount: Int,
        orbitUserReceivedGiftValue: Int = 0
    ) {
        self.id = id
        self.orbitUserEmail = orbitUserEmail
        self.orbitUserPassword = orbitUserPassword
        self.orbitUserAvatar = orbitUserAvatar
        self.orbitUserName = orbitUserName
        self.orbitUserFollowerIds = orbitUserFollowerIds
        self.orbitUserFollowingIds = orbitUserFollowingIds
        self.orbitUserBlockedIds = orbitUserBlockedIds
        self.orbitUserLikedVideoIds = orbitUserLikedVideoIds
        self.orbitUserCoinCount = orbitUserCoinCount
        self.orbitUserReceivedGiftValue = orbitUserReceivedGiftValue
    }

    init(from decoder: Decoder) throws {
        let orbitUserContainer = try decoder.container(keyedBy: CodingKeys.self)
        id = try orbitUserContainer.decode(String.self, forKey: .id)
        orbitUserEmail = try orbitUserContainer.decode(String.self, forKey: .orbitUserEmail)
        orbitUserPassword = try orbitUserContainer.decode(String.self, forKey: .orbitUserPassword)
        orbitUserAvatar = try orbitUserContainer.decode(String.self, forKey: .orbitUserAvatar)
        orbitUserName = try orbitUserContainer.decode(String.self, forKey: .orbitUserName)
        orbitUserFollowerIds = try orbitUserContainer.decode([String].self, forKey: .orbitUserFollowerIds)
        orbitUserFollowingIds = try orbitUserContainer.decode([String].self, forKey: .orbitUserFollowingIds)
        orbitUserBlockedIds = try orbitUserContainer.decode([String].self, forKey: .orbitUserBlockedIds)
        orbitUserLikedVideoIds = try orbitUserContainer.decode([String].self, forKey: .orbitUserLikedVideoIds)
        orbitUserCoinCount = try orbitUserContainer.decode(Int.self, forKey: .orbitUserCoinCount)
        orbitUserReceivedGiftValue = try orbitUserContainer.decodeIfPresent(
            Int.self,
            forKey: .orbitUserReceivedGiftValue
        ) ?? 0
    }
}

final class OrbitUserStore: ObservableObject {
    static let shared = OrbitUserStore()

    @Published private(set) var orbitUserItems: [OrbitUserModel] = []

    private let orbitUserFileName = "OrbitUserModel.json"
    private var orbitUserCancellables = Set<AnyCancellable>()

    init() {
        orbitUserFetchAll()
        NotificationCenter.default.publisher(for: .orbitUserStoreDidChange)
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.orbitUserFetchAll()
            }
            .store(in: &orbitUserCancellables)
    }

    func orbitUserCreate(_ orbitUserModel: OrbitUserModel) {
        orbitUserItems.append(orbitUserModel)
        orbitUserPersist()
    }

    func orbitUserFetchAll() {
        orbitUserItems = ZiveLocalFileStore.ziveLocalFileStoreLoad(
            from: orbitUserFileName,
            as: [OrbitUserModel].self
        ) ?? []
    }

    func orbitUserFetch(by id: String) -> OrbitUserModel? {
        orbitUserItems.first { $0.id == id }
    }

    func orbitUserFetchByEmail(_ email: String) -> OrbitUserModel? {
        orbitUserItems.first {
            $0.orbitUserEmail.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            == email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        }
    }

    func orbitUserUpdate(_ orbitUserModel: OrbitUserModel) {
        guard let orbitUserIndex = orbitUserItems.firstIndex(where: { $0.id == orbitUserModel.id }) else {
            return
        }

        orbitUserItems[orbitUserIndex] = orbitUserModel
        orbitUserPersist()
    }

    func orbitUserDelete(by id: String) {
        orbitUserItems.removeAll { $0.id == id }
        orbitUserPersist()
    }

    func orbitUserReplaceAll(with orbitUserModels: [OrbitUserModel]) {
        orbitUserItems = orbitUserModels
        orbitUserPersist()
    }

    func orbitUserExists(id: String) -> Bool {
        orbitUserItems.contains { $0.id == id }
    }

    func orbitUserEmailExists(_ email: String) -> Bool {
        orbitUserFetchByEmail(email) != nil
    }

    func orbitUserValidateLogin(email: String, password: String) -> OrbitUserModel? {
        guard let orbitUserModel = orbitUserFetchByEmail(email) else {
            return nil
        }

        return orbitUserModel.orbitUserPassword == password ? orbitUserModel : nil
    }

    func orbitUserResetPassword(email: String, newPassword: String) -> Bool {
        guard var orbitUserModel = orbitUserFetchByEmail(email) else {
            return false
        }

        orbitUserModel.orbitUserPassword = newPassword
        orbitUserUpdate(orbitUserModel)
        return true
    }

    func orbitUserToggleLikedVideo(userId: String, videoId: String) -> Bool? {
        guard var orbitUserModel = orbitUserFetch(by: userId) else {
            return nil
        }

        if let orbitUserLikedVideoIndex = orbitUserModel.orbitUserLikedVideoIds.firstIndex(of: videoId) {
            orbitUserModel.orbitUserLikedVideoIds.remove(at: orbitUserLikedVideoIndex)
            orbitUserUpdate(orbitUserModel)
            return false
        }

        orbitUserModel.orbitUserLikedVideoIds.append(videoId)
        orbitUserUpdate(orbitUserModel)
        return true
    }

    func orbitUserToggleFollow(currentUserId: String, targetUserId: String) -> Bool? {
        guard currentUserId != targetUserId,
              var orbitUserCurrentUser = orbitUserFetch(by: currentUserId),
              var orbitUserTargetUser = orbitUserFetch(by: targetUserId) else {
            return nil
        }

        if let orbitUserFollowingIndex = orbitUserCurrentUser.orbitUserFollowingIds.firstIndex(of: targetUserId) {
            orbitUserCurrentUser.orbitUserFollowingIds.remove(at: orbitUserFollowingIndex)
            orbitUserTargetUser.orbitUserFollowerIds.removeAll { $0 == currentUserId }
            orbitUserUpdate(orbitUserCurrentUser)
            orbitUserUpdate(orbitUserTargetUser)
            return false
        }

        orbitUserCurrentUser.orbitUserFollowingIds.append(targetUserId)
        orbitUserTargetUser.orbitUserFollowerIds.append(currentUserId)
        orbitUserUpdate(orbitUserCurrentUser)
        orbitUserUpdate(orbitUserTargetUser)
        return true
    }

    func orbitUserRemoveBlockedUser(currentUserId: String, blockedUserId: String) -> Bool {
        guard var orbitUserCurrentUser = orbitUserFetch(by: currentUserId),
              orbitUserCurrentUser.orbitUserBlockedIds.contains(blockedUserId) else {
            return false
        }

        orbitUserCurrentUser.orbitUserBlockedIds.removeAll { $0 == blockedUserId }
        orbitUserUpdate(orbitUserCurrentUser)
        return true
    }

    func orbitUserBlockUser(currentUserId: String, blockedUserId: String) -> Bool {
        guard currentUserId != blockedUserId,
              var orbitUserCurrentUser = orbitUserFetch(by: currentUserId),
              var orbitUserBlockedUser = orbitUserFetch(by: blockedUserId) else {
            return false
        }

        if !orbitUserCurrentUser.orbitUserBlockedIds.contains(blockedUserId) {
            orbitUserCurrentUser.orbitUserBlockedIds.append(blockedUserId)
        }

        orbitUserCurrentUser.orbitUserFollowingIds.removeAll { $0 == blockedUserId }
        orbitUserCurrentUser.orbitUserFollowerIds.removeAll { $0 == blockedUserId }
        orbitUserBlockedUser.orbitUserFollowingIds.removeAll { $0 == currentUserId }
        orbitUserBlockedUser.orbitUserFollowerIds.removeAll { $0 == currentUserId }

        orbitUserUpdate(orbitUserCurrentUser)
        orbitUserUpdate(orbitUserBlockedUser)
        return true
    }

    func orbitUserAdjustCoinCount(userId: String, delta: Int) -> Bool {
        guard var orbitUserModel = orbitUserFetch(by: userId) else {
            return false
        }

        let orbitUserNextCoinCount = orbitUserModel.orbitUserCoinCount + delta
        guard orbitUserNextCoinCount >= 0 else {
            return false
        }

        orbitUserModel.orbitUserCoinCount = orbitUserNextCoinCount
        orbitUserUpdate(orbitUserModel)
        return true
    }

    func orbitUserAdjustReceivedGiftValue(userId: String, delta: Int) -> Bool {
        guard var orbitUserModel = orbitUserFetch(by: userId) else {
            return false
        }

        orbitUserModel.orbitUserReceivedGiftValue = max(
            0,
            orbitUserModel.orbitUserReceivedGiftValue + delta
        )
        orbitUserUpdate(orbitUserModel)
        return true
    }

    private func orbitUserPersist() {
        ZiveLocalFileStore.ziveLocalFileStoreSave(orbitUserItems, to: orbitUserFileName)
        NotificationCenter.default.post(name: .orbitUserStoreDidChange, object: nil)
    }
}
