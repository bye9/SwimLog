//
//  PoolTrackerViewModel.swift
//  SwimLog
//
//  Created by JeongHwan Seok on 2/3/26.
//

import Foundation
import Combine

class PoolTrackerViewModel: ObservableObject {
    // 거리 데이터
    @Published var currentDistance = 80.0
    @Published var monthlyGoalDistance = 200.0
    
    var progress: Double {
        if monthlyGoalDistance > 0 {
            return currentDistance / monthlyGoalDistance
        } else {
            return 0
        }
    }
    
    var currentDistanceString: String {
        String(format: "%.1f", currentDistance)
    }
    
    var monthlyGoalDistanceString: String {
        String(format: "%.1f", monthlyGoalDistance)
    }
    
    // 수영 기록 추가
    func addDistance(_ distance: Double) {
        if currentDistance + distance <= monthlyGoalDistance {
            currentDistance += distance
        } else {
            currentDistance = monthlyGoalDistance
        }
    }
    
    func removeDistacne(_ distance: Double) {
        if currentDistance - distance >= 0 {
            currentDistance -= distance
        }
    }
}
