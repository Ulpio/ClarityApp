//
//  CompletionView.swift
//  Clarity
//
//  Displayed when a study task is completed
//

import SwiftUI

struct CompletionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(StudyStore.self) private var store
    
    let task: StudyTask
    @State private var showConfetti = false
    
    private let encouragingMessages = [
        "Bom trabalho.",
        "Você conseguiu.",
        "Um passo por vez.",
        "Continue assim.",
        "Você está progredindo."
    ]
    
    private var randomMessage: String {
        encouragingMessages.randomElement() ?? encouragingMessages[0]
    }
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            // Success icon
            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(.green)
                    .scaleEffect(showConfetti ? 1 : 0)
                    .animation(.spring(response: 0.5, dampingFraction: 0.6), value: showConfetti)
            }
            .accessibilityLabel("Tarefa completa")
            
            // Completion message
            VStack(spacing: 16) {
                Text("Tarefa completa")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .accessibilityAddTraits(.isHeader)
                
                Text(randomMessage)
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }
            .multilineTextAlignment(.center)
            
            Spacer()
            
            // Action buttons
            VStack(spacing: 12) {
                Button(action: { dismiss() }) {
                    Text("Voltar")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color.accentColor)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .accessibilityLabel("Voltar para a lista de tarefas")
                
                Button(action: {
                    store.resetTask(task)
                    dismiss()
                }) {
                    Text("Estudar novamente")
                        .font(.headline)
                        .foregroundStyle(Color.accentColor)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .accessibilityLabel("Reiniciar esta tarefa")
            }
            .padding()
        }
        .padding()
        .onAppear {
            showConfetti = true
            
            // Haptic feedback
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }
    }
}

#Preview {
    CompletionView(task: StudyTask(
        title: "Matemática",
        steps: [
            StudyStep(description: "Abrir o caderno", isCompleted: true),
            StudyStep(description: "Revisar o último tópico", isCompleted: true)
        ]
    ))
    .environment(StudyStore())
}
