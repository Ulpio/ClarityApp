//
//  StatsView.swift
//  Clarity
//
//  Statistics dashboard
//

import SwiftUI
import SwiftData
import Charts

struct StatsView: View {
    @Environment(\.dismiss) private var dismiss
    @Query private var settingsQuery: [AppSettings]
    let tasks: [StudyTaskSD]
    
    private var settings: AppSettings? { settingsQuery.first }
    
    private var completedTasks: [StudyTaskSD] {
        tasks.filter { $0.isCompleted }
    }
    
    private var incompleteTasks: [StudyTaskSD] {
        tasks.filter { !$0.isCompleted }
    }
    
    private var totalSteps: Int {
        tasks.reduce(0) { $0 + $1.steps.count }
    }
    
    private var completedSteps: Int {
        tasks.reduce(0) { $0 + $1.completedStepsCount }
    }
    
    private var currentStreak: Int {
        calculateStreak()
    }
    
    /// Total de passos pulados (global)
    private var stepsSkipped: Int {
        settings?.totalStepsSkipped ?? 0
    }
    
    /// Taxa de skip: passos pulados / total de passos (em %). Total = passos em todas as tarefas.
    private var skipRatePercent: Double {
        guard totalSteps > 0 else { return 0 }
        return (Double(stepsSkipped) / Double(totalSteps)) * 100
    }
    
    /// Tempo total focado (estimado): soma dos estimatedMinutes dos passos completados.
    private var totalFocusMinutes: Int {
        tasks.flatMap(\.steps).filter(\.isCompleted).reduce(0) { $0 + $1.estimatedMinutes }
    }
    
    /// Categoria com mais tarefas completadas.
    private var favoriteCategory: (Category, Int)? {
        let completed = completedTasks
        guard !completed.isEmpty else { return nil }
        let grouped = Dictionary(grouping: completed) { $0.category?.id }
        return grouped.compactMap { key, list in
            guard let cat = list.first?.category else { return nil }
            return (cat, list.count)
        }.max(by: { $0.1 < $1.1 })
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Resumo principal
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        StatsCard(
                            icon: "checkmark.circle.fill",
                            value: "\(completedTasks.count)",
                            label: "Concluídas",
                            color: .green
                        )
                        
                        StatsCard(
                            icon: "list.bullet",
                            value: "\(tasks.count)",
                            label: "Total",
                            color: .blue
                        )
                        
                        StatsCard(
                            icon: "flame.fill",
                            value: "\(currentStreak)",
                            label: "Dias seguidos",
                            color: .orange
                        )
                        
                        StatsCard(
                            icon: "chart.bar.fill",
                            value: "\(completedSteps)",
                            label: "Passos feitos",
                            color: .purple
                        )
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    // Analytics: skip, tempo focado, passos pulados, categoria favorita
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        StatsCard(
                            icon: "percent",
                            value: String(format: "%.0f%%", skipRatePercent),
                            label: "Taxa de skip",
                            color: skipRatePercent > 0 ? .orange : .green
                        )
                        
                        StatsCard(
                            icon: "clock.fill",
                            value: formatFocusTime(totalFocusMinutes),
                            label: "Tempo focado",
                            color: .blue
                        )
                        
                        StatsCard(
                            icon: "forward.circle.fill",
                            value: "\(stepsSkipped)",
                            label: "Passos pulados",
                            color: .orange
                        )
                        
                        if let (category, count) = favoriteCategory {
                            StatsCardCategory(
                                icon: category.icon,
                                value: category.name,
                                label: "Categoria favorita",
                                color: category.color,
                                count: count
                            )
                        } else {
                            StatsCard(
                                icon: "tag.fill",
                                value: "—",
                                label: "Categoria favorita",
                                color: .secondary
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    // Progress overview
                    if !tasks.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Progresso Geral")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                            
                            ProgressOverviewCard(
                                completed: completedTasks.count,
                                incomplete: incompleteTasks.count,
                                total: tasks.count
                            )
                            .padding(.horizontal)
                        }
                    }
                    
                    // Gráfico por período (7 ou 30 dias)
                    if !completedTasks.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Tarefas por dia")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                            
                            DailyChartSection(tasks: completedTasks)
                                .padding(.horizontal)
                        }
                    }
                    
                    // Categories breakdown
                    if !tasks.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Por Categoria")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                            
                            CategoriesBreakdown(tasks: tasks)
                                .padding(.horizontal)
                        }
                    }
                    
                    // Recent completions
                    if !completedTasks.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Recentes")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                            
                            ForEach(completedTasks.prefix(5)) { task in
                                RecentTaskRow(task: task)
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.bottom, 32)
            }
            .navigationTitle("Estatísticas")
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
    
    private func calculateStreak() -> Int {
        let calendar = Calendar.current
        let completedDates = completedTasks.compactMap { $0.completedAt }
            .map { calendar.startOfDay(for: $0) }
            .sorted(by: >)
        
        guard !completedDates.isEmpty else { return 0 }
        
        var streak = 0
        var currentDate = calendar.startOfDay(for: Date())
        
        for date in completedDates {
            if calendar.isDate(date, inSameDayAs: currentDate) {
                streak += 1
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate)!
            } else if date < currentDate {
                break
            }
        }
        
        return streak
    }
    
    private func formatFocusTime(_ minutes: Int) -> String {
        if minutes < 60 { return "\(minutes)m" }
        let h = minutes / 60
        let m = minutes % 60
        if m == 0 { return "\(h)h" }
        return "\(h)h \(m)m"
    }
}

// MARK: - Card para categoria favorita

