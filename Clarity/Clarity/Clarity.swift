//
//  Clarity.swift
//  Clarity
//
//  Created for Swift Student Challenge 2026
//

import SwiftUI
import SwiftData

@main
struct Clarity: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            StudyTaskSD.self,
            StudyStepSD.self,
            Category.self,
            Achievement.self,
            AppSettings.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            
            let context = container.mainContext
            
            // Inicializar categorias padrão
            let categoryDescriptor = FetchDescriptor<Category>()
            let existingCategories = try? context.fetch(categoryDescriptor)
            
            if existingCategories?.isEmpty ?? true {
                for category in Category.defaultCategories {
                    context.insert(category)
                }
            } else {
                // Migração: marcar categorias padrão existentes como sistema
                for category in existingCategories ?? [] where Category.defaultCategoryNames.contains(category.name) {
                    category.isSystemCategory = true
                }
            }
            
            // Inicializar conquistas
            let achievementManager = AchievementManager()
            achievementManager.initializeAchievements(context: context)
            
            // Inicializar configurações
            _ = AppSettings.getOrCreate(context: context)
            
            try? context.save()
            
            return container
        } catch {
            // Fallback: container em memória (dados temporários) se persistência falhar
            let fallbackConfig = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
            do {
                let fallbackContainer = try ModelContainer(for: schema, configurations: [fallbackConfig])
                
                // Inicializar dados padrão no container temporário
                let context = fallbackContainer.mainContext
                for category in Category.defaultCategories {
                    context.insert(category)
                }
                let achievementManager = AchievementManager()
                achievementManager.initializeAchievements(context: context)
                _ = AppSettings.getOrCreate(context: context)
                try? context.save()
                
                return fallbackContainer
            } catch {
                fatalError("App não pode iniciar. Delete e reinstale o app.")
            }
        }
    }()
    
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    var body: some Scene {
        WindowGroup {
            if hasSeenOnboarding {
                HomeViewSD()
            } else {
                OnboardingView(onComplete: {
                    hasSeenOnboarding = true
                })
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
