//
//  HomeViewSD.swift
//  Clarity
//
//  Main screen with SwiftData support
//

import SwiftUI
import SwiftData

struct HomeViewSD: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \StudyTaskSD.createdAt, order: .reverse) private var allTasks: [StudyTaskSD]
    @Query(sort: \Category.order) private var categories: [Category]
    
    @State private var showingCreateTask = false
    @State private var selectedCategory: Category?
    @State private var showStats = false
    @State private var showTemplates = false
    @State private var showAchievements = false
    @State private var showSettings = false
    
    private var filteredTasks: [StudyTaskSD] {
        if let category = selectedCategory {
            return allTasks.filter { $0.category?.id == category.id }
        }
        return allTasks
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                if allTasks.isEmpty {
                    emptyStateView
                } else {
                    taskListView
                }
            }
            .navigationTitle("Clarity")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        Button {
                            selectedCategory = nil
                        } label: {
                            Label("Todas", systemImage: "list.bullet")
                        }
                        
                        Divider()
                        
                        ForEach(categories) { category in
                            Button {
                                selectedCategory = category
                            } label: {
                                Label(category.name, systemImage: category.icon)
                            }
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: selectedCategory?.icon ?? "line.3.horizontal.decrease.circle")
                            if let category = selectedCategory {
                                Text(category.name)
                                    .font(.subheadline)
                            }
                        }
                        .foregroundStyle(selectedCategory?.color ?? .primary)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button {
                            showTemplates = true
                        } label: {
                            Label("Templates", systemImage: "doc.text.fill")
                        }
                        
                        Button {
                            showAchievements = true
                        } label: {
                            Label("Conquistas", systemImage: "trophy.fill")
                        }
                        
                        Button {
                            showStats = true
                        } label: {
                            Label("Estatísticas", systemImage: "chart.bar.fill")
                        }
                        
                        Divider()
                        
                        Button {
                            showSettings = true
                        } label: {
                            Label("Configurações", systemImage: "gearshape.fill")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle.fill")
                            .font(.title3)
                            .symbolRenderingMode(.hierarchical)
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingCreateTask = true
                    } label: {
                        Label("Criar tarefa", systemImage: "plus.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                    }
                    .accessibilityLabel("Criar nova tarefa de estudo")
                }
            }
            .sheet(isPresented: $showingCreateTask) {
                CreateTaskViewSD()
            }
            .sheet(isPresented: $showStats) {
                StatsView(tasks: allTasks)
            }
            .sheet(isPresented: $showTemplates) {
                TemplatesView()
            }
            .sheet(isPresented: $showAchievements) {
                AchievementsView()
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 32) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(Color.accentColor.opacity(0.12))
                    .frame(width: 140, height: 140)
                
                Image(systemName: "book.closed.fill")
                    .font(.system(size: 60))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(.tint)
            }
            
            VStack(spacing: 12) {
                Text("O que você quer estudar hoje?")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                
                Text("Divida em passos simples.\nUm passo por vez.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: 12) {
                Button {
                    showingCreateTask = true
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "plus.circle.fill")
                        Text("Criar primeira tarefa")
                    }
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.accentColor)
                    .clipShape(Capsule())
                    .shadow(color: Color.accentColor.opacity(0.3), radius: 10, y: 5)
                }
                .accessibilityLabel("Criar sua primeira tarefa de estudo")
                
                Button {
                    showTemplates = true
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "doc.text")
                        Text("Ver templates")
                    }
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.tint)
                }
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
        .padding()
    }
    
    private var taskListView: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text(selectedCategory?.name ?? "Todas as tarefas")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("\(filteredTasks.count) \(filteredTasks.count == 1 ? "tarefa" : "tarefas")")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.top)
                
                // Tasks
                LazyVStack(spacing: 16) {
                    ForEach(filteredTasks) { task in
                        TaskCardSD(task: task)
                            .transition(.asymmetric(
                                insertion: .scale.combined(with: .opacity),
                                removal: .opacity
                            ))
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct TaskCardSD: View {
    @Environment(\.modelContext) private var modelContext
    let task: StudyTaskSD
    @State private var showDeleteAlert = false
    
    var body: some View {
        NavigationLink {
            FocusViewEnhanced(task: task)
        } label: {
            VStack(alignment: .leading, spacing: 16) {
                // Header com categoria
                HStack {
                    if let category = task.category {
                        HStack(spacing: 6) {
                            Image(systemName: category.icon)
                                .font(.caption)
                            Text(category.name)
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                        .foregroundStyle(category.color)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(category.color.opacity(0.15))
                        .clipShape(Capsule())
                    }
                    
                    Spacer()
                    
                    if task.isCompleted {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title3)
                            .foregroundStyle(.green)
                            .accessibilityLabel("Tarefa completa")
                    }
                }
                
                // Título
                Text(task.title)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.leading)
                
                // Info e progresso
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 16) {
                        HStack(spacing: 6) {
                            Image(systemName: "list.bullet")
                                .font(.caption)
                            Text("\(task.steps.count) \(task.steps.count == 1 ? "passo" : "passos")")
                                .font(.subheadline)
                        }
                        .foregroundStyle(.secondary)
                        
                        if !task.isCompleted, let currentIndex = task.currentStepIndex {
                            HStack(spacing: 6) {
                                Image(systemName: "circle.fill")
                                    .font(.system(size: 4))
                                Text("Passo \(currentIndex + 1)")
                                    .font(.subheadline)
                            }
                            .foregroundStyle(.secondary)
                        }
                    }
                    
                    if !task.steps.isEmpty {
                        ProgressView(value: task.progress)
                            .tint(task.category?.color ?? Color.accentColor)
                            .accessibilityLabel("Progresso: \(Int(task.progress * 100))%")
                    }
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.secondarySystemGroupedBackground))
                    .shadow(color: Color(.systemFill).opacity(0.3), radius: 8, y: 4)
            )
        }
        .buttonStyle(.plain)
        .contextMenu {
            if task.isCompleted {
                Button {
                    withAnimation {
                        task.reset()
                    }
                } label: {
                    Label("Reiniciar", systemImage: "arrow.counterclockwise")
                }
            }
            
            Button(role: .destructive) {
                showDeleteAlert = true
            } label: {
                Label("Excluir", systemImage: "trash")
            }
        }
        .alert("Excluir tarefa?", isPresented: $showDeleteAlert) {
            Button("Cancelar", role: .cancel) { }
            Button("Excluir", role: .destructive) {
                withAnimation {
                    modelContext.delete(task)
                }
            }
        } message: {
            Text("Esta ação não pode ser desfeita.")
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: StudyTaskSD.self, Category.self, configurations: config)
    
    return HomeViewSD()
        .modelContainer(container)
}
