//
//  FocusViewEnhanced.swift
//  Clarity
//
//  Enhanced focus mode with anti-cheat mechanisms
//

import SwiftUI
import SwiftData
import Combine
import ActivityKit

struct FocusViewEnhanced: View {
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
    @State private var newAchievements: [AchievementType] = []
    @State private var showAchievementToast = false
    
    // Timer e validação
    @State private var stepStartTime: Date?
    @State private var elapsedSeconds: Int = 0
    @State private var canComplete: Bool = false
    @State private var showConfirmation = false
    @State private var showSkipConfirmation = false
    @State private var isPausing = false
    
    // Pomodoro
    @State private var pomodoroMode: Bool = false
    @State private var pomodoroTimeRemaining: Int = 0
    @State private var pomodoroRunning: Bool = false
    
    // Mensagens motivacionais
    @State private var currentMessageIndex: Int = 0
    @State private var messageOpacity: Double = 1.0
    
    // Live Activity
    @State private var liveActivityManager: LiveActivityManager?
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    private var currentStepIndex: Int? {
        task.currentStepIndex
    }
    
    private var currentStep: StudyStepSD? {
        guard let index = currentStepIndex else { return nil }
        return task.steps[index]
    }
    
    private var minimumDuration: Int {
        // Usar tempo do passo se definido, senão usar configuração global
        if let step = currentStep, step.estimatedMinutes > 0 {
            return step.minimumRequiredSeconds
        }
        return settings?.minimumStepDuration ?? 15
    }
    
    private var totalEstimatedDuration: Int? {
        guard let step = currentStep, step.estimatedMinutes > 0 else { return nil }
        return step.totalEstimatedSeconds
    }
    
    private var honestyMessages: [String] {
        [
            "Seja honesto consigo mesmo.",
            "O valor está em fazer, não em marcar.",
            "Pequenos passos verdadeiros somam.",
            "Sua jornada, seu ritmo, sua verdade.",
            "Faça com intenção, não com pressa."
        ]
    }
    
    var body: some View {
        Group {
            if task.isCompleted {
                CompletionViewSD(task: task)
            } else if isPausing {
                pauseScreen
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
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Toggle("Modo Pomodoro", isOn: $pomodoroMode)
                        .onChange(of: pomodoroMode) { _, new in
                            if new {
                                startPomodoro()
                            } else {
                                stopPomodoro()
                            }
                        }
                } label: {
                    Image(systemName: pomodoroMode ? "timer.circle.fill" : "timer.circle")
                        .symbolRenderingMode(.hierarchical)
                }
            }
        }
        .onAppear {
            loadSettings()
            
            // Initialize Live Activity manager
            if #available(iOS 16.2, *) {
                liveActivityManager = LiveActivityManager.shared
            }
            
