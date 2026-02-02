//
//  StudyStep.swift
//  Clarity
//
//  Represents a single actionable step within a study task
//

import Foundation

struct StudyStep: Identifiable, Codable, Equatable {
    let id: UUID
    var description: String
    var isCompleted: Bool
    
    init(id: UUID = UUID(), description: String, isCompleted: Bool = false) {
        self.id = id
        self.description = description
        self.isCompleted = isCompleted
    }
}
