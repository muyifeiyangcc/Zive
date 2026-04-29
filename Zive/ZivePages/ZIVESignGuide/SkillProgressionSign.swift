import SwiftUI

enum SkillProgressionSignFocusField {
    case email
    case password
    case rePassword
}

enum SkillProgressionSignMode {
    case signIn
    case signUp
    case forgotPassword

    var title: String {
        switch self {
        case .signIn:
            return "Sign in"
        case .signUp:
            return "Sign up"
        case .forgotPassword:
            return "Forgot password"
        }
    }

    var buttonTitle: String {
        switch self {
        case .signIn:
            return "Sign in"
        case .signUp:
            return "Sign up"
        case .forgotPassword:
            return "Reset password"
        }
    }

    var cardHeight: CGFloat {
        switch self {
        case .signIn:
            return 260
        case .signUp:
            return 349
        case .forgotPassword:
            return 349
        }
    }
}

struct SkillProgressionSign: View {
    @State private var skillProgressionSignMode: SkillProgressionSignMode
    @State private var skillProgressionSignEmail = ""
    @State private var skillProgressionSignPassword = ""
    @State private var skillProgressionSignRePassword = ""
    @FocusState private var skillProgressionSignFocusField: SkillProgressionSignFocusField?
    @EnvironmentObject private var skillProgreNavi: WeioZwivbeNavigator
    @EnvironmentObject private var ziveGlobalFeedbackCenter: ZiveGlobalFeedbackCenter
    @EnvironmentObject private var skillProgressionSignUpDraftCenter: SkillProgressionSignUpDraftCenter

    init(skillProgressionSignInitialMode: SkillProgressionSignMode = .signIn) {
        _skillProgressionSignMode = State(initialValue: skillProgressionSignInitialMode)
    }

    var body: some View {
        ZStack {
            ZiveStyle.ColorPalette.background
                .ignoresSafeArea()
                .onTapGesture {
                    skillProgressionSignFocusField = nil
                }

            VStack(spacing: 0) {
                GrooveStreakTopNavigationBar(title: skillProgressionSignMode.title)
                    .padding(.horizontal, 18)
                    .padding(.top, 10)

                VStack(spacing: 0) {
                    skillProgressionSignCard
                        .padding(.top, 58)

                    Spacer()

                    if skillProgressionSignFocusField == nil {
                        GrooveStreakButton(
                            title: skillProgressionSignMode.buttonTitle,
                            width: 279,
                            height: 39
                        ) {
                            skillProgressionSignFocusField = nil
                            Task {
                                await skillProgressionSignHandlePrimaryAction()
                            }
                        }
                        .padding(.bottom, 66)
                        .transition(.opacity)
                    }
                }
                .padding(.horizontal, 40)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            skillProgressionSignFocusField = nil
        }
        .animation(.easeInOut(duration: 0.2), value: skillProgressionSignFocusField == nil)
        .navigationBarHidden(true)
    }

    private var skillProgressionSignCard: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Color.white)
                .frame(height: skillProgressionSignMode.cardHeight)
                .overlay(alignment: .top) {
                    Image("ZIVECardBg")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                }

