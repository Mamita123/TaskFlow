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
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: ToDoItem.self)
        }
    }
}

