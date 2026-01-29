//
//  GoalCardView.swift
//  SwimLog
//
//  Created by JeongHwan Seok on 1/28/26.
//

import SwiftUI

struct GoalCardView: View {
    let current: Double
    let total: Double
    var progress: Double { current / total }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
        }
    }
}

#Preview {
    GoalCardView(current: 14.0, total: 20.0)
}
