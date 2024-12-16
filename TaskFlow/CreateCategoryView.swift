//
//  CreateCategoryView.swift
//  TaskFlow
//
//  Created by Anish Pun on 9.12.2024.
//

// CreateCategoryView.swift

import SwiftUI
import SwiftData

struct CreateCategoryView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var modelContext
    
    @State private var title: String = ""
    @Query private var categories: [Category]  // Only fetch user-added categories
    
    var body: some View {
        List {
            Section(NSLocalizedString("category_title", comment: "Category title")) {
                TextField(NSLocalizedString("category_name_placeholder", comment: "Enter title here"), text: $title)
                    .padding()
                
                Button(NSLocalizedString("add_category_button", comment: "Add Category")) {
                    withAnimation {
                        // Save the title exactly as entered by the user without localization
                        let category = Category(title: title)  // Use the title as entered by the user
                        modelContext.insert(category)
                        category.items = []  // Initialize the items for the new category
                        title = ""  // Reset the input field after adding the category
                    }
                }
                .disabled(title.isEmpty)  // Disable the button if the title is empty
            }
            
            Section(NSLocalizedString("categories_section", comment: "Categories section")) {
                
                if categories.isEmpty {
                    ContentUnavailableView(NSLocalizedString("no_categories", comment: "No Categories"), systemImage: "archivebox")
                } else {
                    ForEach(categories, id: \.self) { category in
                        Text(category.title)  // Directly display the category title
                            .swipeActions {
                                Button(role: .destructive) {
                                    withAnimation {
                                        modelContext.delete(category)
                                    }
                                } label: {
                                    Label(NSLocalizedString("delete_button", comment: "Delete button label"), systemImage: "trash.fill")
                                }
                            }
                    }
                }
            }
        }
        .navigationTitle(NSLocalizedString("add_category_button", comment: "Add Category"))
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(NSLocalizedString("dismiss_button", comment: "Dismiss button")) {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        CreateCategoryView()
    }
}
