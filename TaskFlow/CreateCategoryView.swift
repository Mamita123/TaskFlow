//
//  CreateCategoryView.swift
//  TaskFlow
//
//  Created by Anish Pun on 9.12.2024.
//
import SwiftUI
import SwiftData

struct CreateCategoryView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var languageManager: LanguageManager

    @State private var title: String = ""
    @State private var needsRefresh: Bool = false
    @Query private var categories: [Category]

    var body: some View {
        List {
            Section(NSLocalizedString("category_title", comment: "Category title section")) {
                TextField(NSLocalizedString("enter_title_here", comment: "Placeholder for title field"),
                          text: $title)
                Button(NSLocalizedString("add_category", comment: "Button to add a category")) {
                    withAnimation {
                        let category = Category(title: title.lowercased())
                        modelContext.insert(category)
                        category.items = []
                        title = ""
                    }
                }
                .disabled(title.isEmpty)
            }

            Section(NSLocalizedString("categories", comment: "Categories section")) {
                if categories.isEmpty {
                    ContentUnavailableView(NSLocalizedString("no_categories", comment: "Message when no categories exist"),
                                           systemImage: "archivebox")
                } else {
                    ForEach(categories) { category in
                        Text(category.title) // Display the localized title from `title`
                            .swipeActions {
                                Button(role: .destructive) {
                                    withAnimation {
                                        modelContext.delete(category)
                                    }
                                } label: {
                                    Label(NSLocalizedString("delete", comment: "Delete button"), systemImage: "trash.fill")
                                }
                            }
                    }
                }
            }
        }
        .navigationTitle(NSLocalizedString("add_category", comment: "Navigation title for the add category screen"))
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(NSLocalizedString("dismiss", comment: "Dismiss button")) {
                    dismiss()
                }
            }
        }
        .onAppear {
            // Initialize default categories if the list is empty
            if categories.isEmpty {
                for defaultCategory in Category.defaults {
                    modelContext.insert(defaultCategory)
                }
            }
        }
        .onChange(of: languageManager.currentLanguage) { _ in
            needsRefresh.toggle() // Toggle to force UI refresh
        }
        .onChange(of: needsRefresh) { _ in
            refreshCategories()
        }
    }

    private func refreshCategories() {
        // Clear existing categories
        for category in categories {
            modelContext.delete(category)
        }
        // Save the context to reflect deletion
        try? modelContext.save()

        // Insert new categories based on the current language
        for defaultCategory in Category.defaults {
            modelContext.insert(defaultCategory)
        }
        // Save the context to reflect changes
        try? modelContext.save()
    }
}
