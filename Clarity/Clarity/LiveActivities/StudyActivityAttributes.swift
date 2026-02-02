//
//  StudyActivityAttributes.swift
//  Clarity
//
//  Live Activity attributes for Dynamic Island
//

import ActivityKit
import Foundation

/// Attributes for the study session Live Activity
struct StudyActivityAttributes: ActivityAttributes {
    /// Static properties that don't change during the activity
    public struct ContentState: Codable, Hashable {
        /// Current step index (0-based)
        var currentStepIndex: Int
        
        /// Total number of steps
        var totalSteps: Int
        
        /// Current step description
        var currentStepDescription: String
        
        /// Elapsed seconds for current step
        var elapsedSeconds: Int
        
        /// Total estimated seconds for current step (0 if no estimate)
        var estimatedSeconds: Int
        
        /// Task title
        var taskTitle: String
        
        /// Is the step completable (60% rule met)
        var canComplete: Bool
        
        /// Timestamp of last update (for staleness detection)
        var lastUpdateTime: Date
        
        /// Progress percentage (0.0 to 1.0)
        var progress: Double {
            guard totalSteps > 0 else { return 0 }
            return Double(currentStepIndex) / Double(totalSteps)
        }
        
        /// Formatted time remaining
        var timeRemainingText: String {
            guard estimatedSeconds > 0 else { return "" }
            let remaining = max(0, estimatedSeconds - elapsedSeconds)
            let minutes = remaining / 60
            let seconds = remaining % 60
            if minutes > 0 {
                return "\(minutes):\(String(format: "%02d", seconds))"
            } else {
                return "\(seconds)s"
            }
        }
        
        /// Formatted progress text
        var progressText: String {
            "\(currentStepIndex + 1)/\(totalSteps)"
        }
    }
    
    /// Category color (hex string)
    var categoryColorHex: String?
    
    /// Task ID for deep linking
    var taskId: UUID
}
