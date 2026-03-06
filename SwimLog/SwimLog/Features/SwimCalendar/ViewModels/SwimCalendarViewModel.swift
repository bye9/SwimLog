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
    
    // 이 뷰모델이 나중에 HealthKit 데이터를 가져와서
    // CalendarGrid에 전달하는 역할을 하게 됩니다.
}
