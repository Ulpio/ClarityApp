//
//  CategoryIconView.swift
//  Clarity
//
//  Exibe ícone da categoria: emoji (Text) ou SF Symbol (Image).
//

import SwiftUI

struct CategoryIconView: View {
    let category: Category
    
    var body: some View {
        if category.isEmojiIcon {
            Text(category.icon)
                .font(.title2)
        } else {
            Image(systemName: category.icon)
                .font(.body)
                .symbolRenderingMode(.hierarchical)
        }
    }
}
