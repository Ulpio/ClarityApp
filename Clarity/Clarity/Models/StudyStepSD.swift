//
//  StudyStepSD.swift
//  Clarity
//
//  SwiftData version of StudyStep
//

import Foundation
import SwiftData

@Model
final class StudyStepSD {
    var id: UUID
    var stepDescription: String
    var isCompleted: Bool
    var completedAt: Date?
    var order: Int
    var estimatedMinutes: Int // Tempo estimado em minutos
    var wasSkipped: Bool // Se foi pulado ao invés de completado
    var skippedAt: Date? // Quando foi pulado
    
    init(id: UUID = UUID(), description: String, isCompleted: Bool = false, order: Int = 0, estimatedMinutes: Int = 0) {
        self.id = id
        self.stepDescription = description
        self.isCompleted = isCompleted
        self.completedAt = nil
        self.order = order
        self.estimatedMinutes = estimatedMinutes
        self.wasSkipped = false
        self.skippedAt = nil
    }
    
    /// Retorna o tempo mínimo necessário (60% do estimado) em segundos
    var minimumRequiredSeconds: Int {
        guard estimatedMinutes > 0 else { return 15 } // Fallback para 15s
        return Int(Double(estimatedMinutes * 60) * 0.6)
    }
    
    /// Retorna o tempo total estimado em segundos
    var totalEstimatedSeconds: Int {
        estimatedMinutes * 60
    }
    
    /// Formata o tempo estimado para exibição
    var estimatedTimeText: String {
        guard estimatedMinutes > 0 else { return "Tempo livre" }
        if estimatedMinutes < 60 {
            return "\(estimatedMinutes) min"
        } else {
            let hours = estimatedMinutes / 60
            let mins = estimatedMinutes % 60
            if mins == 0 {
                return "\(hours)h"
            }
            return "\(hours)h \(mins)min"
        }
    }
    
    /// Marca o passo como completado
    func complete() {
        isCompleted = true
        completedAt = Date()
        wasSkipped = false
    }
    
    /// Marca o passo como pulado (skip)
    func skip() {
        isCompleted = true
        completedAt = Date()
        wasSkipped = true
        skippedAt = Date()
    }
    
    /// Reseta o passo
    func reset() {
        isCompleted = false
        completedAt = nil
        wasSkipped = false
        skippedAt = nil
    }
}
