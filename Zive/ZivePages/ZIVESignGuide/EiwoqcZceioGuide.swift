import SwiftUI

struct EiwoqcZceioGuide: View {
    @EnvironmentObject private var weioZwivbeNavigator: WeioZwivbeNavigator
    @EnvironmentObject private var eiwoqcZeicLoToast: ZiveGlobalFeedbackCenter
    @EnvironmentObject private var eiwoqcZceioGuideUserStore: OrbitUserStore
    @State private var eiwoqcZceioGuideShowEULA = false
    
    @AppStorage("qeixbgBriwyAgree") var eiwoqcZceioGuideAgreeTerms: Bool = false
    @AppStorage("qeixbgBriwyAgreeEULA") var eiwoqcZceioIsAgreeEula: Bool = false

    var body: some View {
        ZStack {
            GeometryReader { _ in
                Image("ZIVEGuideBg")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .ignoresSafeArea()
            }

            LinearGradient(
                colors: [
                    Color.black.opacity(0.02),
                    ZiveStyle.ColorPalette.background.opacity(0.35),
                    ZiveStyle.ColorPalette.background.opacity(0.82),
                    ZiveStyle.ColorPalette.background
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {

                Spacer(minLength: 150)

                eiwoqcZceioGuideHeroIdentity

                Spacer()

                eiwoqcZceioGuideActionArea
            }
            .padding(.horizontal, 23)
            .padding(.top, 14)
            .padding(.bottom, 30)

            if eiwoqcZceioGuideShowEULA {
                PulseLedgerEULASheet(
                    pulseLedgerEULAIsPresented: $eiwoqcZceioGuideShowEULA
                )
                .zIndex(10)
            }
        }
        .animation(.easeInOut(duration: 0.22), value: eiwoqcZceioGuideShowEULA)
        .ziveScreenBackground()
    }


    private var eiwoqcZceioGuideHeroIdentity: some View {
        VStack(spacing: 12) {
            Image("ZIVELogo")
                .resizable()
                .frame(width: 98, height: 98)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))

            Text("Zive")
                .font(ZiveStyle.FontBook.boldItalic(20))
                .foregroundStyle(ZiveStyle.ColorPalette.white)
                .italic()
        }
    }

