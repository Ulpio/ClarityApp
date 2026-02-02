//
//  FocusViewSD.swift
//  Clarity
//
//  Focus mode with SwiftData
//

import SwiftUI
import SwiftData

struct FocusViewSD: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var allTasks: [StudyTaskSD]
    @Query private var achievements: [Achievement]
    
    let task: StudyTaskSD
    @State private var settings: AppSettings?
    @State private var showingCompletion = false
    @State private var stepScale: CGFloat = 0.8
    @State private var stepOpacity: Double = 0
    @State private var showBreathe = false
    @State private var breatheCompleted = false
    @State private var showSkipConfirmation = false
    @State private var newAchievements: [AchievementType] = []
    @State private var showAchievementToast = false
    
    private var currentStepIndex: Int? {
        task.currentStepIndex
    }
    
    private var currentStep: StudyStepSD? {
        guard let index = currentStepIndex else { return nil }
        return task.steps[index]
    }
    
    var body: some View {
        Group {
            if task.isCompleted {
                CompletionViewSD(task: task)
            } else if let step = currentStep, let index = currentStepIndex {
                focusContent(step: step, index: index)
            } else {
                emptyContent
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack(spacing: 2) {
                    Text(task.title)
                        .font(.headline)
                    if let index = currentStepIndex {
                        Text("Passo \(index + 1) de \(task.steps.count)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .onAppear {
            // Carregar configurações
            settings = AppSettings.getOrCreate(context: modelContext)
            
            // Mostrar breathe na primeira vez
            if !breatheCompleted && !task.isCompleted {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    showBreathe = true
                }
            } else {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.1)) {
                    stepScale = 1.0
                    stepOpacity = 1.0
                }
            }
        }
        .alert("Pular este passo?", isPresented: $showSkipConfirmation) {
            Button("Cancelar", role: .cancel) { }
            Button("Pular", role: .destructive) {
                skipCurrentStep()
            }
        } message: {
            Text("Este passo será marcado como pulado. Tente fazer sempre que possível para aproveitar ao máximo.")
        }
        .fullScreenCover(isPresented: $showBreathe) {
            BreatheView(
                onComplete: {
                    breatheCompleted = true
                    task.breatheSkipped = false // completou normalmente
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.1)) {
                        stepScale = 1.0
                        stepOpacity = 1.0
                    }
                },
                onSkip: {
                    breatheCompleted = true
                    task.breatheSkipped = true
                    task.breatheSkippedAt = Date()
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.1)) {
                        stepScale = 1.0
                        stepOpacity = 1.0
                    }
                }
            )
            .environment(\.modelContext, modelContext)
        }
        .overlay {
            if showAchievementToast, let achievement = newAchievements.first {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        dismissAchievement()
                    }
                
                AchievementUnlockedToast(achievement: achievement, isShowing: $showAchievementToast)
                    .onAppear {
                        let generator = UINotificationFeedbackGenerator()
                        generator.notificationOccurred(.success)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            dismissAchievement()
                        }
                    }
            }
        }
    }
    
    private func focusContent(step: StudyStepSD, index: Int) -> some View {
        VStack(spacing: 0) {
            Spacer()
            
            // Step display
            VStack(spacing: 32) {
                // Icon with animated circle
                ZStack {
                    Circle()
                        .fill((task.category?.color ?? .blue).opacity(0.15))
                        .frame(width: 140, height: 140)
                    
                    Image(systemName: stepIcon(for: index))
                        .font(.system(size: 64, weight: .medium))
                        .foregroundStyle(task.category?.color ?? .blue)
                }
                .scaleEffect(stepScale)
                .opacity(stepOpacity)
                .accessibilityHidden(true)
                
                // Step description
                Text(step.stepDescription)
                    .font(.system(size: 28, weight: .medium, design: .rounded))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .scaleEffect(stepScale)
                    .opacity(stepOpacity)
                    .accessibilityAddTraits(.isHeader)
            }
            
            Spacer()
            
            // Progress and action
            VStack(spacing: 24) {
                // Progress bar
                VStack(spacing: 12) {
                    HStack {
                        Text("\(task.completedStepsCount) de \(task.steps.count)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                        
                        Text("\(Int(task.progress * 100))%")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .monospacedDigit()
                    }
                    
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(.systemGray5))
                                .frame(height: 8)
                            
                            RoundedRectangle(cornerRadius: 8)
                                .fill(task.category?.color ?? .blue)
                                .frame(width: geometry.size.width * task.progress, height: 8)
                        }
                    }
                    .frame(height: 8)
                }
                .accessibilityLabel("Progresso: \(Int(task.progress * 100))%")
                
                // Complete button
                Button {
                    completeCurrentStep()
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title3)
                        Text("Completei este passo")
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(task.category?.color ?? .blue)
                    )
                    .shadow(color: (task.category?.color ?? .blue).opacity(0.3), radius: 12, y: 6)
                }
                .accessibilityLabel("Marcar passo como completo")
                .accessibilityHint("Avança para o próximo passo")
                
                // Skip button (se permitido nas configurações)
                if settings?.allowSkipSteps == true {
                    Button {
                        showSkipConfirmation = true
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "forward.fill")
                                .font(.subheadline)
                            Text("Pular este passo")
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                        .foregroundStyle(.orange)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.orange.opacity(0.1))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                        )
                    }
                }
            }
            .padding(24)
        }
    }
    
    private var emptyContent: some View {
        VStack(spacing: 24) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 60))
                .foregroundStyle(.green)
            
            Text("Todos os passos completados!")
                .font(.title2)
                .multilineTextAlignment(.center)
            
            Button("Voltar") {
                dismiss()
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
    
    private func stepIcon(for index: Int) -> String {
        let icons = [
            "1.circle.fill", "2.circle.fill", "3.circle.fill",
            "4.circle.fill", "5.circle.fill", "6.circle.fill",
            "7.circle.fill", "8.circle.fill", "9.circle.fill"
        ]
        
        return index < icons.count ? icons[index] : "circle.fill"
    }
    
    private func completeCurrentStep() {
        guard let step = currentStep else { return }
        
        // Haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        // Animate out
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            stepScale = 1.2
            stepOpacity = 0
        }
        
        // Complete step
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            step.complete()
            
            if task.isCompleted {
                task.markAsCompleted()
                checkAchievements()
            }
            
            // Reset animation for next step
            stepScale = 0.8
            stepOpacity = 0
            
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.1)) {
                stepScale = 1.0
                stepOpacity = 1.0
            }
        }
    }
    
    private func skipCurrentStep() {
        guard let step = currentStep else { return }
        if let settings = settings {
            settings.totalStepsSkipped += 1
            try? modelContext.save()
        }
        
        // Haptic de warning (diferente do success)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
        
        // Animate out
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            stepScale = 1.2
            stepOpacity = 0
        }
        
        // Skip step
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            step.skip()
            
            if task.isCompleted {
                task.markAsCompleted()
                checkAchievements()
            }
            
            // Reset animation for next step
            stepScale = 0.8
            stepOpacity = 0
            
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.1)) {
                stepScale = 1.0
                stepOpacity = 1.0
            }
        }
    }
    
    private func checkAchievements() {
        let completedTasks = allTasks.filter { $0.isCompleted }
        let streak = calculateStreak(from: completedTasks)
        
        let manager = AchievementManager()
        let unlocked = manager.checkAndUnlockAchievements(
            achievements: achievements,
            completedTasks: completedTasks,
            streak: streak,
            context: modelContext
        )
        
        if !unlocked.isEmpty {
            newAchievements = unlocked
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                showAchievementToast = true
            }
        }
    }
    
    private func calculateStreak(from tasks: [StudyTaskSD]) -> Int {
        let calendar = Calendar.current
        let completedDates = tasks.compactMap { $0.completedAt }
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
    
    private func dismissAchievement() {
        withAnimation {
            showAchievementToast = false
            newAchievements.removeFirst()
            
            if !newAchievements.isEmpty {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    showAchievementToast = true
                }
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: StudyTaskSD.self, Category.self, configurations: config)
    
    let task = StudyTaskSD(
        title: "Matemática",
        steps: [
            StudyStepSD(description: "Abrir o caderno", order: 0),
            StudyStepSD(description: "Revisar o último tópico", order: 1),
            StudyStepSD(description: "Fazer exercícios", order: 2)
        ]
    )
    
    container.mainContext.insert(task)
    
    return NavigationStack {
        FocusViewSD(task: task)
    }
    .modelContainer(container)
}
