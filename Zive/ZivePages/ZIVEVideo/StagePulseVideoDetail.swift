import SwiftUI
import AVFoundation
import UIKit

struct StagePulseVideoDetail: View {
    let stagePulseVideoDetailVideoId: String
    @State private var stagePulseVideoDetailShowComments = false
    @State private var stagePulseVideoDetailShowGifts = false
    @State private var stagePulseVideoDetailShowGiftConfirmDialog = false
    @State private var stagePulseVideoDetailSelectedGift: StagePulseGiftOption?
    @State private var stagePulseVideoDetailPlayer: AVPlayer?
    @State private var stagePulseVideoDetailIsPlaying = false
    @State private var stagePulseVideoDetailIsPreparingVideo = true
    @State private var stagePulseVideoDetailIsVideoReady = false
    @State private var stagePulseVideoDetailLoopObserver: NSObjectProtocol?
    @State private var stagePulseVideoDetailPlayerStatusObserver: NSKeyValueObservation?
    @State private var stagePulseVideoDetailPlayerKeepUpObserver: NSKeyValueObservation?
    @State private var stagePulseVideoDetailPlayerBufferEmptyObserver: NSKeyValueObservation?
    @State private var stagePulseVideoDetailFirstFrameTask: Task<Void, Never>?
    @State private var stagePulseVideoDetailLoadingTimeoutTask: Task<Void, Never>?
    @EnvironmentObject private var stagePulseVideoDetailNavigator: WeioZwivbeNavigator
    @EnvironmentObject private var stagePulseVideoDetailActionSheetCenter: TraceGlowActionSheetCenter
    @EnvironmentObject private var stagePulseVideoDetailUserStore: OrbitUserStore
    @EnvironmentObject private var stagePulseVideoDetailVideoStore: ReelVideoStore
    @EnvironmentObject private var stagePulseVideoDetailCommentStore: EchoCommentStore
    @EnvironmentObject private var stagePulseVideoDetailGuestGate: CBnxweZGoLogCenter

    var body: some View {
        ZStack {
            stagePulseVideoDetailBackground

            VStack(spacing: 0) {
                stagePulseVideoDetailTopBar
                    .padding(.horizontal, 17)
                    .padding(.top, 12)

                Spacer()
            }

            if stagePulseVideoDetailIsPreparingVideo {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.white)
                    .scaleEffect(1.35)
            } else if !stagePulseVideoDetailIsPlaying {
                Image("ZIVEPlay")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 76, height: 76)
                    .opacity(0.9)
            }

            stagePulseVideoDetailRightActions
                .padding(.trailing, 18)
                .padding(.bottom, 152)

            stagePulseVideoDetailBottomInfo

            if stagePulseVideoDetailShowComments {
                StagePulseCommentSheet(
                    stagePulseCommentSheetVideoId: stagePulseVideoDetailVideoId,
                    stagePulseCommentSheetIsPresented: $stagePulseVideoDetailShowComments
                )
                .zIndex(10)
            }

            if stagePulseVideoDetailShowGifts {
                StagePulseGiftSheet(
                    stagePulseGiftSheetVideoId: stagePulseVideoDetailVideoId,
                    stagePulseGiftSheetRecipientUserId: stagePulseVideoDetailPublisher?.id ?? "",
                    stagePulseGiftSheetIsPresented: $stagePulseVideoDetailShowGifts
                ) { stagePulseVideoDetailGift in
                    stagePulseVideoDetailSelectedGift = stagePulseVideoDetailGift
                    stagePulseVideoDetailShowGiftConfirmDialog = true
                }
                .zIndex(11)
            }

