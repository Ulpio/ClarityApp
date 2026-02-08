//
//  CompletionViewSD.swift
//  Clarity
//
//  Completion screen with confetti
//

import SwiftUI

struct CompletionViewSD: View {
    @Environment(\.dismiss) private var dismiss
    let task: StudyTaskSD
    var onDismissAll: (() -> Void)? = nil
    
    @State private var showConfetti = false
    @State private var showContent = false
    @State private var particlesystem = ConfettiParticleSystem()
    
    private let encouragingMessages = [
        "Bom trabalho.",
        "Você conseguiu.",
        "Um passo por vez.",
        "Continue assim.",
        "Você está progredindo.",
        "Parabéns!",
        "Muito bem!"
    ]
    
    private var randomMessage: String {
        encouragingMessages.randomElement() ?? encouragingMessages[0]
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 40) {
                Spacer()
                
                // Success icon
                ZStack {
                    // Animated circles
                    ForEach(0..<3) { index in
                        Circle()
                            .stroke(lineWidth: 2)
                            .fill(Color.green.opacity(0.3))
                            .frame(width: 120 + CGFloat(index * 40), height: 120 + CGFloat(index * 40))
                            .scaleEffect(showContent ? 1 : 0)
                            .opacity(showContent ? 0 : 1)
                            .animation(
                                .easeOut(duration: 1.0)
                                .delay(Double(index) * 0.15),
                                value: showContent
                            )
                    }
                    
                    Circle()
                        .fill(Color.green.opacity(0.12))
                        .frame(width: 140, height: 140)
                        .scaleEffect(showContent ? 1 : 0.5)
                    
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 80))
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.green, Color.green.opacity(0.2))
                        .scaleEffect(showContent ? 1 : 0)
                        .rotationEffect(.degrees(showContent ? 0 : -180))
                }
                .accessibilityLabel("Tarefa completa")
                
                // Completion message
                VStack(spacing: 16) {
                    Text("Tarefa completa!")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 20)
                        .accessibilityAddTraits(.isHeader)
                    
                    Text(randomMessage)
                        .font(.title3)
                        .foregroundStyle(.secondary)
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 20)
                }
                .multilineTextAlignment(.center)
                
                // Stats
                HStack(spacing: 32) {
                    StatBadge(
                        icon: "list.bullet",
                        value: "\(task.steps.count)",
                        label: "passos"
                    )
                    
                    if let completedAt = task.completedAt {
                        StatBadge(
                            icon: "clock.fill",
                            value: timeAgo(from: task.createdAt, to: completedAt),
                            label: "duração"
                        )
                    }
                }
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 20)
                
                Spacer()
                
                // Action buttons
                VStack(spacing: 12) {
                    Button(action: {
                        onDismissAll?()
                        dismiss()
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "house.fill")
                            Text("Voltar")
                                .fontWeight(.semibold)
                        }
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.green)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: .green.opacity(0.3), radius: 12, y: 6)
                    }
                    .accessibilityLabel("Voltar para a lista de tarefas")
                    
                    Button(action: {
                        task.reset()
                        dismiss()
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "arrow.counterclockwise")
                            Text("Estudar novamente")
                        }
                        .font(.headline)
                        .foregroundStyle(.green)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color(.secondarySystemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .accessibilityLabel("Reiniciar esta tarefa")
                }
                .opacity(showContent ? 1 : 0)
                .padding(24)
            }
            
            // Confetti overlay
            if showConfetti {
                ConfettiView(particleSystem: particlesystem)
                    .allowsHitTesting(false)
            }
        }
        .onAppear {
            // Haptic feedback
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            
            // Start confetti
            showConfetti = true
            particlesystem.startConfetti()
            
            // Animate content
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                showContent = true
            }
            
            // Stop confetti after 3 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    showConfetti = false
                }
            }
        }
    }
    
    private func timeAgo(from start: Date, to end: Date) -> String {
        let diff = Int(end.timeIntervalSince(start))
        let minutes = diff / 60
        
        if minutes < 1 {
            return "< 1m"
        } else if minutes < 60 {
            return "\(minutes)m"
        } else {
            let hours = minutes / 60
            return "\(hours)h"
        }
    }
}

struct StatBadge: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.secondary)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(width: 100)
        .padding(.vertical, 16)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Confetti System

@Observable
class ConfettiParticleSystem {
    var particles: [ConfettiParticle] = []
    
    func startConfetti() {
        particles = []
        for _ in 0..<50 {
            particles.append(ConfettiParticle())
        }
    }
}

struct ConfettiParticle: Identifiable {
    let id = UUID()
    let x: CGFloat = CGFloat.random(in: 0...1)
    let delay: Double = Double.random(in: 0...0.5)
    let duration: Double = Double.random(in: 2...4)
    let color: Color = [.red, .blue, .green, .yellow, .purple, .orange, .pink].randomElement()!
    let size: CGFloat = CGFloat.random(in: 8...14)
    let rotation: Double = Double.random(in: 0...360)
}

struct ConfettiView: View {
    let particleSystem: ConfettiParticleSystem
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(particleSystem.particles) { particle in
                    ConfettiPiece(
                        particle: particle,
                        geometry: geometry
                    )
                }
            }
        }
    }
}

struct ConfettiPiece: View {
    let particle: ConfettiParticle
    let geometry: GeometryProxy
    
    @State private var yPosition: CGFloat = -50
    @State private var rotation: Double = 0
    @State private var opacity: Double = 1
    
    var body: some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(particle.color)
            .frame(width: particle.size, height: particle.size * 1.5)
            .rotationEffect(.degrees(rotation))
            .opacity(opacity)
            .position(
                x: geometry.size.width * particle.x,
                y: yPosition
            )
            .onAppear {
                withAnimation(
                    .easeIn(duration: particle.duration)
                    .delay(particle.delay)
                ) {
                    yPosition = geometry.size.height + 50
                    opacity = 0
                }
                
                withAnimation(
                    .linear(duration: particle.duration * 0.5)
                    .repeatForever(autoreverses: true)
                    .delay(particle.delay)
                ) {
                    rotation = particle.rotation + 360
                }
            }
    }
}

#Preview {
    let task = StudyTaskSD(
        title: "Matemática",
        steps: [
            StudyStepSD(description: "Passo 1", isCompleted: true, order: 0),
            StudyStepSD(description: "Passo 2", isCompleted: true, order: 1)
        ]
    )
    task.markAsCompleted()
    
    return CompletionViewSD(task: task)
}
