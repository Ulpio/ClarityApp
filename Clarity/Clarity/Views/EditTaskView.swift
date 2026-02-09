//
//  EditTaskView.swift
//  Clarity
//
//  Editar título, categoria e passos de uma tarefa existente.
//

import SwiftUI
import SwiftData

struct EditTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Category.order) private var categories: [Category]
    @Bindable var task: StudyTaskSD

    @State private var taskTitle: String = ""
    @State private var stepRows: [EditStepRowState] = []
    @State private var selectedCategory: Category?
    @FocusState private var focusedField: Int?

    private var isValid: Bool {
        !taskTitle.trimmingCharacters(in: .whitespaces).isEmpty &&
        stepRows.contains { !$0.text.trimmingCharacters(in: .whitespaces).isEmpty }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    titleSection
                    categorySection
                    stepsSection
                }
                .padding()
            }
            .navigationTitle("Editar tarefa")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Salvar") { saveTask() }
                        .disabled(!isValid)
                        .fontWeight(.semibold)
                }
            }
            .onAppear { loadTask() }
        }
    }

    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Título")
                .font(.headline)
            TextField("Ex: Matemática", text: $taskTitle)
                .textFieldStyle(.plain)
                .font(.title2)
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .accessibilityLabel("Título da tarefa")
        }
    }

    private var categorySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Categoria")
                .font(.headline)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(categories) { category in
                        CategoryChip(
                            category: category,
                            isSelected: selectedCategory?.id == category.id
                        ) {
                            withAnimation(.spring(response: 0.3)) {
                                selectedCategory = category
                            }
                        }
                    }
                }
            }
        }
    }

    private var stepsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Passos")
                .font(.headline)
            VStack(spacing: 12) {
                ForEach(stepRows) { row in
                    EditTaskStepRowWrapper(
                        stepRows: $stepRows,
                        rowId: row.id,
                        stepRowsCount: stepRows.count,
                        focusedField: $focusedField,
                        onAddStep: addStep,
                        onRemoveStep: removeStep
                    )
                }
            }
            Button {
                addStep()
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "plus.circle.fill")
                    Text("Adicionar passo")
                }
                .font(.headline)
                .foregroundStyle(selectedCategory?.color ?? Color.accentColor)
            }
            .padding(.top, 8)
        }
    }

    private func loadTask() {
        taskTitle = task.title
        selectedCategory = task.category
        stepRows = task.steps.sorted { $0.order < $1.order }.map { step in
            EditStepRowState(id: step.id, text: step.stepDescription, minutes: step.estimatedMinutes)
        }
        if stepRows.isEmpty { stepRows = [EditStepRowState(id: UUID(), text: "", minutes: 0)] }
    }

    private func addStep() {
        withAnimation {
            stepRows.append(EditStepRowState(id: UUID(), text: "", minutes: 0))
            focusedField = stepRows.count - 1
        }
    }

    private func removeStep(id: UUID) {
        guard let removedIndex = stepRows.firstIndex(where: { $0.id == id }) else { return }
        withAnimation {
            stepRows.removeAll { $0.id == id }
            if focusedField == removedIndex {
                focusedField = nil
            } else if let f = focusedField, f > removedIndex {
                focusedField = max(0, f - 1)
            }
        }
    }

    private func saveTask() {
        task.title = taskTitle.trimmingCharacters(in: .whitespaces)
        task.category = selectedCategory

        let validData = stepRows
            .map { (id: $0.id, text: $0.text.trimmingCharacters(in: .whitespaces), minutes: $0.minutes) }
            .filter { !$0.text.isEmpty }

        var newSteps: [StudyStepSD] = []
        for (index, item) in validData.enumerated() {
            if let existing = task.steps.first(where: { $0.id == item.id }) {
                existing.stepDescription = item.text
                existing.estimatedMinutes = item.minutes
                existing.order = index
                newSteps.append(existing)
            } else {
                let step = StudyStepSD(description: item.text, order: index, estimatedMinutes: item.minutes)
                modelContext.insert(step)
                newSteps.append(step)
            }
        }
        let toRemove = task.steps.filter { old in !newSteps.contains(where: { $0.id == old.id }) }
        for step in toRemove {
            task.steps.removeAll { $0.id == step.id }
            modelContext.delete(step)
        }
        task.steps = newSteps
        try? modelContext.save()
        dismiss()
    }
}

