//
//  AppSettings.swift
//  Clarity
//
//  App-wide settings and preferences
//

import Foundation
import SwiftData

@Model
final class AppSettings {
    var id: UUID
    var minimumStepDuration: Int // seconds
    var requireConfirmation: Bool
    var pomodoroEnabled: Bool
    var pomodoroDuration: Int // minutes
    var showHonestyReminders: Bool
    var pauseBetweenSteps: Int // seconds
    var totalBreathesSkipped: Int // contador de vezes que pulou breathe
    var allowSkipBreathe: Bool // permite pular exercício de respiração
    var totalStepsSkipped: Int // contador de passos pulados
    var allowSkipSteps: Bool // permite pular passos
    
    init() {
        self.id = UUID()
        self.minimumStepDuration = 15 // 15 segundos mínimo
        self.requireConfirmation = false
        self.pomodoroEnabled = false
        self.pomodoroDuration = 25
        self.showHonestyReminders = true
        self.pauseBetweenSteps = 5
        self.totalBreathesSkipped = 0
        self.allowSkipBreathe = true // permite por padrão
        self.totalStepsSkipped = 0
        self.allowSkipSteps = true // permite por padrão
    }
    
    static func getOrCreate(context: ModelContext) -> AppSettings {
        let descriptor = FetchDescriptor<AppSettings>()
        if let existing = try? context.fetch(descriptor).first {
            return existing
        }
        
        let settings = AppSettings()
        context.insert(settings)
        try? context.save()
        return settings
    }
}

enum FocusMode {
    case normal
    case pomodoro(duration: Int)
    
    var description: String {
        switch self {
        case .normal: return "Normal"
        case .pomodoro(let duration): return "Pomodoro \(duration)min"
        }
    }
}
