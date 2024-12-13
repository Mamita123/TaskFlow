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
    
    @State private var title: String = ""
    @Query private var categories: [Category]
    
    var body: some View {
        List {
            Section(NSLocalizedString("category_title", comment: "Category title")) {
                TextField(NSLocalizedString("category_title", comment: "Enter title here"), text: $title)
                Button(NSLocalizedString("add_category_button", comment: "Add Category")) {
                    withAnimation {
                        let category = Category(title: title)
                        modelContext.insert(category)
                        category.items = []
                        title = ""
                    }
                }
                .disabled(title.isEmpty)
            }
            
            Section(NSLocalizedString("categories_section", comment: "Categories section")) {
                
                if categories.isEmpty {
                    ContentUnavailableView(NSLocalizedString("no_categories", comment: "No Categories"), systemImage: "archivebox")
                } else {
                    ForEach(categories) { category in
                        Text(category.title)
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