            if let stagePulseVideoDetailSelectedGift,
               stagePulseVideoDetailShowGiftConfirmDialog {
                StagePulseGiftConfirmDialog(
                    stagePulseGiftConfirmVideoId: stagePulseVideoDetailVideoId,
                    stagePulseGiftConfirmGift: stagePulseVideoDetailSelectedGift,
                    stagePulseGiftConfirmIsPresented: $stagePulseVideoDetailShowGiftConfirmDialog
                ) {
                    stagePulseVideoDetailShowGifts = false
                }
                .zIndex(12)
            }
        }
        .animation(.easeInOut(duration: 0.22), value: stagePulseVideoDetailShowComments)
        .animation(.easeInOut(duration: 0.22), value: stagePulseVideoDetailShowGifts)
        .onAppear {
            stagePulseVideoDetailConfigurePlayer()
        }
        .onChange(of: stagePulseVideoDetailVideo?.reelVideoUrl) { _ in
            stagePulseVideoDetailConfigurePlayer()
        }
        .onDisappear {
            stagePulseVideoDetailPlayer?.pause()
            stagePulseVideoDetailIsPlaying = false
            stagePulseVideoDetailClearLoadingTasks()
            stagePulseVideoDetailClearPlayerObservers()
            if let stagePulseVideoDetailLoopObserver {
                NotificationCenter.default.removeObserver(stagePulseVideoDetailLoopObserver)
                self.stagePulseVideoDetailLoopObserver = nil
            }
        }
        .navigationBarHidden(true)
    }

    private var stagePulseVideoDetailBackground: some View {
        ZStack (alignment: .bottom){
            GeometryReader { _ in
                ZStack {
                    ZiveSmartImage(
                        ziveSmartImagePath: stagePulseVideoDetailVideo?.reelVideoCoverUrl ?? ""
                    ) {
                        Color.black
                    }
                    .ignoresSafeArea()
                    Color.black.opacity(0.5)

                    if let stagePulseVideoDetailPlayer,
                       stagePulseVideoDetailIsVideoReady {
                        StagePulseVideoDetailPlayerView(stagePulseVideoDetailPlayer: stagePulseVideoDetailPlayer)
                            .ignoresSafeArea()
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    guard stagePulseVideoDetailIsVideoReady else {
                        return
                    }
                    stagePulseVideoDetailTogglePlayback()
                }
            }
            
            
            Image("ZIVEAVideoBottomBg")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
                .ignoresSafeArea()
        }.ignoresSafeArea()
    }

    private var stagePulseVideoDetailTopBar: some View {
        HStack {
            GrooveStreakTopNavigationBar(title: nil)
                .frame(width: 44)

            Spacer()

            Button {
                stagePulseVideoDetailGuestGate.CBnxweZGoLogRequireLogin {
                    stagePulseVideoDetailShowReportSheet()
                }
            } label: {
                Image("ZIVEBarReport")
                    .resizable()
                    .frame(width: 40, height: 40)
            }
            .buttonStyle(.plain)
        }
    }

    private var stagePulseVideoDetailRightActions: some View {
        VStack(alignment: .trailing, spacing: 16) {
            Button {
                stagePulseVideoDetailGuestGate.CBnxweZGoLogRequireLogin {
                    stagePulseVideoDetailToggleLike()
                }
            } label: {
                stagePulseVideoDetailActionPill(
                    imageName: stagePulseVideoDetailIsLiked ? "ZIVELike" : "ZIVELikeNo",
                    value: "\(stagePulseVideoDetailVideo?.reelVideoLikeCount ?? 0)",
                    isHighlighted: stagePulseVideoDetailIsLiked
                )
            }
            .buttonStyle(.plain)

            Button {
                stagePulseVideoDetailShowComments = true
            } label: {
                stagePulseVideoDetailActionPill(
                    imageName: "ZIVEComment",
                    value: "\(stagePulseVideoDetailCommentCount)"
                )
            }
            .buttonStyle(.plain)

            Button {
                stagePulseVideoDetailGuestGate.CBnxweZGoLogRequireLogin {
                    stagePulseVideoDetailShowGifts = true
                }
            } label: {
                ZStack(alignment: .bottomLeading){
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.black.opacity(0.6))
                        .frame(width: 105, height: 36)
                        .overlay{
                            RoundedRectangle(cornerRadius: 33)
                                .fill(
                                    LinearGradient(colors: [
                                        ZiveStyle.ColorPalette.brandOrange,
                                        ZiveStyle.ColorPalette.brandPink
                                    ], startPoint: .trailing, endPoint: .leading)
                                ).frame(width: 99, height: 30)
                                .blur(radius: 30)
                        }
                    HStack(alignment: .bottom, spacing: 6) {
                        Image("ZIVEGiftIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 48, height: 48)

                        Text("\(stagePulseVideoDetailVideo?.reelVideoGiftValue ?? 0)")
                            .font(ZiveStyle.FontBook.regular(21))
                            .foregroundStyle(ZiveStyle.ColorPalette.textPink)
                            .padding(.bottom, 7)
                    }.padding(.leading, 2)
                }
                
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
    }

    private func stagePulseVideoDetailActionPill(
        imageName: String,
        value: String,
        isHighlighted: Bool = false
    ) -> some View {
        VStack(spacing: 6) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 22, height: 22)
                .foregroundStyle(isHighlighted ? ZiveStyle.ColorPalette.brandPink : Color.white)

            Text(value)
                .font(ZiveStyle.FontBook.regular(13))
                .foregroundStyle(Color.white)
        }
        .frame(width: 58, height: 68)
        .background(Color.black.opacity(0.34))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var stagePulseVideoDetailBottomInfo: some View {
        VStack {
            Spacer()

            HStack(alignment: .top, spacing: 8) {
                ZiveSmartImage(ziveSmartImagePath: stagePulseVideoDetailPublisher?.orbitUserAvatar ?? "") {
                    RoundedRectangle(cornerRadius: 9, style: .continuous)
                        .fill(Color.white.opacity(0.18))
                }
                .frame(width: 43, height: 43)
                .clipShape(RoundedRectangle(cornerRadius: 9, style: .continuous))
                .onTapGesture {
                    guard let stagePulseVideoDetailPublisher else {
                        return
                    }

                    stagePulseVideoDetailNavigator.weioZwivbePush(
                        .echoPulseProfile(stagePulseVideoDetailPublisher.id)
                    )
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(stagePulseVideoDetailPublisher?.orbitUserName ?? "Zive User")
                        .font(ZiveStyle.FontBook.boldItalic(14))
                        .foregroundStyle(ZiveStyle.ColorPalette.textPink)

                    Text(stagePulseVideoDetailVideo?.reelVideoContent ?? "")
                        .font(ZiveStyle.FontBook.regular(12))
                        .foregroundStyle(Color.white)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()
            }
            .padding(.horizontal, 17)
            .padding(.bottom, 27)
            .background(
                LinearGradient(
                    colors: [
                        Color.clear,
                        ZiveStyle.ColorPalette.brandPink.opacity(0.65)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
        .ignoresSafeArea(edges: .bottom)
    }

    private var stagePulseVideoDetailVideo: ReelVideoModel? {
        stagePulseVideoDetailVideoStore.reelVideoFetch(by: stagePulseVideoDetailVideoId)
    }

    private var stagePulseVideoDetailPublisher: OrbitUserModel? {
        guard let stagePulseVideoDetailVideo else {
            return nil
        }

        return stagePulseVideoDetailUserStore
            .orbitUserFetch(by: stagePulseVideoDetailVideo.reelVideoPublisherId)
    }

    private var stagePulseVideoDetailCommentCount: Int {
        stagePulseVideoDetailCommentStore
            .echoCommentFetchByVideoId(stagePulseVideoDetailVideoId)
            .count
    }

    private var stagePulseVideoDetailCurrentUserId: String {
        QeixbgBriwyState.qeixbgBriwyCurrentUserId
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var stagePulseVideoDetailIsLiked: Bool {
        guard !stagePulseVideoDetailCurrentUserId.isEmpty,
              let stagePulseVideoDetailCurrentUser = stagePulseVideoDetailUserStore
                .orbitUserFetch(by: stagePulseVideoDetailCurrentUserId) else {
            return false
        }

        return stagePulseVideoDetailCurrentUser.orbitUserLikedVideoIds.contains(stagePulseVideoDetailVideoId)
    }

    private func stagePulseVideoDetailConfigurePlayer() {
        guard let stagePulseVideoDetailResolvedVideoUrl else {
            stagePulseVideoDetailPlayer?.pause()
            stagePulseVideoDetailPlayer = nil
            stagePulseVideoDetailIsPlaying = false
            stagePulseVideoDetailIsPreparingVideo = false
            stagePulseVideoDetailIsVideoReady = false
            stagePulseVideoDetailClearLoadingTasks()
            stagePulseVideoDetailClearPlayerObservers()
            return
        }

        if let stagePulseVideoDetailCurrentAsset = stagePulseVideoDetailPlayer?.currentItem?.asset as? AVURLAsset,
           stagePulseVideoDetailCurrentAsset.url == stagePulseVideoDetailResolvedVideoUrl {
            if stagePulseVideoDetailIsVideoReady {
                stagePulseVideoDetailPlayer?.play()
                stagePulseVideoDetailIsPlaying = true
                stagePulseVideoDetailIsPreparingVideo = false
            }
            return
        }

        stagePulseVideoDetailPlayer?.pause()
        stagePulseVideoDetailClearLoadingTasks()
        stagePulseVideoDetailClearPlayerObservers()
        stagePulseVideoDetailIsPreparingVideo = true
        stagePulseVideoDetailIsVideoReady = false
        stagePulseVideoDetailIsPlaying = false

        let stagePulseVideoDetailAsset = AVURLAsset(
            url: stagePulseVideoDetailResolvedVideoUrl,
            options: [
                AVURLAssetPreferPreciseDurationAndTimingKey: false
            ]
        )
        let stagePulseVideoDetailPlayerItem = AVPlayerItem(asset: stagePulseVideoDetailAsset)
        stagePulseVideoDetailPlayerItem.preferredForwardBufferDuration = stagePulseVideoDetailResolvedVideoUrl.isFileURL ? 0 : 2

        let stagePulseVideoDetailNewPlayer = AVPlayer(playerItem: stagePulseVideoDetailPlayerItem)
        stagePulseVideoDetailNewPlayer.automaticallyWaitsToMinimizeStalling = true
        stagePulseVideoDetailInstallLoopObserver(for: stagePulseVideoDetailPlayerItem, player: stagePulseVideoDetailNewPlayer)
        stagePulseVideoDetailPlayer = stagePulseVideoDetailNewPlayer

        stagePulseVideoDetailStartLoadingTimeout(for: stagePulseVideoDetailPlayerItem)
        stagePulseVideoDetailPlayerStatusObserver = stagePulseVideoDetailPlayerItem.observe(
            \.status,
            options: [.initial, .new]
        ) { _, _ in
            DispatchQueue.main.async {
                switch stagePulseVideoDetailPlayerItem.status {
                case .readyToPlay:
                    stagePulseVideoDetailIsVideoReady = true
                    stagePulseVideoDetailNewPlayer.play()
                    stagePulseVideoDetailIsPlaying = true
                    if stagePulseVideoDetailPlayerItem.isPlaybackLikelyToKeepUp
                        || stagePulseVideoDetailResolvedVideoUrl.isFileURL {
                        stagePulseVideoDetailHideLoadingAfterFirstFrame()
                    }
                case .failed:
                    stagePulseVideoDetailIsPreparingVideo = false
                    stagePulseVideoDetailIsVideoReady = false
                    stagePulseVideoDetailIsPlaying = false
                case .unknown:
                    stagePulseVideoDetailIsPreparingVideo = true
                    stagePulseVideoDetailIsVideoReady = false
                    stagePulseVideoDetailIsPlaying = false
                @unknown default:
                    stagePulseVideoDetailIsPreparingVideo = false
                    stagePulseVideoDetailIsVideoReady = false
                    stagePulseVideoDetailIsPlaying = false
                }
            }
        }
        stagePulseVideoDetailPlayerKeepUpObserver = stagePulseVideoDetailPlayerItem.observe(
            \.isPlaybackLikelyToKeepUp,
            options: [.new]
        ) { _, _ in
            DispatchQueue.main.async {
                guard stagePulseVideoDetailPlayerItem.status == .readyToPlay,
                      stagePulseVideoDetailPlayerItem.isPlaybackLikelyToKeepUp else {
                    return
                }

                stagePulseVideoDetailIsVideoReady = true
                stagePulseVideoDetailNewPlayer.play()
                stagePulseVideoDetailIsPlaying = true
                stagePulseVideoDetailHideLoadingAfterFirstFrame()
            }
        }
        stagePulseVideoDetailPlayerBufferEmptyObserver = stagePulseVideoDetailPlayerItem.observe(
            \.isPlaybackBufferEmpty,
            options: [.new]
        ) { _, _ in
            DispatchQueue.main.async {
                if stagePulseVideoDetailPlayerItem.isPlaybackBufferEmpty,
                   !stagePulseVideoDetailResolvedVideoUrl.isFileURL {
                    stagePulseVideoDetailIsPreparingVideo = true
                }
            }
        }
    }

    private func stagePulseVideoDetailHideLoadingAfterFirstFrame() {
        stagePulseVideoDetailFirstFrameTask?.cancel()
        stagePulseVideoDetailFirstFrameTask = Task {
            try? await Task.sleep(nanoseconds: 350_000_000)
            guard !Task.isCancelled else {
                return
            }

            await MainActor.run {
                guard stagePulseVideoDetailIsVideoReady else {
                    return
                }

                stagePulseVideoDetailIsPreparingVideo = false
            }
        }
    }

    private func stagePulseVideoDetailStartLoadingTimeout(for stagePulseVideoDetailPlayerItem: AVPlayerItem) {
        stagePulseVideoDetailLoadingTimeoutTask?.cancel()
        stagePulseVideoDetailLoadingTimeoutTask = Task {
            try? await Task.sleep(nanoseconds: 8_000_000_000)
            guard !Task.isCancelled else {
                return
            }

            await MainActor.run {
                guard stagePulseVideoDetailIsPreparingVideo,
                      stagePulseVideoDetailPlayer?.currentItem === stagePulseVideoDetailPlayerItem else {
                    return
                }

                stagePulseVideoDetailIsPreparingVideo = false
                stagePulseVideoDetailIsVideoReady = stagePulseVideoDetailPlayerItem.status == .readyToPlay
                stagePulseVideoDetailIsPlaying = false
                stagePulseVideoDetailPlayer?.pause()
            }
        }
    }

    private func stagePulseVideoDetailClearLoadingTasks() {
        stagePulseVideoDetailFirstFrameTask?.cancel()
        stagePulseVideoDetailFirstFrameTask = nil
        stagePulseVideoDetailLoadingTimeoutTask?.cancel()
        stagePulseVideoDetailLoadingTimeoutTask = nil
    }

    private func stagePulseVideoDetailClearPlayerObservers() {
        stagePulseVideoDetailPlayerStatusObserver = nil
        stagePulseVideoDetailPlayerKeepUpObserver = nil
        stagePulseVideoDetailPlayerBufferEmptyObserver = nil
    }

    private func stagePulseVideoDetailTogglePlayback() {
        guard let stagePulseVideoDetailPlayer else {
            return
        }

        if stagePulseVideoDetailIsPlaying {
            stagePulseVideoDetailPlayer.pause()
            stagePulseVideoDetailIsPlaying = false
        } else {
            stagePulseVideoDetailPlayer.play()
            stagePulseVideoDetailIsPlaying = true
        }
    }

    private func stagePulseVideoDetailToggleLike() {
        guard !stagePulseVideoDetailCurrentUserId.isEmpty,
              let stagePulseVideoDetailDidLike = stagePulseVideoDetailUserStore.orbitUserToggleLikedVideo(
                userId: stagePulseVideoDetailCurrentUserId,
                videoId: stagePulseVideoDetailVideoId
              ) else {
            return
        }

        stagePulseVideoDetailVideoStore.reelVideoAdjustLikeCount(
            videoId: stagePulseVideoDetailVideoId,
            delta: stagePulseVideoDetailDidLike ? 1 : -1
        )
    }

    private func stagePulseVideoDetailShowReportSheet() {
        guard let stagePulseVideoDetailPublisher,
              stagePulseVideoDetailPublisher.id != stagePulseVideoDetailCurrentUserId else {
            return
        }

        stagePulseVideoDetailActionSheetCenter.traceGlowActionSheetCenterPresent(
            targetUserId: stagePulseVideoDetailPublisher.id
        ) {
            stagePulseVideoDetailNavigator.weioZwivbePopToRoot()
        }
    }

    private var stagePulseVideoDetailResolvedVideoUrl: URL? {
        let stagePulseVideoDetailRawVideoUrl = stagePulseVideoDetailVideo?.reelVideoUrl
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        guard !stagePulseVideoDetailRawVideoUrl.isEmpty else {
            return nil
        }

        if let stagePulseVideoDetailVideoUrl = URL(string: stagePulseVideoDetailRawVideoUrl),
           let stagePulseVideoDetailScheme = stagePulseVideoDetailVideoUrl.scheme?.lowercased(),
           stagePulseVideoDetailScheme == "http"
            || stagePulseVideoDetailScheme == "https"
            || stagePulseVideoDetailScheme == "file" {
            return stagePulseVideoDetailVideoUrl
        }

        if stagePulseVideoDetailRawVideoUrl.hasPrefix("/") {
            return URL(fileURLWithPath: stagePulseVideoDetailRawVideoUrl)
        }

        return nil
    }

    private func stagePulseVideoDetailInstallLoopObserver(
        for stagePulseVideoDetailPlayerItem: AVPlayerItem,
        player stagePulseVideoDetailPlayer: AVPlayer
    ) {
        if let stagePulseVideoDetailLoopObserver {
            NotificationCenter.default.removeObserver(stagePulseVideoDetailLoopObserver)
            self.stagePulseVideoDetailLoopObserver = nil
        }

        self.stagePulseVideoDetailLoopObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: stagePulseVideoDetailPlayerItem,
            queue: .main
        ) { _ in
            stagePulseVideoDetailPlayer.seek(to: .zero)
            stagePulseVideoDetailPlayer.play()
            stagePulseVideoDetailIsPlaying = true
        }
    }
}

struct StagePulseVideoDetailPlayerView: UIViewRepresentable {
    let stagePulseVideoDetailPlayer: AVPlayer

    func makeUIView(context: Context) -> StagePulseVideoDetailPlayerContainerView {
        let stagePulseVideoDetailPlayerView = StagePulseVideoDetailPlayerContainerView()
        stagePulseVideoDetailPlayerView.stagePulseVideoDetailPlayerLayer.videoGravity = .resizeAspectFill
        stagePulseVideoDetailPlayerView.stagePulseVideoDetailPlayerLayer.player = stagePulseVideoDetailPlayer
        return stagePulseVideoDetailPlayerView
    }

    func updateUIView(_ uiView: StagePulseVideoDetailPlayerContainerView, context: Context) {
        uiView.stagePulseVideoDetailPlayerLayer.player = stagePulseVideoDetailPlayer
    }
}

final class StagePulseVideoDetailPlayerContainerView: UIView {
    override static var layerClass: AnyClass {
        AVPlayerLayer.self
    }

    var stagePulseVideoDetailPlayerLayer: AVPlayerLayer {
        layer as! AVPlayerLayer
    }
}
