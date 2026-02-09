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
        
        // Store em disco em Application Support (persiste ao encerrar o app)
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let clarityDir = appSupport.appendingPathComponent("Clarity", isDirectory: true)
        try? FileManager.default.createDirectory(at: clarityDir, withIntermediateDirectories: true)
        let storeURL = clarityDir.appendingPathComponent("default.store")
        let modelConfiguration = ModelConfiguration(schema: schema, url: storeURL)
        
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
            // Sem fallback em memória: evita perder dados ao reabrir o app
            fatalError("Não foi possível carregar os dados do app: \(error.localizedDescription). Tente reinstalar o app.")
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
        // Live Activity: não encerrar ao minimizar; só é encerrada ao sair da tela de foco (FocusViewEnhanced.onDisappear) ou ao concluir/parar a tarefa.
    }
}
