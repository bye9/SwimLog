//
//  LogView.swift
//  SwimLog
//
//  Created by JeongHwan Seok on 1/23/26.
//

import SwiftUI

struct LogView: View {
    var body: some View {
        NavigationStack {
            List(0..<5) { item in
                HStack {
                    VStack(alignment: .leading) {
                        Text("1.5 km 수영").font(.headline)
                        Text("2024년 1월 20일").font(.subheadline).foregroundStyle(.secondary)
                    }
                    Spacer()
                    Text("45:00").bold()
                }
                .listRowBackground(Color.white.opacity(0.5))
            }
            .navigationTitle("Journey Log")
            .background(Color(white: 0.98))
            .scrollContentBackground(.hidden)
        }
    }
}