struct StatsCardCategory: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    let count: Int
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title)
                .foregroundStyle(color)
            
            Text(value)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Text("\(count) tarefas")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

// MARK: - Gráfico com seletor 7 / 30 dias

struct DailyChartSection: View {
    let tasks: [StudyTaskSD]
    @State private var selectedDays: ChartDays = .seven
    
    enum ChartDays: String, CaseIterable {
        case seven = "7 dias"
        case thirty = "30 dias"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Picker("Período", selection: $selectedDays) {
                ForEach(ChartDays.allCases, id: \.self) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            .pickerStyle(.segmented)
            
            let days = selectedDays == .seven ? 7 : 30
            DailyChartView(tasks: tasks, numberOfDays: days)
                .frame(height: 200)
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
}

struct DailyChartView: View {
    let tasks: [StudyTaskSD]
    let numberOfDays: Int
    
    private var chartData: [DayData] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        return (0..<numberOfDays).reversed().map { daysAgo in
            let date = calendar.date(byAdding: .day, value: -daysAgo, to: today)!
            let count = tasks.filter { task in
                guard let completedAt = task.completedAt else { return false }
                return calendar.isDate(completedAt, inSameDayAs: date)
            }.count
            
            let dayName = calendar.shortWeekdaySymbols[calendar.component(.weekday, from: date) - 1]
            let dayNum = calendar.component(.day, from: date)
            let label = numberOfDays <= 7 ? String(dayName.prefix(3)) : "\(dayNum)"
            return DayData(day: label, count: count)
        }
    }
    
    var body: some View {
        Chart(chartData) { item in
            BarMark(
                x: .value("Dia", item.day),
                y: .value("Tarefas", item.count)
            )
            .foregroundStyle(Color.accentColor)
            .cornerRadius(8)
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
    }
}

struct StatsCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title)
                .foregroundStyle(color)
            
            Text(value)
                .font(.system(size: 32, weight: .bold, design: .rounded))
            
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

struct ProgressOverviewCard: View {
    let completed: Int
    let incomplete: Int
    let total: Int
    
    private var percentage: Double {
        guard total > 0 else { return 0 }
        return Double(completed) / Double(total)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Circular progress
            ZStack {
                Circle()
                    .stroke(Color(.tertiarySystemFill), lineWidth: 20)
                    .frame(width: 140, height: 140)
                
                Circle()
                    .trim(from: 0, to: percentage)
                    .stroke(
                        Color.green,
                        style: StrokeStyle(lineWidth: 20, lineCap: .round)
                    )
                    .frame(width: 140, height: 140)
                    .rotationEffect(.degrees(-90))
                
                VStack(spacing: 4) {
                    Text("\(Int(percentage * 100))%")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                    Text("completo")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            // Legend
            HStack(spacing: 32) {
                LegendItem(color: .green, label: "Completas", value: completed)
                LegendItem(color: .orange, label: "Em progresso", value: incomplete)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

struct LegendItem: View {
    let color: Color
    let label: String
    let value: Int
    
    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("\(value)")
                    .font(.headline)
                Text(label)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

struct WeeklyChartView: View {
    let tasks: [StudyTaskSD]
    
    private var weeklyData: [DayData] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        return (0..<7).reversed().map { daysAgo in
            let date = calendar.date(byAdding: .day, value: -daysAgo, to: today)!
            let count = tasks.filter { task in
                guard let completedAt = task.completedAt else { return false }
                return calendar.isDate(completedAt, inSameDayAs: date)
            }.count
            
            let dayName = calendar.shortWeekdaySymbols[calendar.component(.weekday, from: date) - 1]
            return DayData(day: String(dayName.prefix(3)), count: count)
        }
    }
    
    var body: some View {
        Chart(weeklyData) { item in
            BarMark(
                x: .value("Dia", item.day),
                y: .value("Tarefas", item.count)
            )
            .foregroundStyle(Color.accentColor)
            .cornerRadius(8)
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
    }
}

struct DayData: Identifiable {
    let id = UUID()
    let day: String
    let count: Int
}

struct CategoriesBreakdown: View {
    let tasks: [StudyTaskSD]
    
    private var categoryStats: [(Category, Int)] {
        let grouped = Dictionary(grouping: tasks) { $0.category?.id }
        return grouped.compactMap { key, tasks in
            guard let category = tasks.first?.category else { return nil }
            return (category, tasks.count)
        }
        .sorted { $0.1 > $1.1 }
    }
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(categoryStats, id: \.0.id) { category, count in
                HStack {
                    HStack(spacing: 12) {
                        Image(systemName: category.icon)
                            .foregroundStyle(category.color)
                            .frame(width: 24)
                        
                        Text(category.name)
                            .font(.body)
                    }
                    
                    Spacer()
                    
                    Text("\(count)")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }
}

struct RecentTaskRow: View {
    let task: StudyTaskSD
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.body)
                
                if let completedAt = task.completedAt {
                    Text(relativeDate(completedAt))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
            
            if let category = task.category {
                Image(systemName: category.icon)
                    .foregroundStyle(category.color)
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private func relativeDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: StudyTaskSD.self, StudyStepSD.self, Category.self, AppSettings.self, configurations: config)
    
    let context = container.mainContext
    let category = Category.defaultCategories[0]
    context.insert(category)
    _ = AppSettings.getOrCreate(context: context)
    
    let task1 = StudyTaskSD(title: "Matemática", category: category)
    task1.steps = [StudyStepSD(description: "Passo 1", isCompleted: true, order: 0)]
    task1.markAsCompleted()
    context.insert(task1)
    
    return StatsView(tasks: [task1])
        .modelContainer(container)
}
