import Foundation

enum ZiveLocalSeedFactory {
    private static let ziveLocalSeedFactoryAssetBaseURL = "http://huanniuchat.oss-accelerate.aliyuncs.com/Zive2026"

    private static func ziveLocalSeedFactoryAvatarURL(_ ziveLocalSeedFactoryIndex: Int) -> String {
        "\(ziveLocalSeedFactoryAssetBaseURL)/ZIVEAEAvat_\(ziveLocalSeedFactoryIndex).jpg"
    }

    private static func ziveLocalSeedFactoryDanceCoverURL(_ ziveLocalSeedFactoryIndex: Int) -> String {
        "\(ziveLocalSeedFactoryAssetBaseURL)/ZIVEWUADance_cover_\(ziveLocalSeedFactoryIndex).png"
    }

    private static func ziveLocalSeedFactoryDanceVideoURL(_ ziveLocalSeedFactoryIndex: Int) -> String {
        "\(ziveLocalSeedFactoryAssetBaseURL)/ZIVEWUADance_\(ziveLocalSeedFactoryIndex).mp4"
    }

    static func ziveLocalSeedFactoryInitializeAllData() {
        let ziveLocalSeedFactoryUserStore = OrbitUserStore()
        let ziveLocalSeedFactoryVideoStore = ReelVideoStore()
        let ziveLocalSeedFactoryCommentStore = EchoCommentStore()
        let ziveLocalSeedFactoryPlanStore = TempoPlanStore()
        let ziveLocalSeedFactoryRoomStore = RhythmRoomStore()
        let ziveLocalSeedFactoryMessageStore = WhisperMessageStore()

        let ziveLocalSeedFactoryUsers = ziveLocalSeedFactoryUserModels()
        let ziveLocalSeedFactoryVideos = ziveLocalSeedFactoryVideoModels()
        let ziveLocalSeedFactoryComments = ziveLocalSeedFactoryCommentModels()
        let ziveLocalSeedFactoryPlans = ziveLocalSeedFactoryPlanModels()
        let ziveLocalSeedFactoryRooms = ziveLocalSeedFactoryRoomModels()
        let ziveLocalSeedFactoryMessages = ziveLocalSeedFactoryMessageModels()

        ziveLocalSeedFactoryUserStore.orbitUserReplaceAll(with: ziveLocalSeedFactoryUsers)
        ziveLocalSeedFactoryVideoStore.reelVideoReplaceAll(with: ziveLocalSeedFactoryVideos)
        ziveLocalSeedFactoryCommentStore.echoCommentReplaceAll(with: ziveLocalSeedFactoryComments)
        ziveLocalSeedFactoryPlanStore.tempoPlanReplaceAll(with: ziveLocalSeedFactoryPlans)
        ziveLocalSeedFactoryRoomStore.rhythmRoomReplaceAll(with: ziveLocalSeedFactoryRooms)
        ziveLocalSeedFactoryMessageStore.whisperMessageReplaceAll(with: ziveLocalSeedFactoryMessages)
    }

    static func ziveLocalSeedFactoryUserModels() -> [OrbitUserModel] {
        [
            OrbitUserModel(
                id: "user_001",
                orbitUserEmail: "zive@gmail.com",
                orbitUserPassword: "123456",
                orbitUserAvatar: ziveLocalSeedFactoryAvatarURL(0),
                orbitUserName: "Norris",
                orbitUserFollowerIds: ["user_002", "user_003"],
                orbitUserFollowingIds: ["user_002"],
                orbitUserBlockedIds: [],
                orbitUserLikedVideoIds: [],
                orbitUserCoinCount: 0,
                orbitUserReceivedGiftValue: 0
            ),
            OrbitUserModel(
                id: "user_002",
                orbitUserEmail: "xcei28sh@gmail.com",
                orbitUserPassword: "h498hdak4r",
                orbitUserAvatar: ziveLocalSeedFactoryAvatarURL(1),
                orbitUserName: "Perry",
                orbitUserFollowerIds: ["user_001"],
                orbitUserFollowingIds: ["user_001"],
                orbitUserBlockedIds: [],
                orbitUserLikedVideoIds: [],
                orbitUserCoinCount: 0,
                orbitUserReceivedGiftValue: 0
            ),
            OrbitUserModel(
                id: "user_003",
                orbitUserEmail: "Reed@gmail.com",
                orbitUserPassword: "asdwReed",
                orbitUserAvatar: ziveLocalSeedFactoryAvatarURL(2),
                orbitUserName: "Reed",
                orbitUserFollowerIds: [],
                orbitUserFollowingIds: ["user_001"],
                orbitUserBlockedIds: [],
                orbitUserLikedVideoIds: [],
                orbitUserCoinCount: 0,
                orbitUserReceivedGiftValue: 0
            ),
            OrbitUserModel(
                id: "user_004",
                orbitUserEmail: "Anitaasdw@gmail.com",
                orbitUserPassword: "3ujd8ahc",
                orbitUserAvatar: ziveLocalSeedFactoryAvatarURL(3),
                orbitUserName: "Anita",
                orbitUserFollowerIds: [],
                orbitUserFollowingIds: [],
                orbitUserBlockedIds: [],
                orbitUserLikedVideoIds: [],
                orbitUserCoinCount: 0,
                orbitUserReceivedGiftValue: 0
            ),
            OrbitUserModel(
                id: "user_005",
                orbitUserEmail: "Larissaasd@gmail.com",
                orbitUserPassword: "h498hdak4r",
                orbitUserAvatar: ziveLocalSeedFactoryAvatarURL(4),
                orbitUserName: "Larissa",
                orbitUserFollowerIds: [],
                orbitUserFollowingIds: [],
                orbitUserBlockedIds: [],
                orbitUserLikedVideoIds: [],
                orbitUserCoinCount: 0,
                orbitUserReceivedGiftValue: 0
            ),
            OrbitUserModel(
                id: "user_006",
                orbitUserEmail: "xcwj3ish@gmail.com",
                orbitUserPassword: "ac82halkxc",
                orbitUserAvatar: ziveLocalSeedFactoryAvatarURL(5),
                orbitUserName: "Patty",
                orbitUserFollowerIds: [],
                orbitUserFollowingIds: [],
                orbitUserBlockedIds: [],
                orbitUserLikedVideoIds: [],
                orbitUserCoinCount: 0,
                orbitUserReceivedGiftValue: 0
            ),
        ]
    }

