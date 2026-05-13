import SwiftUI
import Combine

enum WeioZwivbeRouter: Hashable {
    case eiwoqcZceioGuide
    case sedivaoBeiwWeb(String)
    case skillProgressionSignIn
    case skillProgressionSignUp
    case skillProgressionForgotPassword
    case rhythmBloomProfile
    case pulseVistaHome
    case grooveLedgerMine
    case beatNestSettings
    case blockBeatRoster
    case stepGlowEditProfile
    case echoPulseProfile(String)
    case traceGlowReportDetail
    case chatPulseRecently
    case whisperBeatChatRoom(String)
    case tempoTrailPlanBoard
    case frameFlowUploadPost
    case stagePulseVideoDetail(String)
    case cocoaPulseWallet
}

final class WeioZwivbeNavigator: ObservableObject {
    @Published var weioZwivbeRootRoute: WeioZwivbeRouter
    @Published var weioZwivbePath = NavigationPath()

    init() {
        weioZwivbeRootRoute = WeioZwivbeNavigator.weioZwivbeResolveInitialRoute()
    }

    func weioZwivbePush(_ route: WeioZwivbeRouter) {
        weioZwivbePath.append(route)
    }

    func weioZwivbePresentRoot(_ route: WeioZwivbeRouter) {
        weioZwivbePath = NavigationPath()
        weioZwivbeRootRoute = route
    }

    func weioZwivbeReplaceStack(with route: WeioZwivbeRouter) {
        weioZwivbePath = NavigationPath()
        weioZwivbePath.append(route)
    }

    func weioZwivbePop() {
        guard !weioZwivbePath.isEmpty else { return }
        weioZwivbePath.removeLast()
    }

    func weioZwivbePopToRoot() {
        weioZwivbePath = NavigationPath()
    }

    private static func weioZwivbeResolveInitialRoute() -> WeioZwivbeRouter {
        let weioZwivbeCurrentUserId = QeixbgBriwyState.qeixbgBriwyCurrentUserId
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard !weioZwivbeCurrentUserId.isEmpty else {
            return .eiwoqcZceioGuide
        }

        let weioZwivbeUserStore = OrbitUserStore()
        guard weioZwivbeUserStore.orbitUserFetch(by: weioZwivbeCurrentUserId) != nil else {
            QeixbgBriwyState.qeixbgBriwyCurrentUserId = ""
            return .eiwoqcZceioGuide
        }

        return .pulseVistaHome
    }
}

struct WeioZwivbeRoute: View {
    @StateObject private var weioZwivbeNavigator = WeioZwivbeNavigator()
    @StateObject private var ziveGlobalFeedbackCenter = ZiveGlobalFeedbackCenter()
    @StateObject private var cbnxweZGoLogCenter = CBnxweZGoLogCenter()
    @StateObject private var traceGlowActionSheetCenter = TraceGlowActionSheetCenter()
    @StateObject private var cacoaPulseWalletIAPManager = CacoaPulseWalletIAPManager()
    @StateObject private var orbitUserStore = OrbitUserStore.shared
    @StateObject private var reelVideoStore = ReelVideoStore.shared
    @StateObject private var echoCommentStore = EchoCommentStore.shared
    @StateObject private var tempoPlanStore = TempoPlanStore.shared
    @StateObject private var rhythmRoomStore = RhythmRoomStore.shared
    @StateObject private var whisperMessageStore = WhisperMessageStore.shared
    @StateObject private var skillProgressionSignUpDraftCenter = SkillProgressionSignUpDraftCenter()

