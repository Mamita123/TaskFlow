//
//  CreateView.swift
//  TaskFlow
//
//  Created by Hafiz Dakin on 4.12.2024.
//

import SwiftUI

struct CreateTodoView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    
    @State private var item = ToDoItem()
    var body: some View {
        List {
            TextField("Name", text: $item.title)
            DatePicker("Choose a date",
                       selection: .constant(.now))
            Toggle("Important!", isOn: $item.isCritical)
            Button("Create"){
               withAnimation {
                    context.insert(item)
                
                }
                dismiss()
            }
        }
        .navigationTitle("Create Task")
    }
}

#Preview {
    CreateTodoView()
        .modelContainer(for: ToDoItem.self)
}
