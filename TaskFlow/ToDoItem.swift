//
//  ToDoItem.swift
//  TaskFlow
//
//  Created by Hafiz Dakin on 4.12.2024.
//
import Foundation
import SwiftData

@Model
final class ToDoItem {
    var title: String
    var timestamp: Date
    var isCritical: Bool
    var isCompleted: Bool
    
    @Relationship(.unique, inverse: \Category.items)
    var category: Category?
    
    // SwiftData backing initializer
    init(backingData: Data) {
        self.title = ""
        self.timestamp = Date()
        self.isCritical = false
        self.isCompleted = false
    }

    // Custom initializer with localization
    init(titleKey: String,
         timestamp: Date = .now,
         isCritical: Bool = false,
         isCompleted: Bool = false) {
        self.title = NSLocalizedString(titleKey, comment: "Task title")
        self.timestamp = timestamp
        self.isCritical = isCritical
        self.isCompleted = isCompleted
    }
}

extension ToDoItem {
    static var dummy: ToDoItem {
        .init(titleKey: "dummy_task_title",  // Replace with a localized key if needed
              timestamp: .now,
              isCritical: true)
    }
}
