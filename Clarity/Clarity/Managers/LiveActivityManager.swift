//
//  LiveActivityManager.swift
//  Clarity
//
//  Manager for Live Activities (Dynamic Island)
//

import ActivityKit
import Foundation
import SwiftUI

/// Manager responsible for creating, updating, and ending Live Activities
@available(iOS 16.2, *)
@Observable
class LiveActivityManager {
    /// Current active activity
    private(set) var currentActivity: Activity<StudyActivityAttributes>?
    
    /// Singleton instance
    static let shared = LiveActivityManager()
    
    private init() {}
    
    /// Start a Live Activity for a study session
    /// - Parameters:
    ///   - task: The study task
    ///   - currentStepIndex: Current step index
    ///   - elapsedSeconds: Elapsed time for current step
    /// - Returns: True if started successfully
    /// - Note: No-op no Simulador para evitar erro "Failed to show Widget" (Live Activities não são suportadas corretamente no Simulador).
    @discardableResult
    func startActivity(
        for task: StudyTaskSD,
        currentStepIndex: Int,
        elapsedSeconds: Int = 0
    ) -> Bool {
        #if targetEnvironment(simulator)
        return false
        #endif
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return false }
        if currentActivity != nil { endActivity() }
        
        guard let currentStep = task.steps[safe: currentStepIndex] else { return false }
        
        let attributes = StudyActivityAttributes(
            categoryColorHex: task.category?.color.hexString(),
            taskId: task.id
        )
        
        let contentState = StudyActivityAttributes.ContentState(
            currentStepIndex: currentStepIndex,
            totalSteps: task.steps.count,
            currentStepDescription: currentStep.stepDescription,
            elapsedSeconds: elapsedSeconds,
            estimatedSeconds: currentStep.estimatedMinutes > 0 ? currentStep.totalEstimatedSeconds : 0,
            taskTitle: task.title,
            canComplete: false,
            lastUpdateTime: Date()
        )
        
        do {
            let activity = try Activity<StudyActivityAttributes>.request(
                attributes: attributes,
                content: .init(state: contentState, staleDate: nil),
                pushType: nil
            )
            
            currentActivity = activity
            return true
        } catch {
            return false
        }
    }
    
    /// Update the current Live Activity
    /// - Parameters:
    ///   - task: The study task
    ///   - currentStepIndex: Current step index
    ///   - elapsedSeconds: Elapsed time for current step
    ///   - canComplete: Whether the step can be completed (60% rule)
    func updateActivity(
        for task: StudyTaskSD,
        currentStepIndex: Int,
        elapsedSeconds: Int,
        canComplete: Bool
    ) {
        guard let activity = currentActivity else { return }
        guard let currentStep = task.steps[safe: currentStepIndex] else { return }
        
        let contentState = StudyActivityAttributes.ContentState(
            currentStepIndex: currentStepIndex,
            totalSteps: task.steps.count,
            currentStepDescription: currentStep.stepDescription,
            elapsedSeconds: elapsedSeconds,
            estimatedSeconds: currentStep.estimatedMinutes > 0 ? currentStep.totalEstimatedSeconds : 0,
            taskTitle: task.title,
            canComplete: canComplete,
            lastUpdateTime: Date()
        )
        
        Task {
            await activity.update(
                ActivityContent(
                    state: contentState,
                    staleDate: Date().addingTimeInterval(60)
                )
            )
        }
    }
    
    /// End the current Live Activity
    /// - Parameter dismissalPolicy: When to dismiss (default: immediate)
    func endActivity(dismissalPolicy: ActivityUIDismissalPolicy = .immediate) {
        guard let activity = currentActivity else { return }
        Task {
            await activity.end(
                ActivityContent(state: activity.content.state, staleDate: Date()),
                dismissalPolicy: dismissalPolicy
            )
            currentActivity = nil
        }
    }
    
    /// End activity with completion state
    /// - Parameter task: The completed task
    func endActivityWithCompletion(for task: StudyTaskSD) {
        guard let activity = currentActivity else { return }
        let contentState = StudyActivityAttributes.ContentState(
            currentStepIndex: task.steps.count - 1,
            totalSteps: task.steps.count,
            currentStepDescription: "Tarefa completa! 🎉",
            elapsedSeconds: 0,
            estimatedSeconds: 0,
            taskTitle: task.title,
            canComplete: true,
            lastUpdateTime: Date()
        )
        
        Task {
            await activity.end(
                ActivityContent(state: contentState, staleDate: Date()),
                dismissalPolicy: .default
            )
            currentActivity = nil
        }
    }
}

// MARK: - Helpers
// Note: Color.hexString() extension is defined in Category.swift

extension Array {
    /// Safe subscript
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
