//
//  CreateTaskViewSD.swift
//  Clarity
//
//  Create new tasks with SwiftData
//

import SwiftUI
import SwiftData

struct CreateTaskViewSD: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Category.order) private var categories: [Category]
    
    @State private var taskTitle = ""
    @State private var steps: [String] = [""]
    @State private var stepTimes: [Int] = [0] // Tempo estimado em minutos
    @State private var selectedCategory: Category?
    @FocusState private var focusedField: Int?
    
    private var isValid: Bool {
        !taskTitle.trimmingCharacters(in: .whitespaces).isEmpty &&
        steps.contains { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
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
        VStack(alignment: .leading, spacing: 12) {
            Text("O que você quer estudar?")
                .font(.headline)
                .accessibilityAddTraits(.isHeader)
            
            TextField("Ex: Matemática", text: $taskTitle)
                .textFieldStyle(.plain)
                .font(.title2)
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .submitLabel(.next)
                .onSubmit {
                    focusedField = 0
                }
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
            VStack(alignment: .leading, spacing: 8) {
                Text("Divida em passos simples")
                    .font(.headline)
                
                Text("Um passo por vez. Use ações claras e diretas.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            VStack(spacing: 12) {
                ForEach(steps.indices, id: \.self) { index in
                    StepRowWithTime(
                        number: index + 1,
                        text: $steps[index],
                        estimatedMinutes: $stepTimes[index],
                        canDelete: steps.count > 1,
                        isFocused: focusedField == index,
                        onFocus: { focusedField = index },
                        onSubmit: {
                            if index == steps.count - 1 {
                                addStep()
                            } else {
                                focusedField = index + 1
                            }
                        },
                        onDelete: {
                            removeStep(at: index)
                        }
                    )
                    .focused($focusedField, equals: index)
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
    
    private func addStep() {
        withAnimation {
            steps.append("")
            stepTimes.append(0)
            focusedField = steps.count - 1
        }
    }
    
    private func removeStep(at index: Int) {
        withAnimation {
            steps.remove(at: index)
            stepTimes.remove(at: index)
            if focusedField == index {
                focusedField = nil
            }
        }
    }
    
    private func createTask() {
        let validSteps = zip(steps, stepTimes)
            .map { (desc, time) in (desc.trimmingCharacters(in: .whitespaces), time) }
            .filter { !$0.0.isEmpty }
            .enumerated()
            .map { index, stepData in
                StudyStepSD(
                    description: stepData.0,
                    order: index,
                    estimatedMinutes: stepData.1
                )
            }
        
        let task = StudyTaskSD(
            title: taskTitle.trimmingCharacters(in: .whitespaces),
            steps: validSteps,
            category: selectedCategory
        )
        
        modelContext.insert(task)
        
        dismiss()
    }
}

struct CategoryChip: View {
    let category: Category
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: category.icon)
                    .font(.callout)
                Text(category.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .foregroundStyle(isSelected ? .white : category.color)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? category.color : category.color.opacity(0.15))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(category.color, lineWidth: isSelected ? 0 : 1)
            )
        }
        .buttonStyle(.plain)
    }
}

struct StepRowWithTime: View {
    let number: Int
    @Binding var text: String
    @Binding var estimatedMinutes: Int
    let canDelete: Bool
    let isFocused: Bool
    let onFocus: () -> Void
    let onSubmit: () -> Void
    let onDelete: () -> Void
    
    @State private var showTimePicker = false
    
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
                    .submitLabel(number == 1 ? .next : .done)
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
            
            // Time selector
            HStack(spacing: 8) {
                Spacer()
                    .frame(width: 40)
                
                Image(systemName: "clock")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Menu {
                    Button("Sem tempo definido") {
                        estimatedMinutes = 0
                    }
                    Button("5 minutos") {
                        estimatedMinutes = 5
                    }
                    Button("10 minutos") {
                        estimatedMinutes = 10
                    }
                    Button("15 minutos") {
                        estimatedMinutes = 15
                    }
                    Button("20 minutos") {
                        estimatedMinutes = 20
                    }
                    Button("30 minutos") {
                        estimatedMinutes = 30
                    }
                    Button("45 minutos") {
                        estimatedMinutes = 45
                    }
                    Button("60 minutos") {
                        estimatedMinutes = 60
                    }
                    Button("Personalizar...") {
                        showTimePicker = true
                    }
                } label: {
                    HStack(spacing: 6) {
                        Text(estimatedMinutes > 0 ? "\(estimatedMinutes) min" : "Definir tempo")
                            .font(.subheadline)
                        Image(systemName: "chevron.down")
                            .font(.caption2)
                    }
                    .foregroundStyle(estimatedMinutes > 0 ? Color.accentColor : Color.secondary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(estimatedMinutes > 0 ? Color(.tertiarySystemGroupedBackground) : Color(.secondarySystemGroupedBackground))
                    )
                }
                
                if estimatedMinutes > 0 {
                    Text("(mín: \(Int(Double(estimatedMinutes) * 0.6))min)")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
            }
            .padding(.leading, 40)
        }
        .alert("Tempo Personalizado", isPresented: $showTimePicker) {
            TextField("Minutos", value: $estimatedMinutes, format: .number)
                .keyboardType(.numberPad)
            Button("OK") { }
            Button("Cancelar", role: .cancel) { }
        } message: {
            Text("Digite o tempo estimado em minutos")
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Category.self, configurations: config)
    
    let context = container.mainContext
    for category in Category.defaultCategories {
        context.insert(category)
    }
    
    return CreateTaskViewSD()
        .modelContainer(container)
}