private struct EditStepRowState: Identifiable {
    var id: UUID
    var text: String
    var minutes: Int
}

/// Wrapper que cria bindings por id (nunca por índice), evitando crash ao remover um passo na edição.
private struct EditTaskStepRowWrapper: View {
    @Binding var stepRows: [EditStepRowState]
    let rowId: UUID
    let stepRowsCount: Int
    @FocusState.Binding var focusedField: Int?
    let onAddStep: () -> Void
    let onRemoveStep: (UUID) -> Void

    private var index: Int? {
        stepRows.firstIndex(where: { $0.id == rowId })
    }

    private var textBinding: Binding<String> {
        Binding(
            get: {
                guard let i = stepRows.firstIndex(where: { $0.id == rowId }) else { return "" }
                return stepRows[i].text
            },
            set: { newValue in
                var arr = stepRows
                guard let i = arr.firstIndex(where: { $0.id == rowId }) else { return }
                arr[i].text = newValue
                stepRows = arr
            }
        )
    }

    private var minutesBinding: Binding<Int> {
        Binding(
            get: {
                guard let i = stepRows.firstIndex(where: { $0.id == rowId }) else { return 0 }
                return stepRows[i].minutes
            },
            set: { newValue in
                var arr = stepRows
                guard let i = arr.firstIndex(where: { $0.id == rowId }) else { return }
                arr[i].minutes = newValue
                stepRows = arr
            }
        )
    }

    var body: some View {
        if let idx = index {
            EditTaskFormStepRow(
                number: idx + 1,
                text: textBinding,
                estimatedMinutes: minutesBinding,
                canDelete: stepRowsCount > 1,
                isFocused: focusedField == idx,
                onFocus: { focusedField = idx },
                onSubmit: {
                    if idx == stepRowsCount - 1 { onAddStep() }
                    else { focusedField = idx + 1 }
                },
                onDelete: { onRemoveStep(rowId) }
            )
            .focused($focusedField, equals: idx)
        } else {
            EmptyView()
        }
    }
}

/// Linha de passo no formulário de edição de tarefa (não confundir com EditTaskStepsView.EditStepRow).
private struct EditTaskFormStepRow: View {
    let number: Int
    @Binding var text: String
    @Binding var estimatedMinutes: Int
    let canDelete: Bool
    let isFocused: Bool
    let onFocus: () -> Void
    let onSubmit: () -> Void
    let onDelete: () -> Void

    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 12) {
                Text("\(number).")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .frame(width: 28, alignment: .trailing)
                TextField("Ex: Abrir o caderno", text: $text)
                    .textFieldStyle(.plain)
                    .padding()
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .onSubmit(onSubmit)
                    .accessibilityLabel("Passo \(number)")
                if canDelete {
                    Button(action: onDelete) {
                        Image(systemName: "minus.circle.fill")
                            .font(.title3)
                            .foregroundStyle(.red)
                    }
                    .accessibilityLabel("Remover passo \(number)")
                }
            }
            HStack(spacing: 8) {
                Spacer().frame(width: 40)
                Image(systemName: "clock").font(.caption).foregroundStyle(.secondary)
                Menu {
                    Button("Sem tempo") { estimatedMinutes = 0 }
                    Button("5 min") { estimatedMinutes = 5 }
                    Button("10 min") { estimatedMinutes = 10 }
                    Button("15 min") { estimatedMinutes = 15 }
                    Button("20 min") { estimatedMinutes = 20 }
                    Button("30 min") { estimatedMinutes = 30 }
                    Button("60 min") { estimatedMinutes = 60 }
                } label: {
                    Text(estimatedMinutes > 0 ? "\(estimatedMinutes) min" : "Tempo")
                        .font(.subheadline)
                        .foregroundStyle(estimatedMinutes > 0 ? Color.accentColor : .secondary)
                }
                Spacer()
            }
        }
    }
}
