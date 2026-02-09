//
//  Category.swift
//  Clarity
//
//  Task categories with colors and icons
//

import Foundation
import SwiftUI
import SwiftData

@Model
final class Category {
    var id: UUID
    var name: String
    var icon: String
    var colorHex: String
    var order: Int
    var isSystemCategory: Bool
    
    @Relationship(deleteRule: .nullify, inverse: \StudyTaskSD.category)
    var tasks: [StudyTaskSD]?
    
    init(id: UUID = UUID(), name: String, icon: String, colorHex: String, order: Int = 0, isSystemCategory: Bool = false) {
        self.id = id
        self.name = name
        self.icon = icon
        self.colorHex = colorHex
        self.order = order
        self.isSystemCategory = isSystemCategory
    }
    
    var color: Color {
        Color(hex: colorHex) ?? .blue
    }
    
    /// True se o ícone for emoji (exibido como texto); caso contrário é nome de SF Symbol.
    var isEmojiIcon: Bool {
        !icon.isEmpty && icon.count <= 4 && icon.allSatisfy { $0.cl_isEmoji }
    }
    
    // Categorias padrão (não podem ser excluídas)
    static let defaultCategories: [Category] = [
        Category(name: "Estudos", icon: "book.fill", colorHex: "5B9FED", order: 0, isSystemCategory: true),
        Category(name: "Trabalho", icon: "briefcase.fill", colorHex: "F59E0B", order: 1, isSystemCategory: true),
        Category(name: "Saúde", icon: "heart.fill", colorHex: "10B981", order: 2, isSystemCategory: true),
        Category(name: "Pessoal", icon: "person.fill", colorHex: "A78BFA", order: 3, isSystemCategory: true),
        Category(name: "Casa", icon: "house.fill", colorHex: "EC4899", order: 4, isSystemCategory: true),
        Category(name: "Criativo", icon: "paintbrush.fill", colorHex: "8B5CF6", order: 5, isSystemCategory: true)
    ]
    
    /// Cores disponíveis para categorias personalizadas (nome único para uso como id em ForEach)
    static let presetColors: [(name: String, hex: String)] = [
        ("Azul", "5B9FED"),
        ("Laranja", "F59E0B"),
        ("Verde", "10B981"),
        ("Roxo", "A78BFA"),
        ("Rosa", "EC4899"),
        ("Índigo", "8B5CF6"),
        ("Vermelho", "EF4444"),
        ("Teal", "14B8A6"),
        ("Ciano", "06B6D4")
    ]
    
    /// Nomes das categorias padrão (para migração e detecção)
    static let defaultCategoryNames: Set<String> = ["Estudos", "Trabalho", "Saúde", "Pessoal", "Casa", "Criativo"]
    
    /// Símbolos SF comuns para escolha rápida
    static let presetSymbols: [String] = [
        "book.fill", "briefcase.fill", "heart.fill", "person.fill", "house.fill",
        "paintbrush.fill", "star.fill", "flag.fill", "leaf.fill", "flame.fill",
        "drop.fill", "bolt.fill", "graduationcap.fill", "dumbbell.fill", "cart.fill"
    ]
}

// MARK: - Emoji detection
private extension Character {
    // Heuristic to detect if a Character is an emoji.
    // Checks if any unicode scalar has the Emoji property and accounts for keycaps/variation selectors.
    var cl_isEmoji: Bool {
        // If the character is a single scalar and that scalar is an emoji, it's emoji.
        if let first = unicodeScalars.first, unicodeScalars.count == 1 {
            // Many emoji scalars are marked as `properties.isEmoji`
            if first.properties.isEmoji { return true }
        }
        // For composed sequences (e.g., flags, skin tones, family), if any scalar is emoji and
        // the character renders as a single extended grapheme cluster with presentation width > 1,
        // consider it an emoji. The width check isn't accessible here, so rely on scalar properties.
        // Common scalars involved in emoji sequences include zero-width joiner, variation selectors, and regional indicators.
        let hasEmojiScalar = unicodeScalars.contains { $0.properties.isEmoji }
        if hasEmojiScalar { return true }
        
        // Keycap sequences like 1️⃣ are formed with base [0-9#*] + variation selector + keycap combining mark
        // Those bases aren't emoji by themselves; detect the keycap combining scalar.
        let keycapScalar: UnicodeScalar = "\u{20E3}"
        if unicodeScalars.contains(keycapScalar) { return true }
        
        return false
    }
}

// Extension para converter hex em Color
extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            return nil
        }
        
        let length = hexSanitized.count
        let r, g, b: Double
        
        if length == 6 {
            r = Double((rgb & 0xFF0000) >> 16) / 255.0
            g = Double((rgb & 0x00FF00) >> 8) / 255.0
            b = Double(rgb & 0x0000FF) / 255.0
        } else {
            return nil
        }
        
        self.init(red: r, green: g, blue: b)
    }
    
    func hexString() -> String? {
        // Obtain CGColor components safely, handling grayscale and RGB color spaces
        // Avoid using UIColor(Color) initializer which is unavailable; try to access cgColor directly
        // Fallback to creating a UIColor via dynamic provider if cgColor isn't available
        var cgColor: CGColor?
        if #available(iOS 17.0, *) {
            cgColor = self.cgColor
        }

        if cgColor == nil {
            // Resolve the SwiftUI Color to concrete RGBA components and build a UIColor
            let resolved = self.resolve(in: .init())
            let uiColor = UIColor(red: CGFloat(resolved.red),
                                  green: CGFloat(resolved.green),
                                  blue: CGFloat(resolved.blue),
                                  alpha: CGFloat(resolved.opacity))
            cgColor = uiColor.cgColor
        }

        guard let finalCGColor = cgColor,
              let converted = finalCGColor.converted(to: CGColorSpaceCreateDeviceRGB(), intent: .defaultIntent, options: nil),
              let components = converted.components else {
            return nil
        }

        // Components are expected as [r, g, b, a] after conversion
        let r = components.count > 0 ? Float(components[0]) : 0
        let g = components.count > 1 ? Float(components[1]) : r
        let b = components.count > 2 ? Float(components[2]) : r

        return String(format: "%02lX%02lX%02lX",
                       lroundf(r * 255),
                       lroundf(g * 255),
                       lroundf(b * 255))
    }
}

