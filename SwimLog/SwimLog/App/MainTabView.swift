//
//  MainTabView.swift
//  SwimLog
//
//  Created by JeongHwan Seok on 1/23/26.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            PoolTrackerView()
                .tabItem {
                    Label("Ocean", systemImage: "water.waves")
                }
                .tag(0)
            
            SwimCalendarView()
                .tabItem {
                    Label("Log", systemImage: "doc.text.magnifyingglass")
                }
                .tag(1)
            
            Text("Settings View") // 나중에 SettingsView()로 교체
                .tabItem {
                    Label("Lab", systemImage: "flask")
                }
                .tag(2)
        }
        // iOS 18 느낌의 틴트 컬러 적용
        .accentColor(.blue)
    }
}

#Preview {
    MainTabView()
}
