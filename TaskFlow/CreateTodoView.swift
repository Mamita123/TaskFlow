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
    
    var body: some View {
        List {
            
            Section("To do title") {
                TextField("Name", text: $item.title)
            }
            
            Section("General") {
                DatePicker("Choose a date",
                           selection: $item.timestamp)
                Toggle("Important?", isOn: $item.isCritical)
            }
            
            Section("Select A Category") {
                
                
                if categories.isEmpty {
                    
                    ContentUnavailableView("No Categories",
                                           systemImage: "archivebox")
                    
                } else {
                    Picker("", selection: $selectedCategory) {
                        
                        ForEach(categories) { category in
                            Text(category.title)
                                .tag(category as Category?)
                        }
                        
                        Text("None")
                            .tag(nil as Category?)
                    }
                    .labelsHidden()
                    .pickerStyle(.inline)
                }
                

            }

            Section {
                Button("Create") {
                    save()
                    dismiss()
                }
            }

        }
        .navigationTitle("Create ToDo")
        .toolbar {
            
            ToolbarItem(placement: .cancellationAction) {
                Button("Dismiss") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .primaryAction) {
                Button("Done") {
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
