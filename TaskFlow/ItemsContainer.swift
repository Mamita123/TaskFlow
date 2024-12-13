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
            Category.defaults.forEach {
                container.mainContext.insert($0)
            }
        }

        return container
    }
    
}
