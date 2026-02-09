//
//  TaskReadyView.swift
//  Clarity
//
//  Tela exibida após criar uma tarefa, com botão para iniciar.
//

import SwiftUI
import SwiftData

struct TaskReadyView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    let task: StudyTaskSD
    var onStart: () -> Void
    var onBack: () -> Void

    @State private var showEditTask = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    headerCard
                    stepsList
                    Spacer(minLength: 24)
                    actionsSection
                }
                .padding()
            }
            .navigationTitle("Tarefa criada")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Voltar à lista") {
                        onBack()
                        dismiss()
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showEditTask = true
                    } label: {
                        Image(systemName: "pencil.circle")
                            .symbolRenderingMode(.hierarchical)
                    }
                    .accessibilityLabel("Editar tarefa")
                }
            }
            .sheet(isPresented: $showEditTask) {
                EditTaskView(task: task)
                    .environment(\.modelContext, modelContext)
            }
        }
    }
    
    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                if let category = task.category {
                    HStack(spacing: 6) {
                        CategoryIconView(category: category)
                        Text(category.name)
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    .foregroundStyle(category.color)
                }
                Spacer()
                Text("\(task.steps.count) \(task.steps.count == 1 ? "passo" : "passos")")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Text(task.title)
                .font(.title2)
                .fontWeight(.bold)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var stepsList: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Passos")
                .font(.headline)
            
            ForEach(Array(task.steps.enumerated()), id: \.element.id) { index, step in
                HStack(alignment: .top, spacing: 12) {
                    Text("\(index + 1).")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .frame(width: 24, alignment: .trailing)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(step.stepDescription)
                            .font(.body)
                        if step.estimatedMinutes > 0 {
                            Text(step.estimatedTimeText)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(Color(.tertiarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }
    
    private var actionsSection: some View {
        VStack(spacing: 12) {
            Button {
                onStart()
                dismiss()
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "play.fill")
                    Text("Iniciar tarefa")
                        .fontWeight(.semibold)
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.accentColor)
                .clipShape(Capsule())
            }
            .accessibilityLabel("Iniciar tarefa")
        }
        .padding(.top, 8)
    }
}
