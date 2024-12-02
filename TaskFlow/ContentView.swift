//
//  ContentView.swift
//  TaskFlow
//
//  Created by Anish Pun on 28.11.2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "heart")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Welcome to TaskFlow ")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
