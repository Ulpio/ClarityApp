//
//  HomeView.swift
//  Clarity
//
//  Main screen displaying study tasks
//

import SwiftUI

struct HomeView: View {
    @Environment(StudyStore.self) private var store
    @State private var showingCreateTask = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                if store.tasks.isEmpty {
                    emptyStateView
                } else {
                    taskListView
                }
            }
            .navigationTitle("Clarity")
            .toolbar {
                #if DEBUG
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        store.clearAllData()
                    } label: {
                        Label("Limpar", systemImage: "trash")
                    }
                    .foregroundStyle(.red)
                }
                #endif
                
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingCreateTask = true
                    } label: {
                        Label("Criar tarefa", systemImage: "plus")
                    }
                    .accessibilityLabel("Criar nova tarefa de estudo")
                }
            }
            .sheet(isPresented: $showingCreateTask) {
                CreateTaskView()
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Image(systemName: "book.closed")
                .font(.system(size: 64))
                .foregroundStyle(.secondary)
            
            Text("O que você quer estudar hoje?")
                .font(.title2)
                .multilineTextAlignment(.center)
            
            Button {
                showingCreateTask = true
            } label: {
                Text("Criar primeira tarefa")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal, 40)
            .accessibilityLabel("Criar sua primeira tarefa de estudo")
        }
        .padding()
    }
    
    private var taskListView: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("O que você quer estudar agora?")
                    .font(.title2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top)
                    .accessibilityAddTraits(.isHeader)
                
                LazyVStack(spacing: 12) {
                    ForEach(store.tasks) { task in
                        TaskCard(task: task)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct TaskCard: View {
    @Environment(StudyStore.self) private var store
    let task: StudyTask
    
    var body: some View {
        NavigationLink {
            FocusView(task: task)
        } label: {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(task.title)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                    
                    Spacer()
                    
                    if task.isCompleted {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                            .accessibilityLabel("Tarefa completa")
                    }
                }
                
                HStack(spacing: 8) {
                    Image(systemName: "list.bullet")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text("\(task.steps.count) passos")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    if !task.isCompleted, let currentIndex = task.currentStepIndex {
                        Text("• Passo \(currentIndex + 1)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                
                if !task.steps.isEmpty {
                    ProgressView(value: task.progress)
                        .tint(Color.accentColor)
                        .accessibilityLabel("Progresso: \(Int(task.progress * 100))%")
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
        }
        .buttonStyle(.plain)
        .contextMenu {
            if task.isCompleted {
                Button {
                    store.resetTask(task)
                } label: {
                    Label("Reiniciar", systemImage: "arrow.counterclockwise")
                }
            }
            
            Button(role: .destructive) {
                store.deleteTask(task)
            } label: {
                Label("Excluir", systemImage: "trash")
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(task.title). \(task.steps.count) passos.")
        .accessibilityHint("Toque para começar a estudar")
    }
}

#Preview {
    HomeView()
        .environment(StudyStore())
}