    static func ziveLocalSeedFactoryVideoModels() -> [ReelVideoModel] {
        [
            ReelVideoModel(
                id: "video_001",
                reelVideoPublisherId: "user_001",
                reelVideoCoverUrl: ziveLocalSeedFactoryDanceCoverURL(0),
                reelVideoUrl: ziveLocalSeedFactoryDanceVideoURL(0),
                reelVideoContent: "this dance already a year old",
                reelVideoLikeCount: 352,
                reelVideoGiftValue: 0
            ),
            ReelVideoModel(
                id: "video_002",
                reelVideoPublisherId: "user_002",
                reelVideoCoverUrl: ziveLocalSeedFactoryDanceCoverURL(1),
                reelVideoUrl: ziveLocalSeedFactoryDanceVideoURL(1),
                reelVideoContent: "this one so smooth",
                reelVideoLikeCount: 854,
                reelVideoGiftValue: 0
            ),
            ReelVideoModel(
                id: "video_003",
                reelVideoPublisherId: "user_003",
                reelVideoCoverUrl: ziveLocalSeedFactoryDanceCoverURL(2),
                reelVideoUrl: ziveLocalSeedFactoryDanceVideoURL(2),
                reelVideoContent: "Finally, we all got together to perform this dance.",
                reelVideoLikeCount: 613,
                reelVideoGiftValue: 0
            ),
            ReelVideoModel(
                id: "video_004",
                reelVideoPublisherId: "user_004",
                reelVideoCoverUrl: ziveLocalSeedFactoryDanceCoverURL(3),
                reelVideoUrl: ziveLocalSeedFactoryDanceVideoURL(3),
                reelVideoContent: "What do you think of this dance?",
                reelVideoLikeCount: 96,
                reelVideoGiftValue: 0
            ),
            ReelVideoModel(
                id: "video_005",
                reelVideoPublisherId: "user_005",
                reelVideoCoverUrl: ziveLocalSeedFactoryDanceCoverURL(4),
                reelVideoUrl: ziveLocalSeedFactoryDanceVideoURL(4),
                reelVideoContent: "cause I love this dance so much",
                reelVideoLikeCount: 362,
                reelVideoGiftValue: 0
            ),
            ReelVideoModel(
                id: "video_006",
                reelVideoPublisherId: "user_006",
                reelVideoCoverUrl: ziveLocalSeedFactoryDanceCoverURL(5),
                reelVideoUrl: ziveLocalSeedFactoryDanceVideoURL(5),
                reelVideoContent: "My current favorite song so felt fitting",
                reelVideoLikeCount: 124,
                reelVideoGiftValue: 0
            )
        ]
    }

    static func ziveLocalSeedFactoryCommentModels() -> [EchoCommentModel] {
        [
            EchoCommentModel(
                id: "comment_001",
                echoCommentVideoId: "video_001",
                echoCommentPublisherId: "user_002",
                echoCommentContent: "The body control is crazy",
                echoCommentTime: Date()
            ),
            EchoCommentModel(
                id: "comment_002",
                echoCommentVideoId: "video_002",
                echoCommentPublisherId: "user_001",
                echoCommentContent: "i have nothing appropriate to say",
                echoCommentTime: Date()
            ),
            EchoCommentModel(
                id: "comment_003",
                echoCommentVideoId: "video_003",
                echoCommentPublisherId: "user_004",
                echoCommentContent: "They jumped so high",
                echoCommentTime: Date()
            ),
            EchoCommentModel(
                id: "comment_004",
                echoCommentVideoId: "video_004",
                echoCommentPublisherId: "user_002",
                echoCommentContent: "so cool",
                echoCommentTime: Date()
            ),
            EchoCommentModel(
                id: "comment_005",
                echoCommentVideoId: "video_005",
                echoCommentPublisherId: "user_006",
                echoCommentContent: "you are so gorgeous",
                echoCommentTime: Date()
            ),
            EchoCommentModel(
                id: "comment_006",
                echoCommentVideoId: "video_006",
                echoCommentPublisherId: "user_004",
                echoCommentContent: "why is your dance so freaking clean and fast",
                echoCommentTime: Date()
            )
        ]
    }

    static func ziveLocalSeedFactoryPlanModels() -> [TempoPlanModel] {
        []
    }

    static func ziveLocalSeedFactoryRoomModels() -> [RhythmRoomModel] {
        []
    }

    static func ziveLocalSeedFactoryMessageModels() -> [WhisperMessageModel] {
        []
    }
}
