
import SwiftUI

final class QeixbgBriwyState {

  private init() {}

  private static let defaults = UserDefaults.standard

  static var qeixbgBriwyAgree: Bool {
    get { defaults.bool(forKey: "qeixbgBriwyAgree") }
    set { defaults.set(newValue, forKey: "qeixbgBriwyAgree") }
  }
    
    static var qeixbgBriwyAgreeEULA: Bool {
      get { defaults.bool(forKey: "qeixbgBriwyAgreeEULA") }
      set { defaults.set(newValue, forKey: "qeixbgBriwyAgreeEULA") }
    }

    static var qeixbgBriwyDidSeedLocalData: Bool {
      get { defaults.bool(forKey: "qeixbgBriwyDidSeedLocalData") }
      set { defaults.set(newValue, forKey: "qeixbgBriwyDidSeedLocalData") }
    }

    static var qeixbgBriwyCurrentUserId: String {
      get { defaults.string(forKey: "qeixbgBriwyCurrentUserId") ?? "" }
      set { defaults.set(newValue, forKey: "qeixbgBriwyCurrentUserId") }
    }

    static func qeixbgBriwyIsGuestUser() -> Bool {
      let qeixbgBriwyCurrentUserId = qeixbgBriwyCurrentUserId
        .trimmingCharacters(in: .whitespacesAndNewlines)

      guard !qeixbgBriwyCurrentUserId.isEmpty,
            let qeixbgBriwyCurrentUser = OrbitUserStore.shared.orbitUserFetch(by: qeixbgBriwyCurrentUserId) else {
        return false
      }

      return qeixbgBriwyCurrentUser.orbitUserEmail.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        && qeixbgBriwyCurrentUser.orbitUserPassword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

}
