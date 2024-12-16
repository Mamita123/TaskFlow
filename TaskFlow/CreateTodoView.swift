//
//  CreateView.swift
//  TaskFlow
//
//  Created by Hafiz Dakin on 4.12.2024.
//

import SwiftUI
import SwiftData

struct CreateTodoView: View {
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
        
    @Query private var categories: [Category]
    
    @State private var title: String = ""
    @State private var timestamp: Date = Date()
    @State private var isCritical: Bool = false
    @State private var selectedCategory: Category?

    // Filtered categories to exclude default ones
    var userCategories: [Category] {
        categories.filter { !isDefaultCategory(title: $0.title) }
    }

    var body: some View {
        List {
            Section(header: Text(NSLocalizedString("to_do_title", comment: "To Do Title"))) {
                TextField(
                    NSLocalizedString("create_todo_prompt", comment: "Enter the title here..."),
                    text: $title
                )
            }
            
            Section(header: Text(NSLocalizedString("general", comment: "General Section"))) {
                DatePicker(
                    NSLocalizedString("choose_a_date", comment: "Choose a date"),
                    selection: $timestamp
                )
                Toggle(
                    NSLocalizedString("important", comment: "Important toggle"),
                    isOn: $isCritical
                )
            }
            
            Section(header: Text(NSLocalizedString("select_a_category", comment: "Select a Category Section"))) {
                if userCategories.isEmpty {
                    ContentUnavailableView(
                        NSLocalizedString("no_categories", comment: "No Categories available"),
                        systemImage: "archivebox"
                    )
                } else {
                    Picker(NSLocalizedString("category_picker_label", comment: "Category Picker Label"), selection: $selectedCategory) {
                        ForEach(userCategories) { category in
                            Text(category.title)  // Display the localized category title directly
                                .tag(category as Category?)
                        }
                        Text(NSLocalizedString("none", comment: "None category"))
                            .tag(nil as Category?)
                    }
                    .labelsHidden()
                    .pickerStyle(.inline)
                }
            }

            Section {
                Button(NSLocalizedString("create", comment: "Create button")) {
                    save()
                    dismiss()
                }
                .disabled(title.isEmpty)
            }
        }
        .navigationTitle(NSLocalizedString("create_todo", comment: "Create ToDo Title"))
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(NSLocalizedString("dismiss", comment: "Dismiss button")) {
                    dismiss()
                }
            }
            ToolbarItem(placement: .primaryAction) {
                Button(NSLocalizedString("done", comment: "Done button")) {
                    save()
                    dismiss()
                }
                .disabled(title.isEmpty)
            }
        }
    }
}

private extension CreateTodoView {
    
    func save() {
        let newItem = ToDoItem(
            titleKey: title,  // Use localized string or user-entered text
            timestamp: timestamp,
            isCritical: isCritical,
            isCompleted: false
        )
        
        modelContext.insert(newItem)
        newItem.category = selectedCategory
        selectedCategory?.items?.append(newItem)
    }

    // Function to check if the category title matches the default ones
    func isDefaultCategory(title: String) -> Bool {
        let defaultCategoryTitles = [
            "study_category",
            "travel_category",
            "appointments_category",
            "reading_category",
            "fitness_category",
            "shopping_category",
            "cooking_category",
            "work_category",
            "home_category",
            "relaxation_category",
            "events_category"
        ]
        return defaultCategoryTitles.contains(title)
    }
}

#Preview {
    NavigationStack {
        CreateTodoView()
            .modelContainer(for: ToDoItem.self)
    }
}


