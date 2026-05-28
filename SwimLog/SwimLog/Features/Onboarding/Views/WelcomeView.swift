//
//  WelcomeView.swift
//  SwimLog
//
//  Created by JeongHwan Seok on 5/28/26.
//

import SwiftUI

struct WelcomeView: View {
    let onNext: () -> Void
    
    var body: some View {
        VStack {
            Text("환영 페이지")
                .font(.title)
            Button("다음", action: onNext)
                .buttonStyle(.borderedProminent)
                .padding(.top)
        }
    }
}
