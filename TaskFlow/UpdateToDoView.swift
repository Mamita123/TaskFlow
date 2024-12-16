//
//  UpdateToDoView.swift
//  TaskFlow
//
//  Created by Hafiz Dakin on 4.12.2024.
//

import SwiftUI
import SwiftData

struct UpdateToDoView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Query private var categories: [Category]
    
    @State var selectedCategory: Category?

    @Bindable var item: ToDoItem

    var body: some View {
        List {
            
            Section(NSLocalizedString("to_do_title", comment: "To do title")) {
                TextField(NSLocalizedString("name", comment: "Name"), text: $item.title)
            }
            
            Section(NSLocalizedString("general", comment: "General")) {
                DatePicker(NSLocalizedString("choose_a_date", comment: "Choose a date"),
                           selection: $item.timestamp)
                Toggle(NSLocalizedString("important", comment: "Important?"), isOn: $item.isCritical)
            }
            
            Section(NSLocalizedString("select_a_category", comment: "Select A Category")) {
                
                if categories.isEmpty {
                    ContentUnavailableView(NSLocalizedString("no_categories", comment: "No Categories"),
                                           systemImage: "archivebox")
                } else {
                    Picker("", selection: $selectedCategory) {
                        ForEach(categories) { category in
                            Text(category.title)
                                .tag(category as Category?)
                        }
                        Text(NSLocalizedString("none", comment: "None"))
                            .tag(nil as Category?)
                    }
                    .labelsHidden()
                    .pickerStyle(.inline)
                }
            }
            
            Section {
                Button(NSLocalizedString("update_button", comment: "Update")) {
                    item.category = selectedCategory
                    dismiss()
                }
            }
        }
        .navigationTitle(NSLocalizedString("update_todo_title", comment: "Update ToDo"))
        .onAppear(perform: {
            selectedCategory = item.category
        })
    }
}

#Preview {
    UpdateToDoView(item: ToDoItem.dummy)
        .modelContainer(for: ToDoItem.self)
}


