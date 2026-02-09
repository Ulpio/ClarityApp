//
//  EditTaskStepsView.swift
//  Clarity
//
//  Editar passos da tarefa durante a atividade.
//

import SwiftUI
import SwiftData

struct EditTaskStepsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    let task: StudyTaskSD
    
    /// Passos ordenados por `order` para exibição consistente
    private var sortedSteps: [StudyStepSD] {
        task.steps.sorted { $0.order < $1.order }
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(Array(sortedSteps.enumerated()), id: \.element.id) { index, step in
                        EditStepRow(step: step, stepNumber: index + 1, canDelete: sortedSteps.count > 1) {
                            deleteStep(step)
                        }
                    }
                } header: {
                    Text("Passos")
                } footer: {
                    Text("Altere a descrição ou o tempo estimado. As alterações valem a partir do próximo passo.")
                }
                
                Section {
                    Button {
                        addStep()
                    } label: {
                        Label("Adicionar passo", systemImage: "plus.circle.fill")
                            .foregroundStyle(.tint)
                    }
                }
            }
            .navigationTitle("Editar passos")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Concluído") {
                        saveAndDismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
    
    private func addStep() {
        let newOrder = task.steps.count
        let newStep = StudyStepSD(description: "Novo passo", order: newOrder)
        modelContext.insert(newStep)
        task.steps.append(newStep)
        try? modelContext.save()
    }
    
    private func deleteStep(_ step: StudyStepSD) {
        task.steps.removeAll { $0.id == step.id }
        modelContext.delete(step)
        refreshOrder()
        try? modelContext.save()
    }
    
    private func refreshOrder() {
        for (index, step) in task.steps.enumerated() {
            step.order = index
        }
    }
    
    private func saveAndDismiss() {
        refreshOrder()
        try? modelContext.save()
        dismiss()
    }
}

struct EditStepRow: View {
    @Bindable var step: StudyStepSD
    let stepNumber: Int
    let canDelete: Bool
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                Text("\(stepNumber).")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(width: 24, alignment: .trailing)
                
                TextField("Descrição", text: $step.stepDescription)
                    .textFieldStyle(.plain)
            }
            
            HStack {
                Text("Tempo estimado (min)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Stepper("\(step.estimatedMinutes) min", value: $step.estimatedMinutes, in: 0...120, step: 5)
                    .labelsHidden()
                Text("\(step.estimatedMinutes) min")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(width: 50, alignment: .trailing)
            }
            
            if canDelete {
                Button(role: .destructive, action: onDelete) {
                    Label("Remover passo", systemImage: "trash")
                        .font(.subheadline)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
