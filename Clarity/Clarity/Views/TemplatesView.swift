//
//  TemplatesView.swift
//  Clarity
//
//  Browse and use task templates
//

import SwiftUI
import SwiftData

struct TemplatesView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Category.order) private var categories: [Category]
    
    @State private var selectedCategory: String = "Todos"
    
    private var filteredTemplates: [TaskTemplate] {
        if selectedCategory == "Todos" {
            return TaskTemplate.templates
        }
        return TaskTemplate.templates.filter { $0.category == selectedCategory }
    }
    
    private var categoryNames: [String] {
        ["Todos"] + Array(Set(TaskTemplate.templates.map { $0.category })).sorted()
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Category filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(categoryNames, id: \.self) { categoryName in
                            CategoryFilterChip(
                                name: categoryName,
                                isSelected: selectedCategory == categoryName
                            ) {
                                withAnimation(.spring(response: 0.3)) {
                                    selectedCategory = categoryName
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                }
                .background(Color(.systemBackground))
                
                Divider()
                
                // Templates list
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredTemplates) { template in
                            TemplateCard(template: template) {
                                createTaskFromTemplate(template)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Templates")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Fechar") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func createTaskFromTemplate(_ template: TaskTemplate) {
        // Encontrar categoria correspondente
        let category = categories.first { $0.name == template.category }
        
        // Criar passos com tempo estimado
        let steps = template.steps.enumerated().map { index, stepData in
            StudyStepSD(
                description: stepData.description,
                order: index,
                estimatedMinutes: stepData.minutes
            )
        }
        
        // Criar tarefa
        let task = StudyTaskSD(
            title: template.title,
            steps: steps,
            category: category
        )
        
        modelContext.insert(task)
        
        // Haptic feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        dismiss()
    }
}

struct CategoryFilterChip: View {
    let name: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(name)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(isSelected ? .white : .primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.accentColor : Color(.secondarySystemGroupedBackground))
                )
        }
        .buttonStyle(.plain)
    }
}

struct TemplateCard: View {
    let template: TaskTemplate
    let action: () -> Void
    
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack(spacing: 16) {
                // Icon
                ZStack {
                    Circle()
                        .fill(categoryColor.opacity(0.12))
                        .frame(width: 56, height: 56)
                    
                    Image(systemName: template.icon)
                        .font(.title2)
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(categoryColor)
                }
                
                // Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(template.title)
                        .font(.headline)
                    
                    Text(template.description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    // Category badge
                    Text(template.category)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(categoryColor)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(categoryColor.opacity(0.12))
                        .clipShape(Capsule())
                    
                    // Total time
                    let totalMinutes = template.steps.reduce(0) { $0 + $1.minutes }
                    if totalMinutes > 0 {
                        HStack(spacing: 4) {
                            Image(systemName: "clock.fill")
                                .font(.caption2)
                            Text("~\(totalMinutes)min")
                                .font(.caption2)
                                .fontWeight(.medium)
                        }
                        .foregroundStyle(.secondary)
                    }
                }
            }
            
            // Steps preview (expandable)
            if isExpanded {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(Array(template.steps.enumerated()), id: \.offset) { index, stepData in
                        HStack(spacing: 12) {
                            Text("\(index + 1)")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(.secondary)
                                .frame(width: 24, height: 24)
                                .background(Circle().fill(Color(.tertiarySystemGroupedBackground)))
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(stepData.description)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                
                                if stepData.minutes > 0 {
                                    HStack(spacing: 4) {
                                        Image(systemName: "clock")
                                            .font(.caption2)
                                        Text("\(stepData.minutes) min")
                                            .font(.caption2)
                                    }
                                    .foregroundStyle(categoryColor.opacity(0.7))
                                }
                            }
                            
                            Spacer()
                        }
                    }
                }
                .padding(.top, 8)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
            
            // Actions
            HStack(spacing: 12) {
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        isExpanded.toggle()
                    }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .font(.caption)
                        Text(isExpanded ? "Ocultar" : "Ver passos")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color(.tertiarySystemGroupedBackground))
                    .clipShape(Capsule())
                }
                
                Spacer()
                
                Button(action: action) {
                    HStack(spacing: 8) {
                        Image(systemName: "plus.circle.fill")
                        Text("Usar")
                            .fontWeight(.semibold)
                    }
                    .font(.subheadline)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(categoryColor)
                    .clipShape(Capsule())
                    .shadow(color: categoryColor.opacity(0.3), radius: 8, y: 4)
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.secondarySystemGroupedBackground))
                .shadow(color: Color(.systemFill).opacity(0.3), radius: 8, y: 4)
        )
    }
    
    private var categoryColor: Color {
        switch template.category {
        case "Estudos": return Color(hex: "5B9FED") ?? .blue
        case "Trabalho": return Color(hex: "F59E0B") ?? .orange
        case "Saúde": return Color(hex: "10B981") ?? .green
        case "Pessoal": return Color(hex: "A78BFA") ?? .purple
        case "Casa": return Color(hex: "EC4899") ?? .pink
        case "Criativo": return Color(hex: "8B5CF6") ?? .purple
        default: return .blue
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
    
    return TemplatesView()
        .modelContainer(container)
}
