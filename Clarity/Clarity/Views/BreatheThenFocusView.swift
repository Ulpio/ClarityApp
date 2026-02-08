//
//  BreatheThenFocusView.swift
//  Clarity
//
//  Mostra BreatheView e em seguida FocusViewEnhanced (fluxo completo da sessão).
//

import SwiftUI
import SwiftData

struct BreatheThenFocusView: View {
    @Environment(\.modelContext) private var modelContext
    let task: StudyTaskSD
    var onDismiss: () -> Void
    
    @State private var showFocus = false
    
    var body: some View {
        Group {
            if showFocus {
                NavigationStack {
                    FocusViewEnhanced(task: task, onSessionEnd: onDismiss)
                }
            } else {
                BreatheView(
                    onComplete: { showFocus = true },
                    onSkip: { showFocus = true }
                )
                .environment(\.modelContext, modelContext)
            }
        }
    }
}