            Image("ZIVECardTopDecration")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 125)
                .offset(y: -16)

            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Email:")
                        .font(ZiveStyle.FontBook.boldItalic(20))
                        .foregroundStyle(ZiveStyle.ColorPalette.textPrimary)

                    ZiveTextField(
                        placeholder: "Enter email address",
                        text: $skillProgressionSignEmail,
                        isFocused: skillProgressionSignFocusField == .email,
                        focusState: $skillProgressionSignFocusField,
                        focusEquals: .email
                    )
                }

                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Password:")
                            .font(ZiveStyle.FontBook.boldItalic(20))
                            .foregroundStyle(ZiveStyle.ColorPalette.textPrimary)

                        Spacer()

                        if skillProgressionSignMode == .signIn {
                            Button("FORGOT?") {
                                skillProgressionSignMode = .forgotPassword
                                skillProgressionSignFocusField = .email
                            }
                            .buttonStyle(.plain)
                            .font(ZiveStyle.FontBook.regular(14))
                            .foregroundStyle(ZiveStyle.ColorPalette.textPrimary.opacity(0.85))
                        }
                    }

                    ZiveSecureField(
                        placeholder: "Enter password",
                        text: $skillProgressionSignPassword,
                        isFocused: skillProgressionSignFocusField == .password,
                        focusState: $skillProgressionSignFocusField,
                        focusEquals: .password
                    )
                }

                if skillProgressionSignMode != .signIn {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Confirm password:")
                            .font(ZiveStyle.FontBook.boldItalic(20))
                            .foregroundStyle(ZiveStyle.ColorPalette.textPrimary)

                        ZiveSecureField(
                            placeholder: "Enter password again",
                            text: $skillProgressionSignRePassword,
                            isFocused: skillProgressionSignFocusField == .rePassword,
                            focusState: $skillProgressionSignFocusField,
                            focusEquals: .rePassword
                        )
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 38)
        }
    }

    private func skillProgressionSignHandlePrimaryAction() async {
        let skillProgressionSignUserStore = OrbitUserStore()
        let skillProgressionSignEmail = skillProgressionSignEmail
            .trimmingCharacters(in: .whitespacesAndNewlines)
        let skillProgressionSignPassword = skillProgressionSignPassword
            .trimmingCharacters(in: .whitespacesAndNewlines)
        let skillProgressionSignRePassword = skillProgressionSignRePassword
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard !skillProgressionSignEmail.isEmpty else {
            ziveGlobalFeedbackCenter.ziveGlobalFeedbackShowToast(
                text: "Email cannot be empty",
                status: .error
            )
            return
        }

        switch skillProgressionSignMode {
        case .signIn:
            guard skillProgressionSignValidateEmail(skillProgressionSignEmail) else {
                ziveGlobalFeedbackCenter.ziveGlobalFeedbackShowToast(
                    text: "Please enter a valid email address",
                    status: .error
                )
                return
            }

            let skillProgressionSignUserModel: OrbitUserModel

            guard !skillProgressionSignPassword.isEmpty else {
                ziveGlobalFeedbackCenter.ziveGlobalFeedbackShowToast(
                    text: "Password cannot be empty",
                    status: .error
                )
                return
            }

            guard let skillProgressionSignValidatedUser = skillProgressionSignUserStore.orbitUserValidateLogin(
                email: skillProgressionSignEmail,
                password: skillProgressionSignPassword
            ) else {
                ziveGlobalFeedbackCenter.ziveGlobalFeedbackShowToast(
                    text: "Incorrect email or password",
                    status: .error
                )
                return
            }

            skillProgressionSignUserModel = skillProgressionSignValidatedUser
            QeixbgBriwyState.qeixbgBriwyCurrentUserId = skillProgressionSignUserModel.id

            await skillProgressionSignPerformSuccessTransition(
                loadingText: "Signing in..."
            )
            skillProgreNavi.weioZwivbePresentRoot(.pulseVistaHome)

        case .signUp:
            guard !skillProgressionSignPassword.isEmpty,
                  !skillProgressionSignRePassword.isEmpty else {
                ziveGlobalFeedbackCenter.ziveGlobalFeedbackShowToast(
                    text: "Password fields cannot be empty",
                    status: .error
                )
                return
            }

            guard skillProgressionSignPassword.count >= 3 else {
                ziveGlobalFeedbackCenter.ziveGlobalFeedbackShowToast(
                    text: "Password must be at least 3 characters",
                    status: .error
                )
                return
            }

            guard skillProgressionSignPassword == skillProgressionSignRePassword else {
                ziveGlobalFeedbackCenter.ziveGlobalFeedbackShowToast(
                    text: "The two passwords do not match",
                    status: .error
                )
                return
            }

            guard !skillProgressionSignUserStore.orbitUserEmailExists(skillProgressionSignEmail) else {
                ziveGlobalFeedbackCenter.ziveGlobalFeedbackShowToast(
                    text: "This email is already registered",
                    status: .error
                )
                return
            }

            skillProgressionSignUpDraftCenter.skillProgressionSignUpDraftStore(
                email: skillProgressionSignEmail,
                password: skillProgressionSignPassword
            )
            skillProgreNavi.weioZwivbePush(.rhythmBloomProfile)

        case .forgotPassword:
            guard skillProgressionSignValidateEmail(skillProgressionSignEmail) else {
                ziveGlobalFeedbackCenter.ziveGlobalFeedbackShowToast(
                    text: "Please enter a valid email address",
                    status: .error
                )
                return
            }

            guard !skillProgressionSignPassword.isEmpty,
                  !skillProgressionSignRePassword.isEmpty else {
                ziveGlobalFeedbackCenter.ziveGlobalFeedbackShowToast(
                    text: "Password fields cannot be empty",
                    status: .error
                )
                return
            }

            guard skillProgressionSignPassword.count >= 6 else {
                ziveGlobalFeedbackCenter.ziveGlobalFeedbackShowToast(
                    text: "Password must be at least 6 characters",
                    status: .error
                )
                return
            }

            guard skillProgressionSignPassword == skillProgressionSignRePassword else {
                ziveGlobalFeedbackCenter.ziveGlobalFeedbackShowToast(
                    text: "The two passwords do not match",
                    status: .error
                )
                return
            }

            guard skillProgressionSignUserStore.orbitUserResetPassword(
                email: skillProgressionSignEmail,
                newPassword: skillProgressionSignPassword
            ) else {
                ziveGlobalFeedbackCenter.ziveGlobalFeedbackShowToast(
                    text: "This email is not registered",
                    status: .error
                )
                return
            }

            ziveGlobalFeedbackCenter.ziveGlobalFeedbackShowToast(
                text: "Password reset successful",
                status: .success
            )
            skillProgreNavi.weioZwivbeReplaceStack(with: .skillProgressionSignIn)
        }
    }

    private func skillProgressionSignValidateEmail(_ skillProgressionSignEmail: String) -> Bool {
        let skillProgressionSignEmailPattern = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return skillProgressionSignEmail.range(
            of: skillProgressionSignEmailPattern,
            options: .regularExpression
        ) != nil
    }

    private func skillProgressionSignPerformSuccessTransition(
        loadingText: String
    ) async {
        await MainActor.run {
            ziveGlobalFeedbackCenter.ziveGlobalFeedbackShowLoading(text: loadingText)
        }
        await delay(1)
        await MainActor.run {
            ziveGlobalFeedbackCenter.ziveGlobalFeedbackHideLoading()
        }
    }
}

#Preview {
    NavigationStack {
        SkillProgressionSign(skillProgressionSignInitialMode: .signIn)
    }
}
