//
//  SwimLogApp.swift
//  SwimLog
//
//  Created by JeongHwan Seok on 1/22/26.
//

import SwiftUI
//import SwiftData

@main
struct SwimLogApp: App {
//    var sharedModelContainer: ModelContainer = {
//        let schema = Schema([
//            Item.self,
//        ])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//
//        do {
//            return try ModelContainer(for: schema, configurations: [modelConfiguration])
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }()
    
    @StateObject var poolTrackerViewModel = PoolTrackerViewModel()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                // 하위의 모든 뷰가 이 객체를 공유합니다.
                .environmentObject(poolTrackerViewModel)
        }
//        .modelContainer(sharedModelContainer)
    }
}
