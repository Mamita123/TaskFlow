//
//  ContentView.swift
//  TaskFlow
//
//  Created by Anish Pun on 28.11.2024.
//

import SwiftUI
import SwiftData

enum SortOption: String, CaseIterable {
    case title
    case date
    case category
}

extension SortOption {
    
    var systemImage: String {
        switch self {
        case .title:
            return "textformat.size.larger"
        case .date:
            return "calendar"
        case .category:
            return "folder"
        }
    }
    
    var localizedDescription: String {
        switch self {
        case .title:
            return NSLocalizedString("Title", comment: "Sort option for title")
        case .date:
            return NSLocalizedString("Date", comment: "Sort option for date")
        case .category:
            return NSLocalizedString("Category", comment: "Sort option for category")
        }
    }
}

struct ContentView: View {
    
    @StateObject private var languageManager = LanguageManager()
   

    @Environment(\.modelContext) private var modelContext
    @Query private var items: [ToDoItem]
    
    @State private var searchQuery = ""
    @State private var showCreateCategory = false
    @State private var showCreateToDo = false
    @State private var toDoToEdit: ToDoItem?
    
    @State private var selectedSortOption = SortOption.allCases.first!
    
    var filteredItems: [ToDoItem] {
        
        if searchQuery.isEmpty {
            return items.sort(on: selectedSortOption)
        }
        
        let filteredItems = items.compactMap { item in
            
            let titleContainsQuery = item.title.range(of: searchQuery,
                                                       options: .caseInsensitive) != nil
            
            let categoryTitleContainsQuery = item.category?.title.range(of: searchQuery,
                                                                        options: .caseInsensitive) != nil
            
            return (titleContainsQuery || categoryTitleContainsQuery) ? item : nil
        }
        
        return filteredItems.sort(on: selectedSortOption)
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredItems) { item in
                    
                    HStack {
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
                            
                            Text("\(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .shortened))")
                                .font(.callout)
                            
                            if let category = item.category {
                                Text(category.title)
                                     .foregroundStyle(Color.blue)
                                     .bold()
                                     .padding(.horizontal)
                                     .padding(.vertical, 8)
                                     .background(Color.blue.opacity(0.1),
                                                 in: RoundedRectangle(cornerRadius: 8,
                                                                      style: .continuous))
                            }
                            
                        }
                        
                        Spacer()
                        
                        Button {
                            withAnimation {
                                item.isCompleted.toggle()
                            }
                        } label: {
                            Image(systemName: "checkmark")
                                .symbolVariant(.circle.fill)
                                .foregroundStyle(item.isCompleted ? .green : .gray)
                                .font(.largeTitle)
                        }
                        .buttonStyle(.plain)
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            withAnimation {
                                modelContext.delete(item)
                            }
                        } label: {
                            Label(NSLocalizedString("Delete", comment: "Delete action"), systemImage: "trash.fill")
                        }
                        
                        Button {
                            toDoToEdit = item
                        } label: {
                            Label(NSLocalizedString("Edit", comment: "Edit action"), systemImage: "pencil")
                        }
                        .tint(.orange)
                    }
                }
            }
            .navigationTitle(NSLocalizedString("My To Do List", comment: "Title for to-do list view"))
            .animation(.easeIn, value: filteredItems)
            .searchable(text: $searchQuery,
                        prompt: NSLocalizedString("Search for a to do or a category", comment: "Search placeholder"))
            .overlay {
                if filteredItems.isEmpty {
                    ContentUnavailableView.search
                }
            }
            .sheet(item: $toDoToEdit,
                   onDismiss: {
                toDoToEdit = nil
            },
                   content: { editItem in
                NavigationStack {
                    UpdateToDoView(item: editItem)
                        .interactiveDismissDisabled()
                }
            })
            .sheet(isPresented: $showCreateCategory,
                   content: {
                NavigationStack {
                    CreateCategoryView()
                }
            })
            .sheet(isPresented: $showCreateToDo,
                   content: {
                NavigationStack {
                    CreateTodoView()
                }
            })
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Picker("", selection: $selectedSortOption) {
                            ForEach(SortOption.allCases, id: \.rawValue) { option in
                                Label(option.localizedDescription, systemImage: option.systemImage)
                                    .tag(option)
                            }
                        }
                        .labelsHidden()
                    } label: {
                        Image(systemName: "ellipsis")
                            .symbolVariant(.circle)
                    }
                }
                
                // Language switcher menu
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu {
                            Button("English") {
                                languageManager.switchLanguage(to: "en")
                            }
                            Button("Finnish") {
                                languageManager.switchLanguage(to: "fi")
                            }
                        } label: {
                            Text(NSLocalizedString("Language", comment: "Button label to change language"))
                        }
                    }
                
                ToolbarItem(placement: .primaryAction){
                    Button {
                        showCreateCategory.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                
            }
            .safeAreaInset(edge: .bottom, alignment: .leading) {
                Button(action: {
                    showCreateToDo.toggle()
                }, label: {
                    Label(NSLocalizedString("New ToDo", comment: "Button title to create a new to do"), systemImage: "plus")
                        .bold()
                        .font(.title2)
                        .padding(8)
                        .background(.gray.opacity(0.1),
                                    in: Capsule())
                        .padding(.leading)
                        .symbolVariant(.circle.fill)
                })
            }
        }
    }
   
    
    private func delete(item: ToDoItem) {
        withAnimation {
            modelContext.delete(item)
        }
    }
}

private extension [ToDoItem] {
    
    func sort(on option: SortOption) -> [ToDoItem] {
        switch option {
        case .title:
            return self.sorted(by: { $0.title < $1.title })
        case .date:
            return self.sorted(by: { $0.timestamp < $1.timestamp })
        case .category:
            return self.sorted(by: {
                guard let firstItemTitle = $0.category?.title,
                      let secondItemTitle = $1.category?.title else { return false }
                return firstItemTitle < secondItemTitle
            })
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: ToDoItem.self, inMemory: true)
}
