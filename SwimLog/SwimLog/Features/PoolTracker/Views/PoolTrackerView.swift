//
//  PoolTrackerView.swift
//  SwimLog
//
//  Created by JeongHwan Seok on 1/23/26.
//

import SwiftUI
import SwiftData

struct PoolTrackerView: View {
    @Environment(PoolTrackerViewModel.self) private var viewModel
    @Environment(\.modelContext) private var modelContext
    //    SwiftData에서 SwimRecord 타입의 모든 인스턴스 자동 조회
    //    정렬: date 필드 기준 내림차순 (최신 기록 먼저)
    //    데이터베이스가 변경되면 자동으로 뷰 재렌더링
    @Query(sort: \SwimRecord.date, order: .reverse) private var records: [SwimRecord]
    @AppStorage("monthlyGoalDistance") private var monthlyGoalDistance: Double = 200.0
    
    var body: some View {
        ZStack(alignment: .top) {
            // 수영장 배경 및 레인
            PoolLaneView(progress: viewModel.progress(from: records, monthlyGoalDistance: monthlyGoalDistance)).ignoresSafeArea()
            
            // 상단 가독성을 위한 부드러운 그라데이션
            LinearGradient(
                colors: [Color(.systemGroupedBackground).opacity(0.8), .clear],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 200)
            .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 30) {
                    // 목표 카드 (Glassmorphism 스타일 권장)
                    GoalCardView(
                        title: "\(viewModel.currentMonthString) 목표",
                        currentDistanceInKm: viewModel.currentDistanceInKm(from: records),
                        monthlyGoalDistance: monthlyGoalDistance,
                        progress: viewModel.progress(from: records, monthlyGoalDistance: monthlyGoalDistance)
                    )
                    .padding(.top, 40)
                }
                .padding(.horizontal)
            }
            .refreshable {
                await viewModel.syncWithHealthKit(context: modelContext)
//                ViewModel이 더 이상 records를 들고 있지 않으니, SwiftData에 직접 저장하려면 ModelContext가 필요. 뷰에서 받아온 ModelContext를 ViewModel에 넘겨주는 방식.
            }
        }
        .onAppear {
            UIRefreshControl.appearance().tintColor = UIColor(Color.blue.opacity(0.3))
            
            Task { await viewModel.syncWithHealthKit(context: modelContext) }
        }
    }
}

#Preview {
    PoolTrackerView()
        .environment(PoolTrackerViewModel())
        .modelContainer(for: SwimRecord.self, inMemory: true)
}
