//
//  OriginalToDo.swift
//  TaskFlow
//
//  Created by Anish Pun on 9.12.2024.
//

import SwiftUI
import SwiftData

class OriginalToDo {
    var title: String
    var timestamp: Date
    var isCritical: Bool
    
    init(item: ToDoItem) {
        self.title = item.title
        self.timestamp = item.timestamp
        self.isCritical = item.isCritical
    }
}

