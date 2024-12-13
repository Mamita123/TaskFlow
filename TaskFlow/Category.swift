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
            .init(title: NSLocalizedString("study_category", comment: "Study category")),
            .init(title: NSLocalizedString("travel_category", comment: "Travel category")),
            .init(title: NSLocalizedString("appointments_category", comment: "Appointments category")),
            .init(title: NSLocalizedString("reading_category", comment: "Reading category")),
            .init(title: NSLocalizedString("fitness_category", comment: "Fitness category")),
            .init(title: NSLocalizedString("shopping_category", comment: "Shopping category")),
            .init(title: NSLocalizedString("cooking_category", comment: "Cooking category")),
            .init(title: NSLocalizedString("work_category", comment: "Work category")),
            .init(title: NSLocalizedString("home_category", comment: "Home category")),
            .init(title: NSLocalizedString("relaxation_category", comment: "Relaxation category")),
            .init(title: NSLocalizedString("events_category", comment: "Events category"))
        ]
    }
}
