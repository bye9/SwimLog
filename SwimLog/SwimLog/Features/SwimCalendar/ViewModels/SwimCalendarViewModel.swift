//
//  SwimCalendarViewModel.swift
//  SwimLog
//
//  Created by JeongHwan Seok on 3/6/26.
//

import Foundation
import Combine

class SwimCalendarViewModel: ObservableObject {
    @Published var selectedMonth: Date = Date() // 현재 날짜 기준
    @Published var selectedDate: Date? = nil // 사용자가 클릭한 날짜
    @Published var isShowingDetail: Bool = false // 시트 표시 여부
    
    private let calendar = Calendar.current
    
    let todayComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
    
    // 이번 달에 해당하는 기록들만 필터링
    func currentMonthRecords(allRecords: [SwimRecord]) -> [SwimRecord] {
        allRecords.filter { record in
            calendar.isDate(record.date, equalTo: selectedMonth, toGranularity: .month)
        }
    }
    
    // 총 수영 거리 계산 (km 단위)
    func totalDistance(allRecords: [SwimRecord]) -> Double {
        let meters = currentMonthRecords(allRecords: allRecords).reduce(0) { $0 + $1.distance }
        return meters / 1000.0
    }
    
    func generateDays(allRecords: [SwimRecord]) -> [DayModel] {
        // 1일 전까지의 빈칸 수
        let startOffset = selectedMonth.firstWeekdayOfMonth(using: calendar) - 1
        
        // 이번 달 총 일수
        let numberOfDays = selectedMonth.numberOfDaysInMonth(using: calendar)
        
        var days = [DayModel]()
        
        for i in 0..<startOffset {
            days.append(DayModel(
                id: "empty-\(i)",
                day: nil,
                isToday: false,
                isSelected: false,
                hasRecord: false)
            )
        }
        
        let isCurrentMonth = isShowingCurrentMonth()
        
        for day in 1...numberOfDays {
            // 해당 루프의 실제 Date 객체 생성
            guard let currentDate = calendar.date(byAdding: .day, value: (day - 1), to: selectedMonth.startOfMonth(using: calendar)) else { continue }
            
            // 기록 여부 확인
            let hasRecord = allRecords.contains { record in
                calendar.isDate(record.date, inSameDayAs: currentDate)
            }
            // 오늘 여부 확인
            let isToday = (day == todayComponents.day && isCurrentMonth)
            // 선택 여부 확인
            var isSelected = false
            if let selected = selectedDate {
                isSelected = calendar.isDate(selected, inSameDayAs: currentDate)
            }
            
            days.append(DayModel(
                id: currentDate.formatted(.dateTime.year().month().day()),
                day: day,
                isToday: isToday,
                isSelected: isSelected,
                hasRecord: hasRecord
            ))
        }
        
        return days
    }
    
    // 현재 보고 있는 달이 이번 달인지
    private func isShowingCurrentMonth() -> Bool {
        let selected = calendar.dateComponents([.year, .month], from: selectedMonth)
        return selected.year == todayComponents.year && selected.month == todayComponents.month
    }
    
    // 달력 이동 로직
    func moveToPreviousMonth() {
        if let prevMonth = calendar.date(byAdding: .month, value: -1, to: selectedMonth) {
            selectedMonth = prevMonth
        }
    }

    func moveToNextMonth() {
        if let nextMonth = calendar.date(byAdding: .month, value: 1, to: selectedMonth) {
            selectedMonth = nextMonth
        }
    }
    
    // 날짜 클릭 시 실행될 함수
    func selectDay(_ day: Int) {
        // 현재 달의 1일에서 (day-1)만큼 더해 클릭한 날짜 객체 생성
        if let targetDate = calendar.date(byAdding: .day, value: day - 1, to: selectedMonth.startOfMonth(using: calendar)) {
            self.selectedDate = targetDate
            self.isShowingDetail = true
        }
    }
}

extension SwimCalendarViewModel {
    struct DayModel: Identifiable {
        let id: String
        let day: Int?
        let isToday: Bool
        let isSelected: Bool
        let hasRecord: Bool
        
        // 뷰모델에서 뷰의 상태를 결정해서 넘겨준다.
        var status: DayStatus {
            hasRecord ? .recorded : .none
        }
    }
}
