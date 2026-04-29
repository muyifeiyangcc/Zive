import Foundation
import Combine

final class SkillProgressionSignUpDraftCenter: ObservableObject {
    @Published var skillProgressionSignUpDraftEmail = ""
    @Published var skillProgressionSignUpDraftPassword = ""

    var skillProgressionSignUpDraftHasPendingData: Bool {
        !skillProgressionSignUpDraftEmail
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .isEmpty
        && !skillProgressionSignUpDraftPassword
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .isEmpty
    }

    func skillProgressionSignUpDraftStore(email: String, password: String) {
        skillProgressionSignUpDraftEmail = email
        skillProgressionSignUpDraftPassword = password
    }

    func skillProgressionSignUpDraftClear() {
        skillProgressionSignUpDraftEmail = ""
        skillProgressionSignUpDraftPassword = ""
    }
}
