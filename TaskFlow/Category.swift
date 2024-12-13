//
//  Category.swift
//  TaskFlow
//
//  Created by Anish Pun on 9.12.2024.
//

import SwiftUI
import SwiftData

@Model
class Category {
    
    @Attribute(.unique)
    var title: String
    
    var items: [ToDoItem]?
    
    init(title: String = "") {
        self.title = title
    }
}

extension Category {
    
    static var defaults: [Category] {
        [
            .init(title: "🙇🏾‍♂️ Study"),
            .init(title: "✈️ Travel"),
            .init(title: "📆 Appointments"),
            .init(title: "📖 Reading"),
            .init(title: "🏋️‍♂️ Fitness"),
            .init(title: "🛒 Shopping"),
            .init(title: "🍳 Cooking"),
            .init(title: "💻 Work"),
            .init(title: "🏠 Home"),
            .init(title: "🛏️ Relaxation"),
            .init(title: "🎉 Events")
        ]
    }
}
