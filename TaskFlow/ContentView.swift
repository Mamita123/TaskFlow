//
//  ContentView.swift
//  TaskFlow
//
//  Created by Anish Pun on 28.11.2024.
//

import SwiftUI
import SwiftData


struct ContentView: View {
    @Environment(\.modelContext) var context

    @State private var showCreate = false
    @State private var toDoToEdit: ToDoItem?
    @Query private var items: [ToDoItem]
    
    var body: some View {
        NavigationStack {
            List{
                ForEach(items) { item in
                    HStack {
                        VStack(alignment: .leading){
                            if item.isCritical {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .symbolVariant(.fill)
                                    .foregroundColor(.red)
                                    .font(.headline)
                                    .bold()
                            }
                            
                            Text(item.title)
                                .font(.headline)
                                .bold()
                            
                            Text("\(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .shortened))")
                                .font(.callout)
                        }
                        Spacer()
                        
                        Button {
                            withAnimation {
                                item.isCompleted.toggle()
                                try? context.save()
                            }
                        } label: {
                            Image(systemName: "checkmark")
                                .symbolVariant(.circle.fill)
                                .foregroundStyle(item.isCompleted ? .green: .gray)
                                .font(.headline)
                        }
                        .buttonStyle(.plain)
                        }
                   
                    .swipeActions {
                        Button(role: .destructive) {
                            withAnimation {
                                context.delete(item)
                                try? context.save()
                            }
                            
                        } label: {
                            Label("Delete", systemImage: "trash")
                                .symbolVariant(.fill)
                        }
                        Button {
                            toDoToEdit = item
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.red)
                    }
                    
                }
                
            }
            .navigationTitle("My Task Flow")
                .toolbar {
                    ToolbarItem {
                        Button(action: {
                            showCreate.toggle()
                        }, label: {
                            Label("Add Item", systemImage: "plus")
                        })
                    }
                }
                .sheet(isPresented: $showCreate,
                       content: {
                    NavigationStack {
                        CreateTodoView()
                    }
                    .presentationDetents([.medium])
                })
                .sheet(item: $toDoToEdit) {
                    toDoToEdit = nil
                } content: { item in
                    UpdateToDoView(item: item)
                    
                }
        }
    }
    
}
#Preview {
    ContentView()
}
