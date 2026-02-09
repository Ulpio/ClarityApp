//
//  StreakCalculator.swift
//  Clarity
//
//  Cálculo de sequência de dias (streak) a partir de tarefas completadas.
//

import Foundation
import SwiftData

enum StreakCalculator {
    /// Calcula quantos dias consecutivos (incluindo hoje) o usuário completou ao menos uma tarefa.
    /// - Parameter tasks: Tarefas com `completedAt` preenchido (ex.: tarefas concluídas).
    /// - Returns: Número de dias consecutivos, começando de hoje para trás.
    static func streak(from tasks: [StudyTaskSD]) -> Int {
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
                guard let next = calendar.date(byAdding: .day, value: -1, to: currentDate) else { break }
                currentDate = next
            } else if date < currentDate {
                break
            }
        }

        return streak
    }
}
