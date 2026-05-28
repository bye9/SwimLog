//
//  GoalSettingView.swift
//  SwimLog
//
//  Created by JeongHwan Seok on 5/28/26.
//

import SwiftUI

struct GoalSettingView: View {
    @Binding var monthlyGoal: Double
    let onComplete: () -> Void
    
    var body: some View {
        VStack {
            Text("목표 설정 페이지")
                .font(.title)
            Text("\(Int(monthlyGoal)) km")
            Button("완료", action: onComplete)
                .buttonStyle(.borderedProminent)
                .padding(.top)
        }
    }
}
