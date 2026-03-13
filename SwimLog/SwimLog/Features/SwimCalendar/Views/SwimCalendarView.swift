//
//  SwimCalendarView.swift
//  SwimLog
//
//  Created by JeongHwan Seok on 1/23/26.
//

import SwiftUI

struct SwimCalendarView: View {
    @EnvironmentObject var poolTrackerViewModel: PoolTrackerViewModel
    @StateObject private var swimCalendarViewModel = SwimCalendarViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    HStack(spacing: 20) {
                        Button(action: swimCalendarViewModel.moveToPreviousMonth) {
                            Image(systemName: "chevron.left")
                                .font(.title3.bold())
                                .foregroundStyle(.cyan)
                        }
                        
                        Text("\(swimCalendarViewModel.selectedMonth, format: .dateTime.year().month())")
                            .font(.title2.bold())
                        
                        Button(action: swimCalendarViewModel.moveToNextMonth) {
                            Image(systemName: "chevron.right")
                                .font(.title3.bold())
                                .foregroundStyle(.cyan)
                        }
                    }
                    
                    // 캘린더
                    SwimCalendarGridView(viewModel: swimCalendarViewModel, allRecords: poolTrackerViewModel.records)
                    
                    // 통계박스
                    HStack(spacing: 16) {
                        let monthRecords = swimCalendarViewModel.currentMonthRecords(allRecords: poolTrackerViewModel.records)
                        
                        SwimSummaryCard(
                            icon: "figure.pool.swim",
                            title: "TOTAL SWIMS",
                            value: "\(monthRecords.count)",
                            unit: "",
                            iconColor: .cyan
                        )
                        
                        SwimSummaryCard(
                            icon: "location.fill",
                            title: "DISTANCE",
                            value: String(format: "%.1f", swimCalendarViewModel.totalDistance(allRecords: poolTrackerViewModel.records)),
                            unit: "km",
                            iconColor: .cyan
                        )
                    }
                    
                }.padding()
            }
            .navigationTitle("수영 기록")
            .background(Color(.systemGroupedBackground))
        }
    }

}

#Preview {
    SwimCalendarView()
    // 프리뷰를 위한 가짜 데이터를 넣은 VM을 주입합니다.
        .environmentObject(PoolTrackerViewModel())
    
}
