//
//  SettingsView.swift
//  SwimLog
//
//  Created by JeongHwan Seok on 1/28/26.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    
    private let range: ClosedRange<Double> = 10...500
    private let step: Double = 10
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // 1. 월 목표 거리 설정
                    goalSettingCard
                    
                    // 2. HealthKit 권한 상태
                    healthKitCard
                    
                    // 3. 앱 정보
                    appInfoCard
                }
                .padding()
            }
            .navigationTitle("설정")
            .background(Color(.systemGroupedBackground))
        }
        .task {
            await viewModel.loadAuthorizationStatus()
        }
    }
    
    // MARK: - 월 목표 카드
    
    private var goalSettingCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("월 목표 거리", systemImage: "target")
                .font(.headline)
                .foregroundColor(.primary)
            
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text("\(Int(viewModel.monthlyGoalDistance))")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundStyle(.cyan)
                    .contentTransition(.numericText())
                Text("km")
                    .font(.title3.weight(.medium))
                    .foregroundStyle(.secondary)
            }
            
            Slider(value: $viewModel.monthlyGoalDistance, in: range, step: step)
                .tint(.cyan)
        }
        .padding(20)
        .cardBackground()
    }
    
    // MARK: - HealthKit 권한 카드
    
    private var healthKitCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("건강 데이터 연동", systemImage: "heart.fill")
                .font(.headline)
            
            HStack {
                Text("권한 상태")
                    .foregroundStyle(.secondary)
                Spacer()
                Text(viewModel.authorizationStateText)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.cyan)
            }
            
            Button(action: viewModel.openSettings) {
                HStack {
                    Text("건강 앱 열기")
                    Spacer()
                    Image(systemName: "arrow.up.right.square")
                }
                .font(.subheadline)
                .foregroundStyle(.cyan)
            }
            
            // 안내 텍스트
            Text("건강 앱 > 프로필 > 앱 > SwimLog 에서 권한을 변경할 수 있어요.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineSpacing(2)
        }
        .padding(20)
        .cardBackground()
    }
    
    // MARK: - 앱 정보 카드
    
    private var appInfoCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("앱 정보", systemImage: "info.circle")
                .font(.headline)
            
            HStack {
                Text("버전")
                    .foregroundStyle(.secondary)
                Spacer()
                Text(viewModel.appVersion)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(20)
        .cardBackground()
    }
}



// MARK: - 카드 배경 스타일

private extension View {
    func cardBackground() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.03), radius: 10, x: 0, y: 5)
            )
    }
}

#Preview {
    SettingsView()
}
