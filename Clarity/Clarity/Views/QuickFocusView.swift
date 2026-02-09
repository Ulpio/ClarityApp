//
//  QuickFocusView.swift
//  Clarity
//
//  Atividade rápida genérica: timer Pomodoro sem tarefa específica.
//

import SwiftUI
import SwiftData

struct QuickFocusView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var settingsQuery: [AppSettings]

    private var pomodoroMinutes: Int {
        settingsQuery.first?.pomodoroDuration ?? 25
    }

    @State private var totalSeconds: Int = 0
    @State private var remainingSeconds: Int = 0
    @State private var isRunning = false
    @State private var isCompleted = false
    @State private var timer: Timer?

    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                if isCompleted {
                    completionContent
                } else {
                    timerContent
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Atividade rápida")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    if !isCompleted {
                        Button("Cancelar") { stopAndDismiss() }
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    if isCompleted {
                        Button("Concluído") { dismiss() }
                            .fontWeight(.semibold)
                    }
                }
            }
            .onDisappear { timer?.invalidate() }
        }
        .onAppear {
            totalSeconds = pomodoroMinutes * 60
            remainingSeconds = totalSeconds
        }
    }

    private var timerContent: some View {
        VStack(spacing: 40) {
            Spacer()
            ZStack {
                Circle()
                    .stroke(Color(.tertiarySystemFill), lineWidth: 12)
                    .frame(width: 200, height: 200)
                Circle()
                    .trim(from: 0, to: totalSeconds > 0 ? Double(remainingSeconds) / Double(totalSeconds) : 0)
                    .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .frame(width: 200, height: 200)
                    .rotationEffect(.degrees(-90))
                VStack(spacing: 4) {
                    Text(formatTime(remainingSeconds))
                        .font(.system(size: 44, weight: .bold, design: .rounded))
                        .monospacedDigit()
                    Text(isRunning ? "em andamento" : "pronto para começar")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            Text("\(pomodoroMinutes) min de foco")
                .font(.headline)
                .foregroundStyle(.secondary)
            Spacer()
            Button {
                if isRunning {
                    stopTimer()
                } else {
                    startTimer()
                }
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: isRunning ? "pause.circle.fill" : "play.circle.fill")
                        .font(.title2)
                    Text(isRunning ? "Pausar" : "Iniciar")
                        .fontWeight(.semibold)
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(Color.accentColor)
                .clipShape(Capsule())
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 48)
        }
    }

    private var completionContent: some View {
        VStack(spacing: 24) {
            Spacer()
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(.green)
            Text("Tempo concluído!")
                .font(.title)
                .fontWeight(.bold)
            Text("Você completou \(pomodoroMinutes) minutos de foco.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .onAppear {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }
    }

    private func startTimer() {
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if remainingSeconds > 0 {
                remainingSeconds -= 1
            } else {
                stopTimer()
                isCompleted = true
            }
        }
        timer?.tolerance = 0.2
        RunLoop.main.add(timer!, forMode: .common)
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        isRunning = false
    }

    private func stopAndDismiss() {
        stopTimer()
        dismiss()
    }

    private func formatTime(_ seconds: Int) -> String {
        let m = seconds / 60
        let s = seconds % 60
        return String(format: "%d:%02d", m, s)
    }
}
