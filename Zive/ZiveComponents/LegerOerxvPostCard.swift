import SwiftUI

struct LegerOerxvPostCard: View {
    let legerOerxvPostCardVideo: ReelVideoModel
    @EnvironmentObject private var legerOerxvPostCardUserStore: OrbitUserStore
    @EnvironmentObject private var legerOerxvPostCardVideoStore: ReelVideoStore
    @EnvironmentObject private var legerOerxvPostCardCommentStore: EchoCommentStore
    @EnvironmentObject private var legerOerxvPostCardGuestGate: CBnxweZGoLogCenter
    @EnvironmentObject var legerOerxvNavi: WeioZwivbeNavigator

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            
            LinearGradient(
                colors: [
                    Color.clear,
                    Color.black.opacity(0.18),
                    Color.black.opacity(0.5)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 238)
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            
            ZiveSmartImage(ziveSmartImagePath: legerOerxvPostCardVideo.reelVideoCoverUrl)
                .frame(height: 238)
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .overlay{
                    Image("ZIVEPlay")
                        .resizable()
                        .frame(width: 24, height: 24)
                }

            
            HStack{
                Spacer()
                Image("ZIVEPostCardDecor")
                    .resizable()
                    .frame(width: 149, height: 238)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 8) {
                    Button {
                        legerOerxvPostCardGuestGate.CBnxweZGoLogRequireLogin {
                            legerOerxvPostCardToggleLike()
                        }
                    } label: {
                        legerOerxvPostCardMetricPill(
                            systemImage: nil,
                            imageName: legerOerxvPostCardIsLiked ? "ZIVELike" : "ZIVELikeNo",
                            value: legerOerxvPostCardVideo.reelVideoLikeCount,
                            isHighlighted: legerOerxvPostCardIsLiked
                        )
                    }
                    .buttonStyle(.plain)

                    legerOerxvPostCardMetricPill(
                        systemImage: nil,
                        imageName: "ZIVEComment",
                        value: legerOerxvPostCardCommentCount
                    )

                    Spacer()
                    ZStack(alignment: .bottomLeading){
                        HStack{
                            Text("\(legerOerxvPostCardVideo.reelVideoGiftValue)")
                                .font(ZiveStyle.FontBook.italic(14))
                                .foregroundStyle(ZiveStyle.ColorPalette.textPink)
                                .padding(.leading, 36)
                                .padding(.trailing, 8)
                                .padding(.vertical, 4)
                        }.background(
                            Capsule()
                                .fill(.black.opacity(0.6))
                        )
                        Image("ZIVEGiftIcon")
                            .resizable()
                            .frame(width: 32, height: 32)
                    }
                }
                .padding(.horizontal, 16)

                HStack {
                    VStack(alignment: .leading, spacing: 4) {

                        Text(legerOerxvPostCardVideo.reelVideoContent)
                            .font(ZiveStyle.FontBook.regular(14))
                            .foregroundStyle(Color.white.opacity(0.94))
                            .fixedSize(horizontal: false, vertical: true)
                            .lineLimit(2)
                    }

                    Spacer()
                }
                .padding(.vertical, 8)
                .padding(.leading, 16)
                .padding(.trailing, 100)
                .background(
                    Rectangle().fill(Color.black.opacity(0.6))
                )
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .contentShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .onTapGesture {
            legerOerxvNavi.weioZwivbePush(
                .stagePulseVideoDetail(legerOerxvPostCardVideo.id)
            )
        }
    }

    private func legerOerxvPostCardMetricPill(
        systemImage: String?,
        imageName: String?,
        value: Int,
        isHighlighted: Bool = false
    ) -> some View {
        HStack(spacing: 5) {
            if let systemImage {
                Image(systemName: systemImage)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(isHighlighted ? ZiveStyle.ColorPalette.brandPink : Color.white)
            }

            if let imageName {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 15, height: 15)
            }

            Text("\(value)")
                .font(ZiveStyle.FontBook.regular(14))
                .foregroundStyle(Color.white)
        }
        .padding(.horizontal, 10)
        .frame(height: 28)
        .background(Color.black.opacity(0.32))
        .clipShape(Capsule())
    }

    private var legerOerxvPostCardCommentCount: Int {
        legerOerxvPostCardCommentStore
            .echoCommentFetchByVideoId(legerOerxvPostCardVideo.id)
            .count
    }

    private var legerOerxvPostCardPublisherName: String? {
        legerOerxvPostCardUserStore
            .orbitUserFetch(by: legerOerxvPostCardVideo.reelVideoPublisherId)?
            .orbitUserName
    }

    private var legerOerxvPostCardCurrentUserId: String {
        QeixbgBriwyState.qeixbgBriwyCurrentUserId
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var legerOerxvPostCardIsLiked: Bool {
        guard !legerOerxvPostCardCurrentUserId.isEmpty,
              let legerOerxvPostCardCurrentUser = legerOerxvPostCardUserStore.orbitUserFetch(by: legerOerxvPostCardCurrentUserId) else {
            return false
        }

        return legerOerxvPostCardCurrentUser.orbitUserLikedVideoIds.contains(legerOerxvPostCardVideo.id)
    }

    private func legerOerxvPostCardToggleLike() {
        guard !legerOerxvPostCardCurrentUserId.isEmpty,
              let legerOerxvPostCardDidLike = legerOerxvPostCardUserStore.orbitUserToggleLikedVideo(
                userId: legerOerxvPostCardCurrentUserId,
                videoId: legerOerxvPostCardVideo.id
              ) else {
            return
        }

        legerOerxvPostCardVideoStore.reelVideoAdjustLikeCount(
            videoId: legerOerxvPostCardVideo.id,
            delta: legerOerxvPostCardDidLike ? 1 : -1
        )
    }
}
