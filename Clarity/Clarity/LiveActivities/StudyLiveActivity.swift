//
//  StudyLiveActivity.swift
//  Clarity
//
//  Live Activity widget for Dynamic Island
//

import ActivityKit
import WidgetKit
import SwiftUI

@available(iOS 16.2, *)
struct StudyLiveActivity: Widget {
    var body: some WidgetConfiguration {
        let config = ActivityConfiguration(for: StudyActivityAttributes.self) { context in
            StudyLiveActivityLockScreenView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded view (when tapped)
                DynamicIslandExpandedRegion(.leading) {
                    HStack(spacing: 8) {
                        Image(systemName: "book.fill")
                            .font(.title3)
                            .foregroundStyle(.blue)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(context.state.taskTitle)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .lineLimit(1)
                            
                            Text("Passo \(context.state.progressText)")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    VStack(alignment: .trailing, spacing: 4) {
                        if context.state.estimatedSeconds > 0 {
                            HStack(spacing: 4) {
                                Image(systemName: "clock.fill")
                                    .font(.caption2)
                                Text(context.state.timeRemainingText)
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .monospacedDigit()
                            }
                            .foregroundStyle(context.state.canComplete ? .green : .orange)
                        }
                        
                        Text(context.state.currentStepDescription)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                DynamicIslandExpandedRegion(.bottom) {
                    VStack(alignment: .leading, spacing: 2) {
                        HStack {
                            Text("Progresso")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text("\(Int(context.state.progress * 100))%")
                                .font(.caption2)
                                .fontWeight(.semibold)
                                .monospacedDigit()
                        }
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .fill(Color.secondary.opacity(0.2))
                                    .frame(height: 4)
                                Rectangle()
                                    .fill(Color.blue)
                                    .frame(
                                        width: max(0, geometry.size.width * context.state.progress),
                                        height: 4
                                    )
                            }
                        }
                        .frame(height: 4)
                    }
                    .padding(.horizontal, 0)
                    .padding(.top, 2)
                    .padding(.bottom, 0)
                }
                
                DynamicIslandExpandedRegion(.center) {
                    // Reserved for future use
                }
            } compactLeading: {
                // Leading compact view (progresso de passos)
                HStack(spacing: 4) {
                    Image(systemName: "checklist")
                        .font(.caption2)
                    Text(context.state.progressText)
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .monospacedDigit()
                }
                .foregroundStyle(.blue)
            } compactTrailing: {
                // Trailing compact view (timer)
                if context.state.estimatedSeconds > 0 {
                    HStack(spacing: 4) {
                        Image(systemName: "clock.fill")
                            .font(.caption2)
                        Text(context.state.timeRemainingText)
                            .font(.caption2)
                            .fontWeight(.medium)
                            .monospacedDigit()
                    }
                    .foregroundStyle(context.state.canComplete ? .green : .orange)
                } else {
                    Image(systemName: "clock")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            } minimal: {
                Image(systemName: "book.fill")
                    .font(.caption2)
                    .foregroundStyle(.blue)
            }
        }
        if #available(iOS 17.0, *) {
            return config.contentMarginsDisabled()
        }
        return config
    }
}

@available(iOS 16.2, *)
struct StudyLiveActivityLockScreenView: View {
    let context: ActivityViewContext<StudyActivityAttributes>
    
    var body: some View {
        VStack(spacing: 12) {
            // Header
            HStack {
                Image(systemName: "book.fill")
                    .foregroundStyle(.blue)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(context.state.taskTitle)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    Text("Passo \(context.state.progressText)")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                if context.state.estimatedSeconds > 0 {
                    VStack(alignment: .trailing, spacing: 2) {
                        HStack(spacing: 4) {
                            Image(systemName: "clock.fill")
                                .font(.caption2)
                            Text(context.state.timeRemainingText)
                                .font(.caption)
                                .fontWeight(.medium)
                                .monospacedDigit()
                        }
                        .foregroundStyle(context.state.canComplete ? .green : .orange)
                        
                        if context.state.canComplete {
                            Text("Pronto!")
                                .font(.caption2)
                                .foregroundStyle(.green)
                        }
                    }
                }
            }
            
            // Current step
            HStack {
                Text(context.state.currentStepDescription)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                Spacer()
            }
            
            // Progress bar
            HStack(spacing: 6) {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.secondary.opacity(0.2))
                            .frame(height: 4)
                        Rectangle()
                            .fill(Color.blue)
                            .frame(
                                width: max(0, geometry.size.width * context.state.progress),
                                height: 4
                            )
                    }
                }
                .frame(height: 4)
                Text("\(Int(context.state.progress * 100))%")
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .monospacedDigit()
                    .frame(width: 36, alignment: .trailing)
            }
        }
        .padding(10)
        .activityBackgroundTint(Color.black.opacity(0.3))
        .activitySystemActionForegroundColor(.white)
    }
}

@available(iOS 16.2, *)
#Preview("Dynamic Island Compact", as: .dynamicIsland(.compact), using: StudyActivityAttributes(categoryColorHex: nil, taskId: UUID())) {
    StudyLiveActivity()
} contentStates: {
    StudyActivityAttributes.ContentState(
        currentStepIndex: 2,
        totalSteps: 5,
        currentStepDescription: "Fazer exercícios de matemática",
        elapsedSeconds: 120,
        estimatedSeconds: 300,
        taskTitle: "Matemática",
        canComplete: false,
        lastUpdateTime: Date()
    )
}

@available(iOS 16.2, *)
#Preview("Dynamic Island Expanded", as: .dynamicIsland(.expanded), using: StudyActivityAttributes(categoryColorHex: nil, taskId: UUID())) {
    StudyLiveActivity()
} contentStates: {
    StudyActivityAttributes.ContentState(
        currentStepIndex: 2,
        totalSteps: 5,
        currentStepDescription: "Fazer exercícios de matemática",
        elapsedSeconds: 180,
        estimatedSeconds: 300,
        taskTitle: "Matemática",
        canComplete: true,
        lastUpdateTime: Date()
    )
}
