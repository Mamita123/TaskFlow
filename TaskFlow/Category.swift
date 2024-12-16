//
//  Category.swift
//  TaskFlowmake
//
//  Created by Anish Pun on 9.12.2024.
//

import Foundation
import SwiftData

@Model
final class Category {
    
    @Attribute(.unique)
    var title: String
    
    var items: [ToDoItem]?
    
    // Localization in the initializer.
    // Fetches the localized string based on the title provided (which is assumed to be a key).
    init(title: String = "") {
        // Assuming the title passed is a key in Localizable.strings
        self.title = NSLocalizedString(title, comment: "Category title")
    }
}
