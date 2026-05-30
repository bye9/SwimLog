//
//  PermissionView.swift
//  SwimLog
//
//  Created by JeongHwan Seok on 5/28/26.
//

import SwiftUI

struct PermissionView: View {
    let onNext: () -> Void
    
    @Environment(PoolTrackerViewModel.self) private var viewModel
    @State private var isRequesting = false
    
    var body: some View {
         VStack(spacing: 32) {
             Spacer()
             
             // 일러스트
             Image("OnboardingIcon")
                 .resizable()
                 .scaledToFit()
                 .frame(width: 80, height: 80)
                 .shadow(color: .black.opacity(0.1), radius: 10, y: 4)
//                 .background(
//                     Circle()
//                         .fill(Color.cyan.opacity(0.1))
//                 )
             
             // 설명 텍스트 (priming)
             VStack(spacing: 12) {
                 Text("건강 데이터 접근이 필요해요")
                     .font(.system(size: 26, weight: .bold, design: .rounded))
                     .multilineTextAlignment(.center)
                 
                 Text("애플워치로 기록한 수영 데이터를\n불러오기 위해 건강 앱 접근 권한이 필요해요.\n수영 기록은 이 기기에만 저장됩니다.")
                     .font(.body)
                     .foregroundStyle(.secondary)
                     .multilineTextAlignment(.center)
                     .lineSpacing(4)
                     .padding(.horizontal, 24)
             }
             
             Spacer()
             
             // 권한 요청 버튼
             Button(action: requestPermission) {
                 HStack {
                     if isRequesting {
                         ProgressView()
                             .tint(.white)
                     } else {
                         Text("권한 허용하기")
                             .font(.headline)
                     }
                 }
                 .font(.headline)
                 .foregroundStyle(.white)
                 .frame(maxWidth: .infinity)
                 .padding(.vertical, 16)
                 .background(Color.blue)
                 .clipShape(RoundedRectangle(cornerRadius: 14))
             }
             .disabled(isRequesting)
             .padding(.horizontal, 24)
             .padding(.bottom, 8)
         }
     }
     
     private func requestPermission() {
         isRequesting = true
         Task {
             try? await viewModel.requestAuthorization()
             isRequesting = false
             onNext()
         }
     }
 }

 #Preview {
     PermissionView(onNext: {})
         .environment(PoolTrackerViewModel())
 }
