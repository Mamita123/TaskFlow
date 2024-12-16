//
//  ItemsContainer.swift
//  TaskFlow
//
//  Created by Anish Pun on 10.12.2024.
//

import Foundation
import SwiftData

actor ItemsContainer {
    
    @MainActor
    static func create(shouldCreateDefaults: inout Bool) -> ModelContainer {
        let schema = Schema([Category.self, ToDoItem.self])
        let configuration = ModelConfiguration()
        let container = try! ModelContainer(for: schema, configurations: [configuration])
        
        if shouldCreateDefaults == false {
            shouldCreateDefaults = true
            // Optionally, you can handle setup logic here if required, like logging or showing a guide.
        }

        return container
    }
}
