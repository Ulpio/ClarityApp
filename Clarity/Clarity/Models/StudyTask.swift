//
//  StudyTask.swift
//  Clarity
//
//  Represents a study activity with sequential steps
//

import Foundation

struct StudyTask: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var steps: [StudyStep]
    let createdAt: Date
    
    init(id: UUID = UUID(), title: String, steps: [StudyStep] = [], createdAt: Date = Date()) {
        self.id = id
        self.title = title
        self.steps = steps
        self.createdAt = createdAt
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
}
