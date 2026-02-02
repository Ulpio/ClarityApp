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
    
    @Relationship(deleteRule: .nullify, inverse: \StudyTaskSD.category)
    var tasks: [StudyTaskSD]?
    
    init(id: UUID = UUID(), name: String, icon: String, colorHex: String, order: Int = 0) {
        self.id = id
        self.name = name
        self.icon = icon
        self.colorHex = colorHex
        self.order = order
    }
    
    var color: Color {
        Color(hex: colorHex) ?? .blue
    }
    
    // Categorias padrão
    static let defaultCategories: [Category] = [
        Category(name: "Estudos", icon: "book.fill", colorHex: "5B9FED", order: 0),
        Category(name: "Trabalho", icon: "briefcase.fill", colorHex: "F59E0B", order: 1),
        Category(name: "Saúde", icon: "heart.fill", colorHex: "10B981", order: 2),
        Category(name: "Pessoal", icon: "person.fill", colorHex: "A78BFA", order: 3),
        Category(name: "Casa", icon: "house.fill", colorHex: "EC4899", order: 4),
        Category(name: "Criativo", icon: "paintbrush.fill", colorHex: "8B5CF6", order: 5)
    ]
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
            let resolved: Color.Resolved
            if #available(iOS 17.0, *) {
                resolved = self.resolve(in: .init())
            } else {
                // For older OS versions, attempt to use a neutral environment
                resolved = self.resolve(in: .init())
            }
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

