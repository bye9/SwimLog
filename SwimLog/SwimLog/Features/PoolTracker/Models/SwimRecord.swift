//
//  SwimRecord.swift
//  SwimLog
//
//  Created by JeongHwan Seok on 2/13/26.
//

import Foundation
import SwiftData
import HealthKit

@Model
final class SwimRecord {
    // HealthKit workout의 UUID — 중복 방지 키
    @Attribute(.unique) var healthKitUUID: UUID
    
    var date: Date
    var endDate: Date
    var distance: Double          // meter
    var duration: TimeInterval
    var isAppleWatchData: Bool
    var calories: Double
    var averageHeartRate: Double
    var averagePace: Double        // m/s
    
    init(
        healthKitUUID: UUID,
        date: Date,
        endDate: Date,
        distance: Double,
        duration: TimeInterval,
        isAppleWatchData: Bool,
        calories: Double,
        averageHeartRate: Double,
        averagePace: Double
    ) {
        self.healthKitUUID = healthKitUUID
        self.date = date
        self.endDate = endDate
        self.distance = distance
        self.duration = duration
        self.isAppleWatchData = isAppleWatchData
        self.calories = calories
        self.averageHeartRate = averageHeartRate
        self.averagePace = averagePace
    }
}
