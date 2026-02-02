//
//  StudyStore.swift
//  Clarity
//
//  Manages study tasks and persistence
//

import Foundation
import SwiftUI

@Observable
class StudyStore {
    var tasks: [StudyTask] = [] {
        didSet {
            saveTasks()
        }
    }
    
    private let tasksKey = "clarity.studyTasks"
    
    init() {
        loadTasks()
    }
    
    func clearAllData() {
        tasks = []
        UserDefaults.standard.removeObject(forKey: tasksKey)
    }
    
    // MARK: - Task Management
    
    func addTask(_ task: StudyTask) {
        tasks.append(task)
    }
    
    func deleteTask(_ task: StudyTask) {
        tasks.removeAll { $0.id == task.id }
    }
    
    func updateTask(_ task: StudyTask) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
        }
    }
    
    func completeStep(taskId: UUID, stepId: UUID) {
        guard let taskIndex = tasks.firstIndex(where: { $0.id == taskId }),
              let stepIndex = tasks[taskIndex].steps.firstIndex(where: { $0.id == stepId }) else {
            return
        }
        
        tasks[taskIndex].steps[stepIndex].isCompleted = true
    }
    
    func resetTask(_ task: StudyTask) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        
        var updatedTask = task
        updatedTask.steps = updatedTask.steps.map { step in
            var newStep = step
            newStep.isCompleted = false
            return newStep
        }
        
        tasks[index] = updatedTask
    }
    
    // MARK: - Persistence
    
    private func saveTasks() {
        if let encoded = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: tasksKey)
        }
    }
    
    private func loadTasks() {
        guard let data = UserDefaults.standard.data(forKey: tasksKey),
              let decoded = try? JSONDecoder().decode([StudyTask].self, from: data) else {
            return
        }
        
        tasks = decoded
    }
}
