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
            .init(title: NSLocalizedString("study", comment: "Study category")),
            .init(title: NSLocalizedString("travel", comment: "Travel category")),
            .init(title: NSLocalizedString("appointments", comment: "Appointments category")),
            .init(title: NSLocalizedString("reading", comment: "Reading category")),
            .init(title: NSLocalizedString("fitness", comment: "Fitness category")),
            .init(title: NSLocalizedString("shopping", comment: "Shopping category")),
            .init(title: NSLocalizedString("cooking", comment: "Cooking category")),
            .init(title: NSLocalizedString("work", comment: "Work category")),
            .init(title: NSLocalizedString("home", comment: "Home category")),
            .init(title: NSLocalizedString("relaxation", comment: "Relaxation category")),
            .init(title: NSLocalizedString("events", comment: "Events category"))

        ]
    }
}