    var body: some View {
        ZStack {
            ZiveGlobalFeedbackHost {
                NavigationStack(path: $weioZwivbeNavigator.weioZwivbePath) {
                    weioZwivbeView(for: weioZwivbeNavigator.weioZwivbeRootRoute)
                        .navigationDestination(for: WeioZwivbeRouter.self) { route in
                            weioZwivbeView(for: route)
                        }
                }
            }

            if traceGlowActionSheetCenter.traceGlowActionSheetCenterIsPresented {
                TraceGlowActionSheet(
                    traceGlowActionSheetIsPresented: $traceGlowActionSheetCenter.traceGlowActionSheetCenterIsPresented,
                    traceGlowActionSheetTargetUserId: traceGlowActionSheetCenter.traceGlowActionSheetCenterTargetUserId
                ) {
                    let traceGlowActionSheetAfterBlock = traceGlowActionSheetCenter.traceGlowActionSheetCenterAfterBlock
                    traceGlowActionSheetCenter.traceGlowActionSheetCenterDismiss()
                    traceGlowActionSheetAfterBlock?()
                }
                .zIndex(100)
                .transition(.opacity)
            }

            if cbnxweZGoLogCenter.CBnxweZGoLogIsPresented {
                CBnxweZGoLog(
                    CBnxweZIsPresented: $cbnxweZGoLogCenter.CBnxweZGoLogIsPresented
                ) {
                    QeixbgBriwyState.qeixbgBriwyCurrentUserId = ""
                    weioZwivbeNavigator.weioZwivbePresentRoot(.eiwoqcZceioGuide)
                }
                .zIndex(200)
            }
        }
        .environmentObject(weioZwivbeNavigator)
        .environmentObject(ziveGlobalFeedbackCenter)
        .environmentObject(cbnxweZGoLogCenter)
        .environmentObject(traceGlowActionSheetCenter)
        .environmentObject(cacoaPulseWalletIAPManager)
        .environmentObject(orbitUserStore)
        .environmentObject(reelVideoStore)
        .environmentObject(echoCommentStore)
        .environmentObject(tempoPlanStore)
        .environmentObject(rhythmRoomStore)
        .environmentObject(whisperMessageStore)
        .environmentObject(skillProgressionSignUpDraftCenter)
        .ziveScreenBackground()
        .onAppear {
            cacoaPulseWalletIAPManager.cacoaPulseWalletFetchProducts()
        }
    }

    @ViewBuilder
    private func weioZwivbeView(for route: WeioZwivbeRouter) -> some View {
        switch route {
        case .eiwoqcZceioGuide:
            EiwoqcZceioGuide()
        case let .sedivaoBeiwWeb(sedivaoBeiwWebUrlString):
            SedivaoBeiwWeb(sedivaoBeiwWebUrlString: sedivaoBeiwWebUrlString)
        case .skillProgressionSignIn:
            SkillProgressionSign(skillProgressionSignInitialMode: .signIn)
        case .skillProgressionSignUp:
            SkillProgressionSign(skillProgressionSignInitialMode: .signUp)
        case .skillProgressionForgotPassword:
            SkillProgressionSign(skillProgressionSignInitialMode: .forgotPassword)
        case .rhythmBloomProfile:
            RhythmBloomProfile()
        case .pulseVistaHome:
            PulseVistaHome()
        case .grooveLedgerMine:
            GrooveLedgerMine()
        case .beatNestSettings:
            BeatNestSettings()
        case .blockBeatRoster:
            BlockBeatRoster()
        case .stepGlowEditProfile:
            StepGlowEditProfile()
        case let .echoPulseProfile(echoPulseProfileUserId):
            EchoPulseProfile(echoPulseProfileUserId: echoPulseProfileUserId)
        case .traceGlowReportDetail:
            TraceGlowReportDetail()
        case .chatPulseRecently:
            ChatPulseRecently()
        case let .whisperBeatChatRoom(whisperBeatChatRoomId):
            WhisperBeatChatRoom(whisperBeatChatRoomId: whisperBeatChatRoomId)
        case .tempoTrailPlanBoard:
            TempoTrailPlanBoard()
        case .frameFlowUploadPost:
            FrameFlowUploadPost()
        case let .stagePulseVideoDetail(stagePulseVideoDetailVideoId):
            StagePulseVideoDetail(stagePulseVideoDetailVideoId: stagePulseVideoDetailVideoId)
        case .cocoaPulseWallet:
            CocoaPulseWallet()
        }
    }
}
