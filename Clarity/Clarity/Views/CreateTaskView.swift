//
//  CreateTaskView.swift
//  Clarity
//
//  View for creating a new study task
//

import SwiftUI

struct CreateTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(StudyStore.self) private var store
    
    @State private var taskTitle = ""
    @State private var steps: [String] = [""]
    @FocusState private var focusedField: Int?
    
    private var isValid: Bool {
        !taskTitle.trimmingCharacters(in: .whitespaces).isEmpty &&
        steps.contains { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    titleSection
                    stepsSection
                }
                .padding()
            }
            .navigationTitle("Nova Tarefa")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Criar") {
                        createTask()
                    }
                    .disabled(!isValid)
                    .fontWeight(.semibold)
                }
            }
        }
    }
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("O que você quer estudar?")
                .font(.headline)
                .accessibilityAddTraits(.isHeader)
            
            TextField("Ex: Matemática", text: $taskTitle)
                .textFieldStyle(.roundedBorder)
                .font(.title3)
                .submitLabel(.next)
                .onSubmit {
                    focusedField = 0
                }
                .accessibilityLabel("Título da tarefa")
        }
    }
    
    private var stepsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Divida em passos simples")
                .font(.headline)
                .accessibilityAddTraits(.isHeader)
            
            Text("Um passo por vez. Use ações claras e diretas.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            ForEach(steps.indices, id: \.self) { index in
                HStack(spacing: 12) {
                    Text("\(index + 1).")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                        .frame(width: 24, alignment: .trailing)
                    
                    TextField("Ex: Abrir o caderno", text: $steps[index])
                        .textFieldStyle(.roundedBorder)
                        .focused($focusedField, equals: index)
                        .submitLabel(index == steps.count - 1 ? .done : .next)
                        .onSubmit {
                            if index == steps.count - 1 {
                                addStep()
                            } else {
                                focusedField = index + 1
                            }
                        }
                        .accessibilityLabel("Passo \(index + 1)")
                    
                    if steps.count > 1 {
                        Button {
                            removeStep(at: index)
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .foregroundStyle(.red)
                        }
                        .accessibilityLabel("Remover passo \(index + 1)")
                    }
                }
            }
            
            Button {
                addStep()
            } label: {
                Label("Adicionar passo", systemImage: "plus.circle.fill")
                    .font(.headline)
            }
            .padding(.top, 8)
        }
    }
    
    private func addStep() {
        steps.append("")
        focusedField = steps.count - 1
    }
    
    private func removeStep(at index: Int) {
        steps.remove(at: index)
        if focusedField == index {
            focusedField = nil
        }
    }
    
    private func createTask() {
        let validSteps = steps
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
            .map { StudyStep(description: $0) }
        
        let task = StudyTask(
            title: taskTitle.trimmingCharacters(in: .whitespaces),
            steps: validSteps
        )
        
        store.addTask(task)
        dismiss()
    }
}

#Preview {
    CreateTaskView()
        .environment(StudyStore())
}
