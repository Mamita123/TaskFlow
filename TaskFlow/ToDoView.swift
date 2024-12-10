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
            
            if item.isCritical {
                Image(systemName: "exclamationmark.3")
                    .symbolVariant(.fill)
                    .foregroundColor(.red)
                    .font(.largeTitle)
                    .bold()
            }

            Text(item.title)
                .font(.largeTitle)
                .bold()
        
            Text("\(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                .font(.callout)
        }
        
    }
}

#Preview {
    TodoView(item: .dummy)
}
