//
//  FocusView.swift
//  Clarity
//
//  Focus mode - displays one step at a time
//

import SwiftUI

struct FocusView: View {
    @Environment(StudyStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    
    let task: StudyTask
    @State private var currentTask: StudyTask
    @State private var showingCompletion = false
    
    init(task: StudyTask) {
        self.task = task
        self._currentTask = State(initialValue: task)
    }
    
    private var currentStepIndex: Int? {
        currentTask.currentStepIndex
    }
    
    private var currentStep: StudyStep? {
        guard let index = currentStepIndex else { return nil }
        return currentTask.steps[index]
    }
    
    var body: some View {
        Group {
            if currentTask.isCompleted {
                CompletionView(task: currentTask)
            } else if let step = currentStep, let index = currentStepIndex {
                focusContent(step: step, index: index)
            } else {
                Text("Nenhum passo disponível")
                    .foregroundStyle(.secondary)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack(spacing: 2) {
                    Text(currentTask.title)
                        .font(.headline)
                    if let index = currentStepIndex {
                        Text("Passo \(index + 1) de \(currentTask.steps.count)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .onChange(of: store.tasks) { _, newTasks in
            if let updatedTask = newTasks.first(where: { $0.id == task.id }) {
                currentTask = updatedTask
            }
        }
    }
    
    private func focusContent(step: StudyStep, index: Int) -> some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Current step display
            VStack(spacing: 24) {
                Image(systemName: stepIcon(for: index))
                    .font(.system(size: 56))
                    .foregroundStyle(Color.accentColor)
                    .accessibilityHidden(true)
                
                Text(step.description)
                    .font(.system(size: 28, weight: .medium, design: .rounded))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .accessibilityAddTraits(.isHeader)
            }
            
            Spacer()
            
            // Progress indicator
            VStack(spacing: 16) {
                ProgressView(value: currentTask.progress)
                    .tint(Color.accentColor)
                    .accessibilityLabel("Progresso: \(Int(currentTask.progress * 100))%")
                
                // Complete button
                Button {
                    completeCurrentStep()
                } label: {
                    Text("Completei este passo")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .background(Color.accentColor)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .accessibilityLabel("Marcar passo como completo")
                .accessibilityHint("Avança para o próximo passo")
            }
            .padding()
        }
        .padding()
    }
    
    private func stepIcon(for index: Int) -> String {
        let icons = [
            "1.circle.fill",
            "2.circle.fill",
            "3.circle.fill",
            "4.circle.fill",
            "5.circle.fill",
            "6.circle.fill",
            "7.circle.fill",
            "8.circle.fill",
            "9.circle.fill"
        ]
        
        if index < icons.count {
            return icons[index]
        } else {
            return "circle.fill"
        }
    }
    
    private func completeCurrentStep() {
        guard let step = currentStep else { return }
        
        // Haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        // Animate completion
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            store.completeStep(taskId: task.id, stepId: step.id)
        }
    }
}

#Preview {
    NavigationStack {
        FocusView(task: StudyTask(
            title: "Matemática",
            steps: [
                StudyStep(description: "Abrir o caderno"),
                StudyStep(description: "Revisar o último tópico"),
                StudyStep(description: "Ler uma página"),
                StudyStep(description: "Fazer uma pausa curta")
            ]
        ))
    }
    .environment(StudyStore())
}
