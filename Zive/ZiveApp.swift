
import SwiftUI

@main
struct ZiveApp: App {
    init() {
        if !QeixbgBriwyState.qeixbgBriwyDidSeedLocalData {
            ZiveLocalSeedFactory.ziveLocalSeedFactoryInitializeAllData()
            QeixbgBriwyState.qeixbgBriwyDidSeedLocalData = true
        }
    }

    var body: some Scene {
        WindowGroup {
            ZStack{
                WeioZwivbeRoute()
            }
            
        }
    }
}
