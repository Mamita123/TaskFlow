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
    
    @AppStorage("isFirstTimeLaunch") private var isFirstTimeLaunch: Bool = false
    @AppStorage("selectedLanguage") private var selectedLanguage = "en"  // Default language is English
    @State private var reloadView = false  // Trigger UI update when language changes

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.locale, Locale(identifier: selectedLanguage))  // Apply the selected locale to the environment
                .onChange(of: selectedLanguage) { _ in
                    // When the language changes, force a re-render
                    DispatchQueue.main.async {
                        reloadView.toggle()
                    }
                }
                .modelContainer(ItemsContainer.create(shouldCreateDefaults: &isFirstTimeLaunch))
        }
    }
}



