//
//  SwimRecord.swift
//  SwimLog
//
//  Created by JeongHwan Seok on 2/13/26.
//

import Foundation

struct SwimRecord: Identifiable, Hashable {
    let id: UUID
    let date: Date
    let endDate: Date
    let distance: Double
    let duration: TimeInterval
    let isAppleWatchData: Bool
    let calories: Double
    let averageHeartRate: Double
    let averagePace: Double
    
    init(id: UUID, date: Date, endDate: Date, distance: Double, duration: TimeInterval, isAppleWatchData: Bool, calories: Double, averageHeartRate: Double, averagePace: Double) {
        self.id = id
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
