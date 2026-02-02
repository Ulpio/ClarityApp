//
//  Achievement.swift
//  Clarity
//
//  Achievement system for motivation
//

import Foundation
import SwiftUI
import SwiftData

@Model
final class Achievement {
    var id: UUID
    var type: String // AchievementType como String
    var unlockedAt: Date?
    var isUnlocked: Bool
    
    init(type: AchievementType) {
        self.id = UUID()
        self.type = type.rawValue
        self.unlockedAt = nil
        self.isUnlocked = false
    }
    
    var achievementType: AchievementType? {
        AchievementType(rawValue: type)
    }
    
    func unlock() {
        isUnlocked = true
        unlockedAt = Date()
    }
}

enum AchievementType: String, CaseIterable {
    case firstTask = "first_task"
    case fiveTasks = "five_tasks"
    case tenTasks = "ten_tasks"
    case twentyFiveTasks = "twenty_five_tasks"
    case fiftyTasks = "fifty_tasks"
    case streak3 = "streak_3"
    case streak7 = "streak_7"
    case streak30 = "streak_30"
    case allCategories = "all_categories"
    case perfectDay = "perfect_day"
    // Novas: sem skip
    case noSkip5 = "no_skip_5"
    case noSkip10 = "no_skip_10"
    case zenMaster = "zen_master"
    // Novas: horário
    case earlyBird = "early_bird"
    case nightOwl = "night_owl"
    // Novas: categorias
    case categoryStudy = "category_study"
    case categoryWork = "category_work"
    case categoryCreative = "category_creative"
    
    var title: String {
        switch self {
        case .firstTask: return "Primeiro Passo"
        case .fiveTasks: return "Ganhando Ritmo"
        case .tenTasks: return "Dedicado"
        case .twentyFiveTasks: return "Comprometido"
        case .fiftyTasks: return "Mestre da Clareza"
        case .streak3: return "3 Dias Seguidos"
        case .streak7: return "Uma Semana!"
        case .streak30: return "Mês Completo!"
        case .allCategories: return "Explorador"
        case .perfectDay: return "Dia Produtivo"
        case .noSkip5: return "Sem Atalhos"
        case .noSkip10: return "Determinação"
        case .zenMaster: return "Zen Master"
        case .earlyBird: return "Madrugador"
        case .nightOwl: return "Coruja"
        case .categoryStudy: return "Estudioso"
        case .categoryWork: return "Profissional"
        case .categoryCreative: return "Criativo"
        }
    }
    
    var description: String {
        switch self {
        case .firstTask: return "Complete sua primeira tarefa"
        case .fiveTasks: return "Complete 5 tarefas"
        case .tenTasks: return "Complete 10 tarefas"
        case .twentyFiveTasks: return "Complete 25 tarefas"
        case .fiftyTasks: return "Complete 50 tarefas"
        case .streak3: return "Use o app 3 dias seguidos"
        case .streak7: return "Use o app 7 dias seguidos"
        case .streak30: return "Use o app 30 dias seguidos"
        case .allCategories: return "Use todas as categorias"
        case .perfectDay: return "Complete 5 tarefas em um dia"
        case .noSkip5: return "Complete 5 tarefas sem pular nenhum passo"
        case .noSkip10: return "Complete 10 tarefas sem pular nenhum passo"
        case .zenMaster: return "Complete 20 exercícios de respiração sem pular"
        case .earlyBird: return "Complete uma tarefa antes das 8h"
        case .nightOwl: return "Complete uma tarefa após as 22h"
        case .categoryStudy: return "Complete 10 tarefas de Estudos"
        case .categoryWork: return "Complete 10 tarefas de Trabalho"
        case .categoryCreative: return "Complete 10 tarefas de Criativo"
        }
    }
    
