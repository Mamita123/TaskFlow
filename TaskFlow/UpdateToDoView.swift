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
    @StateObject private var languageManager = LanguageManager()

    var body: some View {
        List {
            
            Section(NSLocalizedString("To do title", comment: "Section title for todo title")) {
                TextField(NSLocalizedString("Name", comment: "Placeholder text for todo title"), text: $item.title)
            }
            
            Section(NSLocalizedString("General", comment: "Section for general settings")) {
                DatePicker(NSLocalizedString("Choose a date", comment: "Label for date picker"),
                           selection: $item.timestamp)
                Toggle(NSLocalizedString("Important?", comment: "Label for toggle to mark as important"), isOn: $item.isCritical)
            }
            
            Section(NSLocalizedString("Select A Category", comment: "Section for category selection")) {
                
                if categories.isEmpty {
                    
                    ContentUnavailableView(NSLocalizedString("No Categories", comment: "Message when there are no categories"),
                                           systemImage: "archivebox")
                    
                } else {
                    
                    Picker("", selection: $selectedCategory) {
                        
                        ForEach(categories) { category in
                            Text(category.title)
                                .tag(category as Category?)
                        }
                        
                        Text(NSLocalizedString("None", comment: "Option when no category is selected"))
                            .tag(nil as Category?)
                    }
                    .labelsHidden()
                    .pickerStyle(.inline)
                }
            }
            
            Section {
                Button(NSLocalizedString("Update", comment: "Button title to update todo item")) {
                    item.category = selectedCategory
                    dismiss()
                }
            }
        }
        .navigationTitle(NSLocalizedString("Update ToDo", comment: "Title for the Update ToDo view"))
        .onAppear(perform: {
            selectedCategory = item.category
        })
    }
}

#Preview {
    UpdateToDoView(item: ToDoItem.dummy)
        .modelContainer(for: ToDoItem.self)
}