            if !breatheCompleted && !task.isCompleted {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    showBreathe = true
                }
            } else {
                startStep()
            }
        }
        .onDisappear {
            // End Live Activity when leaving view
            if #available(iOS 16.2, *) {
                liveActivityManager?.endActivity()
            }
        }
        .onReceive(timer) { _ in
            handleTimer()
        }
        .fullScreenCover(isPresented: $showBreathe) {
            BreatheView(
                onComplete: {
                    breatheCompleted = true
                    task.breatheSkipped = false // completou normalmente
                    startStep()
                },
                onSkip: {
                    breatheCompleted = true
                    task.breatheSkipped = true
                    task.breatheSkippedAt = Date()
                    startStep()
                }
            )
            .environment(\.modelContext, modelContext)
        }
        .alert("Você completou este passo?", isPresented: $showConfirmation) {
            Button("Ainda não", role: .cancel) { }
            Button("Sim, completei!") {
                confirmComplete()
            }
        } message: {
            Text("Seja honesto consigo mesmo. O valor está em realmente fazer.")
        }
        .alert("Pular este passo?", isPresented: $showSkipConfirmation) {
            Button("Cancelar", role: .cancel) { }
            Button("Pular", role: .destructive) {
                skipCurrentStep()
            }
        } message: {
            Text("Este passo será marcado como pulado. Tente fazer sempre que possível para aproveitar ao máximo.")
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
            // Honesty message (se habilitado) com rotação de 15s
            if settings?.showHonestyReminders == true {
                Text(honestyMessages[currentMessageIndex])
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .italic()
                    .padding(.top, 8)
                    .opacity(messageOpacity)
                    .animation(.easeInOut(duration: 1.0), value: messageOpacity)
                    .transition(.opacity)
                    .id("message-\(currentMessageIndex)")
            }
            
            Spacer()
            
                // Pomodoro timer (if active)
            if pomodoroMode && pomodoroRunning {
                VStack(spacing: 12) {
                    HStack(spacing: 8) {
                        Image(systemName: "timer")
                            .foregroundStyle(.orange)
                        Text(formatPomodoroTime(pomodoroTimeRemaining))
                            .font(.title3)
                            .fontWeight(.medium)
                            .monospacedDigit()
                            .foregroundStyle(.orange)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(
                        Capsule()
                            .fill(Color(.tertiarySystemGroupedBackground))
                    )
                    
                    ProgressView(value: Double(pomodoroTimeRemaining), total: Double((settings?.pomodoroDuration ?? 25) * 60))
                        .tint(.orange)
                        .frame(width: 200)
                }
                .padding(.bottom, 24)
            }
            
            // Step display with time info
            VStack(spacing: 32) {
                ZStack {
                    Circle()
                        .fill((task.category?.color ?? Color.accentColor).opacity(0.15))
                        .frame(width: 140, height: 140)
                    
                    Image(systemName: stepIcon(for: index))
                        .font(.system(size: 64, weight: .medium))
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(task.category?.color ?? Color.accentColor)
                }
                .scaleEffect(stepScale)
                .opacity(stepOpacity)
                .accessibilityHidden(true)
                
                VStack(spacing: 12) {
                    Text(step.stepDescription)
                        .font(.system(size: 28, weight: .medium, design: .rounded))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                        .scaleEffect(stepScale)
                        .opacity(stepOpacity)
                        .accessibilityAddTraits(.isHeader)
                    
                    // Show estimated time if set
                    if step.estimatedMinutes > 0 {
                        HStack(spacing: 8) {
                            Image(systemName: "clock.fill")
                                .font(.caption)
                            Text("Tempo estimado: \(step.estimatedTimeText)")
                                .font(.subheadline)
                            Text("(mín: \(formatTime(minimumDuration)))")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .foregroundStyle(task.category?.color ?? Color.accentColor)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(Color(.tertiarySystemGroupedBackground))
                        )
                        .opacity(stepOpacity)
                    }
                }
            }
            
            Spacer()
            
            // Progress and action
            VStack(spacing: 24) {
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
                                .fill(Color(.tertiarySystemFill))
                                .frame(height: 8)
                            
                            RoundedRectangle(cornerRadius: 8)
                                .fill(task.category?.color ?? Color.accentColor)
                                .frame(width: geometry.size.width * task.progress, height: 8)
                        }
                    }
                    .frame(height: 8)
                }
                
                // Complete button with timer and progress
                VStack(spacing: 12) {
                    // Time progress bar (se tempo estimado definido)
                    if let total = totalEstimatedDuration {
                        VStack(spacing: 8) {
                            HStack {
                                Text(formatTime(elapsedSeconds))
                                    .font(.caption)
                                    .monospacedDigit()
                                    .foregroundStyle(.secondary)
                                
                                Spacer()
                                
                                Text(formatTime(total))
                                    .font(.caption)
                                    .monospacedDigit()
                                    .foregroundStyle(.secondary)
                            }
                            
                            GeometryReader { geometry in
                                ZStack(alignment: .leading) {
                                    // Background
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color(.tertiarySystemFill))
                                        .frame(height: 6)
                                    
                                    // Progress (até 100%)
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.green)
                                        .frame(
                                            width: geometry.size.width * min(Double(elapsedSeconds) / Double(total), 1.0),
                                            height: 6
                                        )
                                    
                                    // Minimum required marker (60%)
                                    Rectangle()
                                        .fill(canComplete ? Color.green : Color.orange)
                                        .frame(width: 3, height: 12)
                                        .offset(x: geometry.size.width * 0.6)
                                }
                            }
                            .frame(height: 12)
                        }
                        .padding(.bottom, 8)
                    }
                    
                    // Complete button
                    Button {
                        handleCompleteButton()
                    } label: {
                        VStack(spacing: 6) {
                            HStack(spacing: 12) {
                                if canComplete {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.title3)
                                } else {
                                    Image(systemName: "clock.fill")
                                        .font(.title3)
                                }
                                
                                Text(canComplete ? "Completei este passo" : "Aguarde... \(formatTime(minimumDuration - elapsedSeconds))")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                            }
                            
                            if !canComplete && totalEstimatedDuration != nil {
                                Text("\(Int((Double(elapsedSeconds) / Double(minimumDuration)) * 100))% do tempo mínimo")
                                    .font(.caption2)
                                    .opacity(0.8)
                            }
                        }
                        .foregroundStyle(canComplete ? .white : .secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(canComplete ? (task.category?.color ?? Color.accentColor) : Color(.tertiarySystemFill))
                        )
                        .shadow(
                            color: canComplete ? (task.category?.color ?? Color.accentColor).opacity(0.3) : Color.clear,
                            radius: canComplete ? 12 : 0,
                            y: canComplete ? 6 : 0
                        )
                    }
                    .disabled(!canComplete)
                    .animation(.easeInOut(duration: 0.3), value: canComplete)
                    
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
                                    .fill(Color(.tertiarySystemGroupedBackground))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.orange.opacity(0.2), lineWidth: 1)
                            )
                        }
                    }
                }
            }
            .padding(24)
        }
    }
    
    private var pauseScreen: some View {
        VStack(spacing: 32) {
            Spacer()
            
            ZStack {
                ForEach(0..<3) { index in
                    Circle()
                        .stroke(Color.accentColor.opacity(0.3), lineWidth: 2)
                        .frame(width: 100 + CGFloat(index * 30), height: 100 + CGFloat(index * 30))
                        .scaleEffect(stepScale)
                }
                
                Image(systemName: "pause.circle.fill")
                    .font(.system(size: 60))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(.tint)
            }
            
            VStack(spacing: 12) {
                Text("Pausa para respirar")
                    .font(.title2)
                    .fontWeight(.medium)
                
                Text("Prepare-se para o próximo passo")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(settings?.pauseBetweenSteps ?? 5)) {
                withAnimation {
                    isPausing = false
                    startStep()
                }
            }
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
    
    private func loadSettings() {
        settings = AppSettings.getOrCreate(context: modelContext)
    }
    
    private func startStep() {
        stepStartTime = Date()
        elapsedSeconds = 0
        canComplete = false
        
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.1)) {
            stepScale = 1.0
            stepOpacity = 1.0
        }
        
        // Start or update Live Activity
        if #available(iOS 16.2, *), let index = currentStepIndex {
            if liveActivityManager?.currentActivity == nil {
                // Start new Live Activity
                liveActivityManager?.startActivity(
                    for: task,
                    currentStepIndex: index,
                    elapsedSeconds: 0
                )
            } else {
                // Update existing Live Activity
                liveActivityManager?.updateActivity(
                    for: task,
                    currentStepIndex: index,
                    elapsedSeconds: 0,
                    canComplete: false
                )
            }
        }
    }
    
    private func handleTimer() {
        // Update step timer
        if let startTime = stepStartTime {
            elapsedSeconds = Int(Date().timeIntervalSince(startTime))
            if elapsedSeconds >= minimumDuration && !canComplete {
                withAnimation {
                    canComplete = true
                }
                
                // Haptic quando pode completar
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
            }
            
            // Update Live Activity every second
            if #available(iOS 16.2, *), let index = currentStepIndex {
                liveActivityManager?.updateActivity(
                    for: task,
                    currentStepIndex: index,
                    elapsedSeconds: elapsedSeconds,
                    canComplete: canComplete
                )
            }
            
            // Rotacionar mensagem motivacional a cada 15 segundos
            if settings?.showHonestyReminders == true && elapsedSeconds > 0 && elapsedSeconds % 15 == 0 {
                rotateMessage()
            }
        }
        
        // Update pomodoro
        if pomodoroRunning && pomodoroTimeRemaining > 0 {
            pomodoroTimeRemaining -= 1
            
            if pomodoroTimeRemaining == 0 {
                pomodoroCompleted()
            }
        }
    }
    
    private func rotateMessage() {
        // Fade out
        withAnimation(.easeOut(duration: 0.5)) {
            messageOpacity = 0.0
        }
        
        // Trocar mensagem e fade in
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            currentMessageIndex = (currentMessageIndex + 1) % honestyMessages.count
            withAnimation(.easeIn(duration: 0.5)) {
                messageOpacity = 1.0
            }
        }
    }
    
    private func handleCompleteButton() {
        if settings?.requireConfirmation == true {
            showConfirmation = true
        } else {
            completeCurrentStep()
        }
    }
    
    private func confirmComplete() {
        completeCurrentStep()
    }
    
    private func completeCurrentStep() {
        guard let step = currentStep else { return }
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            stepScale = 1.2
            stepOpacity = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            step.complete()
            
            if task.isCompleted {
                task.markAsCompleted()
                checkAchievements()
                
                // End Live Activity with completion
                if #available(iOS 16.2, *) {
                    liveActivityManager?.endActivityWithCompletion(for: task)
                }
            } else {
                // Pausa entre passos
                if (settings?.pauseBetweenSteps ?? 0) > 0 {
                    isPausing = true
                } else {
                    startStep()
                }
            }
            
            stepScale = 0.8
            stepOpacity = 0
        }
    }
    
    private func skipCurrentStep() {
        guard let step = currentStep else { return }
        
        // Incrementar contador global
        if let settings = settings {
            settings.totalStepsSkipped += 1
            try? modelContext.save()
        }
        
        // Haptic de warning (diferente do success)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            stepScale = 1.2
            stepOpacity = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            // Marcar como pulado
            step.skip()
            
            if task.isCompleted {
                task.markAsCompleted()
                checkAchievements()
                
                // End Live Activity with completion
                if #available(iOS 16.2, *) {
                    liveActivityManager?.endActivityWithCompletion(for: task)
                }
            } else {
                // Pausa entre passos
                if (settings?.pauseBetweenSteps ?? 0) > 0 {
                    isPausing = true
                } else {
                    startStep()
                }
            }
            
            stepScale = 0.8
            stepOpacity = 0
        }
    }
    
    private func startPomodoro() {
        pomodoroTimeRemaining = (settings?.pomodoroDuration ?? 25) * 60
        pomodoroRunning = true
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    private func stopPomodoro() {
        pomodoroRunning = false
        pomodoroTimeRemaining = 0
    }
    
    private func pomodoroCompleted() {
        pomodoroRunning = false
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        // Pausa longa
        isPausing = true
    }
    
    private func formatPomodoroTime(_ seconds: Int) -> String {
        let mins = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", mins, secs)
    }
    
    private func formatTime(_ seconds: Int) -> String {
        let mins = seconds / 60
        let secs = seconds % 60
        if mins > 0 {
            return String(format: "%d:%02d", mins, secs)
        }
        return "\(secs)s"
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
    let container = try! ModelContainer(for: StudyTaskSD.self, Category.self, AppSettings.self, configurations: config)
    
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
        FocusViewEnhanced(task: task)
    }
    .modelContainer(container)
}
