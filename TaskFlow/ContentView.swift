//  ContentView.swift
//  TaskFlow
//
//  Created by Anish Pun on 28.11.2024.

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

    var localizedString: String {
        switch self {
        case .title:
            return NSLocalizedString("sort_title", comment: "Sort by title")
        case .date:
            return NSLocalizedString("sort_date", comment: "Sort by date")
        case .category:
            return NSLocalizedString("sort_category", comment: "Sort by category")
        }
    }
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [ToDoItem]

    @State private var searchQuery = ""
    @State private var showCreateCategory = false
    @State private var showCreateToDo = false
    @State private var toDoToEdit: ToDoItem?

    @State private var selectedSortOption = SortOption.allCases.first!
    @AppStorage("selectedLanguage") private var selectedLanguage = "en"  // Store language preference

    @State private var reloadView = false  // Trigger UI update when language changes

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
                                ZStack {
                                    Rectangle()
                                        .foregroundColor(.red)
                                        .frame(width: 80)
                                }
                            }

                            Text(item.title)
                                .font(.title)
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
                                .font(.headline)
                        }
                        .buttonStyle(.plain)
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            withAnimation {
                                modelContext.delete(item)
                            }
                        } label: {
                            Label(Bundle.localizedString(forKey: "delete_button"), systemImage: "trash.fill")
                        }

                        Button {
                            toDoToEdit = item
                        } label: {
                            Label(Bundle.localizedString(forKey: "edit_button"), systemImage: "pencil")
                        }
                        .tint(.orange)
                    }
                }
            }
            .navigationTitle(Bundle.localizedString(forKey: "to_do_title"))
            .animation(.easeIn, value: filteredItems)
            .searchable(text: $searchQuery, prompt: Bundle.localizedString(forKey: "search"))
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
                            ForEach(SortOption.allCases,
                                    id: \.rawValue) { option in
                                Label(option.localizedString,
                                      systemImage: option.systemImage)
                                    .tag(option)
                            }
                        }
                        .labelsHidden()
                    } label: {
                        Image(systemName: "ellipsis")
                            .symbolVariant(.circle)
                    }
                }

                ToolbarItem(placement: .primaryAction){
                    Button {
                        showCreateCategory.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }

                // Language switch button in the menu bar
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        Button(action: {
                            setLanguage(languageCode: "en")  // Switch to English
                        }) {
                            Text(NSLocalizedString("language_english", comment: "English"))
                        }
                        Button(action: {
                            setLanguage(languageCode: "fi")  // Switch to Finnish
                        }) {
                            Text(NSLocalizedString("language_finnish", comment: "Finnish"))
                        }
                    } label: {
                        Text(NSLocalizedString("language_switch", comment: "Language Switch"))
                            .bold()
                    }
                }
            }
            .safeAreaInset(edge: .bottom, alignment: .leading) {
                Button(action: {
                    showCreateToDo.toggle()
                }, label: {
                    Label(Bundle.localizedString(forKey: "create_todo"), systemImage: "plus")
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
        .onAppear {
            // Set the language when the view appears or when it changes
            setLanguage(languageCode: selectedLanguage)  // Ensure language is set initially
        }
    }

    private func setLanguage(languageCode: String) {
        // Update the language in UserDefaults
        selectedLanguage = languageCode
        UserDefaults.standard.set([languageCode], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()

        // Trigger UI update by changing the @State variable
        DispatchQueue.main.async {
            reloadView.toggle() // Force a re-render of the view
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