    private var eiwoqcZceioGuideActionArea: some View {
        VStack(spacing: 0) {
            VStack(spacing: 40) {
                eiwoqcZceioGuideButton(title: "Login by email")
                eiwoqcZceioGuideButton(title: "I’m new")
            }

            VStack(spacing: 18) {
                HStack(spacing: 4) {
                    Text("Don’t have an account?")
                        .font(ZiveStyle.FontBook.regular(14))
                        .foregroundStyle(ZiveStyle.ColorPalette.white.opacity(0.82))

                    Button("Sign up") {
                        if !eiwoqcZceioIsAgreeEula {
                            eiwoqcZceioGuideShowEULA = true
                            return
                        }
                        if !eiwoqcZceioGuideAgreeTerms {
                            eiwoqcZeicLoToast.ziveGlobalFeedbackShowToast(text: "Please read and agree to the User Agreement and Privacy Policy first.")
                            return
                        }
                        weioZwivbeNavigator.weioZwivbePush(.skillProgressionSignUp)
                    }
                        .buttonStyle(.plain)
                        .font(ZiveStyle.FontBook.regular(14))
                        .foregroundStyle(ZiveStyle.ColorPalette.white)
                        .underline()
                }
                .padding(.top, 28)

                HStack(alignment: .center, spacing: 8) {
                    Button {
                        eiwoqcZceioGuideAgreeTerms.toggle()
                    } label: {
                        Circle()
                            .fill(eiwoqcZceioGuideAgreeTerms ? ZiveStyle.ColorPalette.brandPink : Color.white.opacity(0.22))
                            .frame(width: 21, height: 21)
                            .overlay {
                                if eiwoqcZceioGuideAgreeTerms {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 8, weight: .bold))
                                        .foregroundStyle(ZiveStyle.ColorPalette.white)
                                }
                            }
                    }
                    .buttonStyle(.plain)

                    eiwoqcZceioGuideAgreementText
                }
            }
        }
    }

    private var eiwoqcZceioGuideAgreementText: some View {
        HStack(spacing: 0) {
            Text("Agree with ")
                .font(ZiveStyle.FontBook.regular(11))
                .foregroundStyle(ZiveStyle.ColorPalette.white.opacity(0.7))

            Button("User Agreement") {
                weioZwivbeNavigator.weioZwivbePush(.sedivaoBeiwWeb("https://app.8acgspbj.link/users"))
            }
                .buttonStyle(.plain)
                .font(ZiveStyle.FontBook.regular(11))
                .foregroundStyle(ZiveStyle.ColorPalette.white.opacity(0.86))
                .underline()

            Text(" and ")
                .font(ZiveStyle.FontBook.regular(11))
                .foregroundStyle(ZiveStyle.ColorPalette.white.opacity(0.7))

            Button("Privacy Policy") {
                weioZwivbeNavigator.weioZwivbePush(.sedivaoBeiwWeb("https://app.8acgspbj.link/privacy"))
            }
                .buttonStyle(.plain)
                .font(ZiveStyle.FontBook.regular(11))
                .foregroundStyle(ZiveStyle.ColorPalette.white.opacity(0.86))
                .underline()
        }
    }

    private func eiwoqcZceioGuideButton(title: String) -> some View {
        Group {
            if title == "Login by email" {
                Button {
                    if !eiwoqcZceioIsAgreeEula {
                        eiwoqcZceioGuideShowEULA = true
                        return
                    }
                    if !eiwoqcZceioGuideAgreeTerms {
                        eiwoqcZeicLoToast.ziveGlobalFeedbackShowToast(text: "Please read and agree to the User Agreement and Privacy Policy first.")
                        return
                    }
                    weioZwivbeNavigator.weioZwivbePush(.skillProgressionSignIn)
                } label: {
                    eiwoqcZceioGuideButtonLabel(title: title)
                }
                .buttonStyle(.plain)
            } else if title == "I’m new" {
                Button {
                    if !eiwoqcZceioIsAgreeEula {
                        eiwoqcZceioGuideShowEULA = true
                        return
                    }
                    if !eiwoqcZceioGuideAgreeTerms {
                        eiwoqcZeicLoToast.ziveGlobalFeedbackShowToast(text: "Please read and agree to the User Agreement and Privacy Policy first.")
                        return
                    }
                    Task {
                        await eiwoqcZceioGuideGuestLogin()
                    }
                } label: {
                    eiwoqcZceioGuideButtonLabel(title: title)
                }
                .buttonStyle(.plain)
            } else {
                Button(action: {}) {
                    eiwoqcZceioGuideButtonLabel(title: title)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func eiwoqcZceioGuideButtonLabel(title: String) -> some View {
        Text(title)
            .font(ZiveStyle.FontBook.boldItalic(20))
            .foregroundStyle(ZiveStyle.ColorPalette.white.opacity(0.92))
            .frame(maxWidth: .infinity)
            .frame(height: 45)
            .background(Color.white.opacity(0.24))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private func eiwoqcZceioGuideGuestLogin() async {
        let eiwoqcZceioGuideGuestUser = OrbitUserModel(
            id: "guest_\(UUID().uuidString)",
            orbitUserEmail: "",
            orbitUserPassword: "",
            orbitUserAvatar: "http://huanniuchat.oss-accelerate.aliyuncs.com/Zive2026/ZIVEDefaultAva.png",
            orbitUserName: "Guest",
            orbitUserFollowerIds: [],
            orbitUserFollowingIds: [],
            orbitUserBlockedIds: [],
            orbitUserLikedVideoIds: [],
            orbitUserCoinCount: 0,
            orbitUserReceivedGiftValue: 0
        )

        await MainActor.run {
            eiwoqcZeicLoToast.ziveGlobalFeedbackShowLoading(text: "Entering...")
        }

        await delay(1)

        await MainActor.run {
            eiwoqcZceioGuideUserStore.orbitUserCreate(eiwoqcZceioGuideGuestUser)
            QeixbgBriwyState.qeixbgBriwyCurrentUserId = eiwoqcZceioGuideGuestUser.id
            eiwoqcZeicLoToast.ziveGlobalFeedbackHideLoading()
            weioZwivbeNavigator.weioZwivbePresentRoot(.pulseVistaHome)
        }
    }
}

#Preview {
    EiwoqcZceioGuide()
}
