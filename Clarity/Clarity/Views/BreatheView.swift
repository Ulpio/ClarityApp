//
//  BreatheView.swift
//  Clarity
//
//  Breathing exercise before focus
//

import SwiftUI
import Combine
import SwiftData

struct BreatheView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    let onComplete: () -> Void
    let onSkip: (() -> Void)?
    
    @State private var isAnimating = false
    @State private var scale: CGFloat = 0.8
    @State private var phase: BreathePhase = .inhale
    @State private var secondsRemaining = 30
    @State private var showSkipConfirmation = false
    
    private let breatheTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private let animationDuration: Double = 4.0
    
    enum BreathePhase {
        case inhale, hold, exhale, rest
        
        var instruction: String {
            switch self {
            case .inhale: return "Inspire"
            case .hold: return "Segure"
            case .exhale: return "Expire"
            case .rest: return "Descanse"
            }
        }
        
        var icon: String {
            switch self {
            case .inhale: return "arrow.down.circle.fill"
            case .hold: return "pause.circle.fill"
            case .exhale: return "arrow.up.circle.fill"
            case .rest: return "circle.fill"
            }
        }
        
        var duration: Double {
            switch self {
            case .inhale: return 4.0
            case .hold: return 2.0
            case .exhale: return 4.0
            case .rest: return 2.0
            }
        }
        
        var targetScale: CGFloat {
            switch self {
            case .inhale: return 1.2
            case .hold: return 1.2
            case .exhale: return 0.8
            case .rest: return 0.8
            }
        }
        
        func next() -> BreathePhase {
            switch self {
            case .inhale: return .hold
            case .hold: return .exhale
            case .exhale: return .rest
            case .rest: return .inhale
            }
        }
    }
    
    var body: some View {
        ZStack {
            // Background adaptivo
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                // Header
                VStack(spacing: 8) {
                    Text("Respire")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Prepare sua mente para focar")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 60)
                
                Spacer()
                
                // Breathing circle
                ZStack {
                    // Outer rings
                    ForEach(0..<3) { index in
                        Circle()
                            .stroke(Color.accentColor.opacity(0.3 - Double(index) * 0.1), lineWidth: 2)
                            .frame(width: 200 + CGFloat(index * 40), height: 200 + CGFloat(index * 40))
                            .scaleEffect(isAnimating ? 1.1 : 1.0)
                            .opacity(isAnimating ? 0 : 0.8)
                            .animation(
                                .easeInOut(duration: animationDuration)
                                .repeatForever(autoreverses: false)
                                .delay(Double(index) * 0.3),
                                value: isAnimating
                            )
                    }
                    
                    // Main circle
                    Circle()
                        .fill(Color.accentColor.opacity(0.15))
                        .frame(width: 200, height: 200)
                        .scaleEffect(scale)
                        .overlay(
                            Circle()
                                .stroke(Color.accentColor, lineWidth: 4)
                        )
                    
                    // Phase icon
                    Image(systemName: phase.icon)
                        .font(.system(size: 48))
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.tint)
                }
                
                // Instruction
                VStack(spacing: 12) {
                    Text(phase.instruction)
                        .font(.system(size: 32, weight: .medium, design: .rounded))
                        .foregroundStyle(.tint)
                    
                    Text("\(secondsRemaining)s restantes")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .monospacedDigit()
                }
                
                Spacer()
                
                // Actions
                VStack(spacing: 12) {
                    Button {
                        showSkipConfirmation = true
                    } label: {
                        Text("Pular")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color(.secondarySystemGroupedBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 32)
            }
        }
        .onAppear {
            startBreathing()
        }
        .onReceive(breatheTimer) { _ in
            if secondsRemaining > 0 {
                secondsRemaining -= 1
            } else {
                completeBreathing()
            }
        }
        .alert("Pular respiração?", isPresented: $showSkipConfirmation) {
            Button("Cancelar", role: .cancel) { }
            Button("Pular") {
                skipBreathing()
            }
        } message: {
            Text("Respirar ajuda você a focar melhor.")
        }
    }
    
    private func startBreathing() {
        isAnimating = true
        animatePhase()
    }
    
    private func animatePhase() {
        withAnimation(.easeInOut(duration: phase.duration)) {
            scale = phase.targetScale
        }
        
        // Schedule next phase
        DispatchQueue.main.asyncAfter(deadline: .now() + phase.duration) {
            guard secondsRemaining > 0 else { return }
            
            phase = phase.next()
            
            // Haptic feedback at phase transition
            if phase == .inhale || phase == .exhale {
                let generator = UIImpactFeedbackGenerator(style: .soft)
                generator.impactOccurred()
            }
            
            animatePhase()
        }
    }
    
    private func completeBreathing() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        dismiss()
        onComplete()
    }
    
    private func skipBreathing() {
        let settings = AppSettings.getOrCreate(context: modelContext)
        settings.totalBreathesSkipped += 1
        try? modelContext.save()
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
        
        dismiss()
        
        // Chamar callback de skip se fornecido
        onSkip?()
        
        // Ou callback normal
        if onSkip == nil {
            onComplete()
        }
    }
}

#Preview {
    BreatheView(onComplete: {}, onSkip: nil)
}
