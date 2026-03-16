//
//  Date+Extension.swift
//  SwimLog
//
//  Created by JeongHwan Seok on 3/6/26.
//

import Foundation

extension Date {
    // 1. 해당 월의 첫 번째 날 구하기
    func startOfMonth(using calendar: Calendar) -> Date {
        calendar.date(from: calendar.dateComponents([.year, .month], from: self)) ?? self
    }

    // 2. 해당 월의 1일이 무슨 요일인지 구하기 (1: 일요일, 2: 월요일...)
    func firstWeekdayOfMonth(using calendar: Calendar) -> Int {
        calendar.component(.weekday, from: self.startOfMonth(using: calendar))
    }

    // 3. 해당 월이 총 며칠인지 구하기
    func numberOfDaysInMonth(using calendar: Calendar) -> Int {
        calendar.range(of: .day, in: .month, for: self)?.count ?? 30
    }
}
