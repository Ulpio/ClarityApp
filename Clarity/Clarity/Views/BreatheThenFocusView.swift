//
//  BreatheThenFocusView.swift
//  Clarity
//
//  Mostra BreatheView e em seguida FocusViewEnhanced (fluxo completo da sessão).
//

import SwiftUI
import SwiftData
import Combine

/// Estado da sessão no cover (objeto para sobreviver a re-renders e não reapresentar a respiração).
final class CoverSessionState: ObservableObject {
    @Published var showFocus: Bool = false
}

struct BreatheThenFocusView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var coverState: CoverSessionState
    let task: StudyTaskSD
    var onDismiss: () -> Void

    private var showFocus: Bool { coverState.showFocus }

    var body: some View {
        Group {
            if showFocus {
                NavigationStack {
                    FocusViewEnhanced(task: task, breathingAlreadyDone: true, onSessionEnd: onDismiss)
                }
                .transition(.opacity)
            } else {
                BreatheView(
                    dismissOnComplete: false,
                    onComplete: { withAnimation { coverState.showFocus = true } },
                    onSkip: { withAnimation { coverState.showFocus = true } }
                )
                .environment(\.modelContext, modelContext)
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: showFocus)
    }
}
