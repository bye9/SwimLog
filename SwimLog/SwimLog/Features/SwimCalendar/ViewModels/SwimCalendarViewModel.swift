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
    private let calendar = Calendar.current
    
    let todayComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
    
    // 이 뷰모델이 나중에 HealthKit 데이터를 가져와서
    // CalendarGrid에 전달하는 역할을 하게 됩니다.
    
    struct DayModel: Identifiable {
        let id = UUID()
        let day: Int?
        let isToday: Bool
        let hasRecord: Bool
        
        // 뷰모델에서 뷰의 상태를 결정해서 넘겨준다.
        var status: DayStatus {
            hasRecord ? .recorded : .none
        }
    }
    
    func generateDays() -> [DayModel] {
        // 1일 전까지의 빈칸 수
        let startOffset = selectedMonth.firstWeekdayOfMonth(using: calendar) - 1
        
        // 이번 달 총 일수
        let numberOfDays = selectedMonth.numberOfDaysInMonth(using: calendar)
        
        var days = [DayModel]()
        
        for _ in 0..<startOffset {
            days.append(DayModel(day: nil, isToday: false, hasRecord: false))
        }
        
        let isCurrentMonth = checkSelectedMonthIsToday()
        
        for day in 1...numberOfDays {
            let isToday = (day == todayComponents.day && isCurrentMonth)
            // ✅ 지금은 테스트를 위해 5의 배수 날짜에만 기록이 있다고 가정해볼게요.
            let dummyRecord = day % 5 == 0
            days.append(DayModel(day: day, isToday: isToday, hasRecord: dummyRecord))
        }
        
        return days
    }
    
    // 현재 보고 있는 달이 이번 달인지
    private func checkSelectedMonthIsToday() -> Bool {
        let selected = calendar.dateComponents([.year, .month], from: selectedMonth)
        return selected.year == todayComponents.year && selected.month == todayComponents.month
    }
    
}
