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
