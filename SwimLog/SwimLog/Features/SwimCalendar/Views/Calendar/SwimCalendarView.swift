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
                        Text(swimCalendarViewModel.selectedMonth.formatted(.dateTime.year().month(.wide).locale(Locale(identifier: "ko_KR"))))
                            .font(.title2.bold())
                        
                        Button(action: swimCalendarViewModel.moveToNextMonth) {
                            Image(systemName: "chevron.right")
                                .font(.title3.bold())
                                .foregroundStyle(.cyan)
                        }
                    }
                    
                    // 캘린더
                    SwimCalendarGridView(viewModel: swimCalendarViewModel, allRecords: poolTrackerViewModel.records)
                        .gesture(DragGesture(minimumDistance: 30)
                            .onEnded { value in
                                // 1. 왼쪽으로 밀면 다음 달
                                if value.translation.width < -50 {
                                    withAnimation {
                                        swimCalendarViewModel.moveToNextMonth()
                                    }
                                    
                                }
                                // 2. 오른쪽으로 밀면 이전 달
                                else if value.translation.width > 50 {
                                    withAnimation {
                                        swimCalendarViewModel.moveToPreviousMonth()
                                    }
                                }
                            }
                        )
                        .sheet(isPresented: $swimCalendarViewModel.isShowingDetail) {
                            SwimRecordDetailSheet(date: swimCalendarViewModel.selectedDate, allRecords: poolTrackerViewModel.records)
                        }
                    
                    // 통계박스
                    HStack(spacing: 16) {
                        let monthRecords = swimCalendarViewModel.currentMonthRecords(allRecords: poolTrackerViewModel.records)
                        
                        SwimSummaryCard(
                            icon: "figure.pool.swim",
                            title: "총 수영횟수",
                            value: "\(monthRecords.count)",
                            unit: "",
                            iconColor: .cyan
                        )
                        
                        SwimSummaryCard(
                            icon: "location.fill",
                            title: "총 수영거리",
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
        .environmentObject(PoolTrackerViewModel())
    
}
