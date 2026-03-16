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
    let distance: Double
    let duration: TimeInterval
    
    let isAppleWatchData: Bool
    
    init(id: UUID, date: Date, distance: Double, duration: TimeInterval, isAppleWatchData: Bool) {
        self.id = id
        self.date = date
        self.distance = distance
        self.duration = duration
        self.isAppleWatchData = isAppleWatchData
    }
}
