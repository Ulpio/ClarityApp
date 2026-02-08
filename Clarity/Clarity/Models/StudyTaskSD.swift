//
//  StudyTaskSD.swift
//  Clarity
//
//  SwiftData version of StudyTask
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class StudyTaskSD {
    var id: UUID
    var title: String
    var createdAt: Date
    var completedAt: Date?
    var breatheSkipped: Bool // marca se o exercício de respiração foi pulado
    var breatheSkippedAt: Date? // quando foi pulado
    
    @Relationship(deleteRule: .cascade)
    var steps: [StudyStepSD]
    
    @Relationship(deleteRule: .nullify)
    var category: Category?
    
    init(id: UUID = UUID(), title: String, steps: [StudyStepSD] = [], category: Category? = nil, createdAt: Date = Date()) {
        self.id = id
        self.title = title
        self.steps = steps
        self.category = category
        self.createdAt = createdAt
        self.completedAt = nil
        self.breatheSkipped = false
        self.breatheSkippedAt = nil
    }
    
    /// Retorna o índice do primeiro passo não completado
    var currentStepIndex: Int? {
        steps.firstIndex { !$0.isCompleted }
    }
    
    /// Verifica se todos os passos foram completados
    var isCompleted: Bool {
        !steps.isEmpty && steps.allSatisfy { $0.isCompleted }
    }
    
    /// Retorna o progresso como uma fração (0.0 a 1.0)
    var progress: Double {
        guard !steps.isEmpty else { return 0 }
        let completedCount = steps.filter { $0.isCompleted }.count
        return Double(completedCount) / Double(steps.count)
    }
    
    /// Número de passos completados
    var completedStepsCount: Int {
        steps.filter { $0.isCompleted }.count
    }
    
    /// Reseta todos os passos
    func reset() {
        steps.forEach { $0.isCompleted = false }
        completedAt = nil
    }
    
    /// Marca como completada
    func markAsCompleted() {
        completedAt = Date()
    }
}

extension StudyTaskSD: Identifiable { }
