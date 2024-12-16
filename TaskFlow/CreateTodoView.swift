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
    
    @State var item = ToDoItem()
    @State var selectedCategory: Category?
    @StateObject private var languageManager = LanguageManager()
    
    var body: some View {
        List {
            
            Section(NSLocalizedString("to_do_title", comment: "To-do title section")) {
                TextField(NSLocalizedString("name", comment: "To-do title placeholder"), text: $item.title)
            }
            
            Section(NSLocalizedString("general", comment: "General section")) {
                DatePicker(NSLocalizedString("choose_date", comment: "Choose a date label"),
                           selection: $item.timestamp)
                Toggle(NSLocalizedString("important", comment: "Important toggle label"), isOn: $item.isCritical)
            }
            
            Section(NSLocalizedString("select_category", comment: "Select category section")) {
                
                if categories.isEmpty {
                    ContentUnavailableView(NSLocalizedString("no_categories", comment: "Message when no categories exist"),
                                           systemImage: "archivebox")
                } else {
                    Picker("", selection: $selectedCategory) {
                        
                        ForEach(categories) { category in
                            Text(category.title)
                                .tag(category as Category?)
                        }
                        
                        Text(NSLocalizedString("none", comment: "None option in category picker"))
                            .tag(nil as Category?)
                    }
                    .labelsHidden()
                    .pickerStyle(.inline)
                }
            }

            Section {
                Button(NSLocalizedString("create", comment: "Create button title")) {
                    save()
                    dismiss()
                }
            }

        }
        .navigationTitle(NSLocalizedString("create_todo", comment: "Navigation title for create to-do"))
        .toolbar {
            
            ToolbarItem(placement: .cancellationAction) {
                Button(NSLocalizedString("dismiss", comment: "Dismiss button title")) {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .primaryAction) {
                Button(NSLocalizedString("done", comment: "Done button title")) {
                    save()
                    dismiss()
                }
                .disabled(item.title.isEmpty)
            }
        }
    }
}

private extension CreateTodoView {
    
    func save() {
        modelContext.insert(item)
        item.category = selectedCategory
        selectedCategory?.items?.append(item)
    }
}

#Preview {
    NavigationStack {
        CreateTodoView()
            .modelContainer(for: ToDoItem.self)
    }
}

