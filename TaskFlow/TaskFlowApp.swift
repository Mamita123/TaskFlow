//
//  TaskFlowApp.swift
//  TaskFlow
//
//  Created by Anish Pun on 28.11.2024.
//

import SwiftUI
import SwiftData

@main
struct TaskFlowApp: App {
    
    // @AppStorage("isFirstTimeLaunch") private var isFirstTimeLaunch: Bool = false
    @StateObject private var languageManager = LanguageManager()

    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(languageManager)
        }
        .modelContainer(ItemsContainer.create())
    }
}

