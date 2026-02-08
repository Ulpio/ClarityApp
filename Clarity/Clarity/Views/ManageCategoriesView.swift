//
//  ManageCategoriesView.swift
//  Clarity
//
//  Listar, adicionar e remover categorias personalizadas.
//

import SwiftUI
import SwiftData

struct ManageCategoriesView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Category.order) private var categories: [Category]
    
    @State private var showAddCategory = false
    
    private var systemCategories: [Category] {
        categories.filter { Category.defaultCategoryNames.contains($0.name) || $0.isSystemCategory }
    }
    
    private var customCategories: [Category] {
        categories.filter { !Category.defaultCategoryNames.contains($0.name) && !$0.isSystemCategory }
    }
    
    var body: some View {
        List {
            Section {
                ForEach(systemCategories) { category in
                    CategoryRowView(category: category)
                }
            } header: {
                Text("Padrão")
            } footer: {
                Text("Estas categorias não podem ser editadas nem excluídas.")
            }
            
            Section {
                ForEach(customCategories) { category in
                    CategoryRowView(category: category)
                }
                .onDelete(perform: deleteCustomCategories)
                
                Button {
                    showAddCategory = true
                } label: {
                    Label("Nova categoria", systemImage: "plus.circle.fill")
                        .foregroundStyle(.tint)
                }
            } header: {
                Text("Suas categorias")
            } footer: {
                Text("Toque em + para criar uma categoria. Use emojis ou símbolos no nome e no ícone.")
            }
        }
        .navigationTitle("Categorias")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showAddCategory) {
            AddCategoryView()
                .environment(\.modelContext, modelContext)
        }
    }
    
    private func deleteCustomCategories(at offsets: IndexSet) {
        for index in offsets {
            let category = customCategories[index]
            modelContext.delete(category)
        }
        try? modelContext.save()
    }
}

struct CategoryRowView: View {
    let category: Category
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(category.color.opacity(0.2))
                    .frame(width: 36, height: 36)
                CategoryIconView(category: category)
                    .foregroundStyle(category.color)
            }
            Text(category.name)
                .font(.body)
        }
    }
}
