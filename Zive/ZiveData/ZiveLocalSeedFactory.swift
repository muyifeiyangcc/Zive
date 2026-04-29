import Foundation

enum ZiveLocalSeedFactory {
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
                orbitUserAvatar: "http://huanniuchat.oss-accelerate.aliyuncs.com/Zive2026/ZIVEAEAvat_0.jpg",
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
                orbitUserAvatar: "http://huanniuchat.oss-accelerate.aliyuncs.com/Zive2026/ZIVEAEAvat_1.jpg",
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
                orbitUserAvatar: "http://huanniuchat.oss-accelerate.aliyuncs.com/Zive2026/ZIVEAEAvat_2.jpg",
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
                orbitUserAvatar: "http://huanniuchat.oss-accelerate.aliyuncs.com/Zive2026/ZIVEAEAvat_3.jpg",
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
                orbitUserAvatar: "http://huanniuchat.oss-accelerate.aliyuncs.com/Zive2026/ZIVEAEAvat_4.jpg",
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
                orbitUserAvatar: "http://huanniuchat.oss-accelerate.aliyuncs.com/Zive2026/ZIVEAEAvat_5.jpg",
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
                reelVideoCoverUrl: "http://huanniuchat.oss-accelerate.aliyuncs.com/Zive2026/ZIVEWUADance_cover_0.png",
                reelVideoUrl: "http://huanniuchat.oss-accelerate.aliyuncs.com/Zive2026/ZIVEWUADance_0.mp4",
                reelVideoContent: "this dance already a year old",
                reelVideoLikeCount: 352,
                reelVideoGiftValue: 0
            ),
            ReelVideoModel(
                id: "video_002",
                reelVideoPublisherId: "user_002",
                reelVideoCoverUrl: "http://huanniuchat.oss-accelerate.aliyuncs.com/Zive2026/ZIVEWUADance_cover_1.png",
                reelVideoUrl: "http://huanniuchat.oss-accelerate.aliyuncs.com/Zive2026/ZIVEWUADance_1.mp4",
                reelVideoContent: "this one so smooth",
                reelVideoLikeCount: 854,
                reelVideoGiftValue: 0
            ),
            ReelVideoModel(
                id: "video_003",
                reelVideoPublisherId: "user_003",
                reelVideoCoverUrl: "http://huanniuchat.oss-accelerate.aliyuncs.com/Zive2026/ZIVEWUADance_cover_2.png",
                reelVideoUrl: "http://huanniuchat.oss-accelerate.aliyuncs.com/Zive2026/ZIVEWUADance_2.mp4",
                reelVideoContent: "Finally, we all got together to perform this dance.",
                reelVideoLikeCount: 613,
                reelVideoGiftValue: 0
            ),
            ReelVideoModel(
                id: "video_004",
                reelVideoPublisherId: "user_004",
                reelVideoCoverUrl: "http://huanniuchat.oss-accelerate.aliyuncs.com/Zive2026/ZIVEWUADance_cover_3.png",
                reelVideoUrl: "http://huanniuchat.oss-accelerate.aliyuncs.com/Zive2026/ZIVEWUADance_3.mp4",
                reelVideoContent: "What do you think of this dance?",
                reelVideoLikeCount: 96,
                reelVideoGiftValue: 0
            ),
            ReelVideoModel(
                id: "video_005",
                reelVideoPublisherId: "user_005",
                reelVideoCoverUrl: "http://huanniuchat.oss-accelerate.aliyuncs.com/Zive2026/ZIVEWUADance_cover_4.png",
                reelVideoUrl: "http://huanniuchat.oss-accelerate.aliyuncs.com/Zive2026/ZIVEWUADance_4.mp4",
                reelVideoContent: "cause I love this dance so much",
                reelVideoLikeCount: 362,
                reelVideoGiftValue: 0
            ),
            ReelVideoModel(
                id: "video_006",
                reelVideoPublisherId: "user_006",
                reelVideoCoverUrl: "http://huanniuchat.oss-accelerate.aliyuncs.com/Zive2026/ZIVEWUADance_cover_5.png",
                reelVideoUrl: "http://huanniuchat.oss-accelerate.aliyuncs.com/Zive2026/ZIVEWUADance_5.mp4",
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
