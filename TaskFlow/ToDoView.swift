//
//  ToDOView.swift
//  TaskFlow
//
//  Created by Anish Pun on 9.12.2024.
//

import SwiftUI

struct TodoView: View {
    
    let item: ToDoItem
    
    var body: some View {
        VStack(alignment: .leading) {
            
            // Display critical item with localization for the label
            if item.isCritical {
                Image(systemName: "exclamationmark.3")
                    .symbolVariant(.fill)
                    .foregroundColor(.red)
                    .font(.largeTitle)
                    .bold()
                    .accessibilityLabel(Text(LocalizedStringKey("critical_task_label"))) // Localization support for critical task
            }

            // Display the title of the task
            Text(item.title)
                .font(.largeTitle)
                .bold()
        
            // Format the date based on the user's locale
            Text("\(item.timestamp, format: Date.FormatStyle(date: .long, time: .shortened))") // Adjusted date format
                .font(.callout)
        }
        .padding()
    }
}

#Preview {
    TodoView(item: .dummy)
}