    var icon: String {
        switch self {
        case .firstTask: return "star.fill"
        case .fiveTasks: return "star.circle.fill"
        case .tenTasks: return "sparkles"
        case .twentyFiveTasks: return "crown.fill"
        case .fiftyTasks: return "trophy.fill"
        case .streak3: return "flame.fill"
        case .streak7: return "flame.fill"
        case .streak30: return "flame.fill"
        case .allCategories: return "square.grid.2x2.fill"
        case .perfectDay: return "sun.max.fill"
        case .noSkip5: return "checkmark.seal.fill"
        case .noSkip10: return "checkmark.shield.fill"
        case .zenMaster: return "leaf.fill"
        case .earlyBird: return "sunrise.fill"
        case .nightOwl: return "moon.stars.fill"
        case .categoryStudy: return "book.fill"
        case .categoryWork: return "briefcase.fill"
        case .categoryCreative: return "paintbrush.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .firstTask: return .yellow
        case .fiveTasks: return .orange
        case .tenTasks: return .blue
        case .twentyFiveTasks: return .purple
        case .fiftyTasks: return .pink
        case .streak3: return .orange
        case .streak7: return .red
        case .streak30: return .red
        case .allCategories: return .green
        case .perfectDay: return .yellow
        case .noSkip5: return .green
        case .noSkip10: return .mint
        case .zenMaster: return .teal
        case .earlyBird: return .orange
        case .nightOwl: return .indigo
        case .categoryStudy: return .blue
        case .categoryWork: return .orange
        case .categoryCreative: return .purple
        }
    }
    
    var gradient: LinearGradient {
        LinearGradient(
            colors: [color, color.opacity(0.7)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    // Verificar se foi desbloqueada
    func checkUnlock(completedTasks: [StudyTaskSD], streak: Int) -> Bool {
        switch self {
        case .firstTask:
            return completedTasks.count >= 1
        case .fiveTasks:
            return completedTasks.count >= 5
        case .tenTasks:
            return completedTasks.count >= 10
        case .twentyFiveTasks:
            return completedTasks.count >= 25
        case .fiftyTasks:
            return completedTasks.count >= 50
        case .streak3:
            return streak >= 3
        case .streak7:
            return streak >= 7
        case .streak30:
            return streak >= 30
        case .allCategories:
            let uniqueCategories = Set(completedTasks.compactMap { $0.category?.id })
            return uniqueCategories.count >= 6
        case .perfectDay:
            let today = Calendar.current.startOfDay(for: Date())
            let todayTasks = completedTasks.filter { task in
                guard let completedAt = task.completedAt else { return false }
                return Calendar.current.isDate(completedAt, inSameDayAs: today)
            }
            return todayTasks.count >= 5
        case .noSkip5:
            let noSkipCount = completedTasks.filter { task in
                task.steps.allSatisfy { !$0.wasSkipped }
            }.count
            return noSkipCount >= 5
        case .noSkip10:
            let noSkipCount = completedTasks.filter { task in
                task.steps.allSatisfy { !$0.wasSkipped }
            }.count
            return noSkipCount >= 10
        case .zenMaster:
            let breathesNoSkip = completedTasks.filter { !$0.breatheSkipped }.count
            return breathesNoSkip >= 20
        case .earlyBird:
            return completedTasks.contains { task in
                guard let d = task.completedAt else { return false }
                return Calendar.current.component(.hour, from: d) < 8
            }
        case .nightOwl:
            return completedTasks.contains { task in
                guard let d = task.completedAt else { return false }
                return Calendar.current.component(.hour, from: d) >= 22
            }
        case .categoryStudy:
            return completedTasks.filter { $0.category?.name == "Estudos" }.count >= 10
        case .categoryWork:
            return completedTasks.filter { $0.category?.name == "Trabalho" }.count >= 10
        case .categoryCreative:
            return completedTasks.filter { $0.category?.name == "Criativo" }.count >= 10
        }
    }
}

// Manager para verificar conquistas
@Observable
class AchievementManager {
    func checkAndUnlockAchievements(
        achievements: [Achievement],
        completedTasks: [StudyTaskSD],
        streak: Int,
        context: ModelContext
    ) -> [AchievementType] {
        var newlyUnlocked: [AchievementType] = []
        
        for achievement in achievements {
            guard !achievement.isUnlocked,
                  let type = achievement.achievementType else { continue }
            
            if type.checkUnlock(completedTasks: completedTasks, streak: streak) {
                achievement.unlock()
                newlyUnlocked.append(type)
            }
        }
        
        if !newlyUnlocked.isEmpty {
            try? context.save()
        }
        
        return newlyUnlocked
    }
    
    func initializeAchievements(context: ModelContext) {
        let descriptor = FetchDescriptor<Achievement>()
        let existing = (try? context.fetch(descriptor)) ?? []
        let existingTypes = Set(existing.compactMap { AchievementType(rawValue: $0.type) })
        
        for type in AchievementType.allCases where !existingTypes.contains(type) {
            context.insert(Achievement(type: type))
        }
        try? context.save()
    }
}
