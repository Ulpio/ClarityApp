//
//  AchievementsView.swift
//  Clarity
//
//  Display achievements and progress
//

import SwiftUI
import SwiftData

struct AchievementsView: View {
    @Environment(\.dismiss) private var dismiss
    @Query private var achievements: [Achievement]
    
    private var unlockedAchievements: [Achievement] {
        achievements.filter { $0.isUnlocked }.sorted { ($0.unlockedAt ?? Date.distantPast) > ($1.unlockedAt ?? Date.distantPast) }
    }
    
    private var lockedAchievements: [Achievement] {
        achievements.filter { !$0.isUnlocked }
    }
    
    private var progress: Double {
        guard !achievements.isEmpty else { return 0 }
        return Double(unlockedAchievements.count) / Double(achievements.count)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    // Header with progress
                    VStack(spacing: 20) {
                        ZStack {
                            Circle()
                                .stroke(Color(.tertiarySystemFill), lineWidth: 12)
                                .frame(width: 120, height: 120)
                            
                            Circle()
                                .trim(from: 0, to: progress)
                                .stroke(
                                    Color.yellow,
                                    style: StrokeStyle(lineWidth: 12, lineCap: .round)
                                )
                                .frame(width: 120, height: 120)
                                .rotationEffect(.degrees(-90))
                            
                            VStack(spacing: 4) {
                                Text("\(unlockedAchievements.count)")
                                    .font(.system(size: 32, weight: .bold, design: .rounded))
                                Text("de \(achievements.count)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        
                        VStack(spacing: 8) {
                            Text("Conquistas")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text("\(Int(progress * 100))% completo")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.top)
                    
                    // Unlocked achievements
                    if !unlockedAchievements.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Desbloqueadas")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            ForEach(unlockedAchievements) { achievement in
                                if let type = achievement.achievementType {
                                    AchievementCard(type: type, isUnlocked: true, unlockedAt: achievement.unlockedAt)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Locked achievements
                    if !lockedAchievements.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Bloqueadas")
                                .font(.headline)
                                .foregroundStyle(.secondary)
                                .padding(.horizontal)
                            
                            ForEach(lockedAchievements) { achievement in
                                if let type = achievement.achievementType {
                                    AchievementCard(type: type, isUnlocked: false, unlockedAt: nil)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.bottom, 32)
            }
            .navigationTitle("Conquistas")
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
}

struct AchievementCard: View {
    let type: AchievementType
    let isUnlocked: Bool
    let unlockedAt: Date?
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            ZStack {
                Circle()
                    .fill(isUnlocked ? type.gradient : LinearGradient(colors: [Color(.systemGray5)], startPoint: .top, endPoint: .bottom))
                    .frame(width: 60, height: 60)
                
                Image(systemName: type.icon)
                    .font(.title2)
                    .foregroundStyle(isUnlocked ? .white : .secondary)
                
                if !isUnlocked {
                    Image(systemName: "lock.fill")
                        .font(.caption2)
                        .foregroundStyle(.white)
                        .padding(6)
                        .background(Circle().fill(Color.black.opacity(0.5)))
                        .offset(x: 20, y: 20)
                }
            }
            
            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(type.title)
                    .font(.headline)
                    .foregroundStyle(isUnlocked ? .primary : .secondary)
                
                Text(type.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                if let date = unlockedAt {
                    Text(formatDate(date))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
            
            if isUnlocked {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title3)
                    .foregroundStyle(type.color)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemGroupedBackground))
                .shadow(color: isUnlocked ? type.color.opacity(0.2) : Color(.systemFill).opacity(0.3), radius: 8, y: 4)
        )
        .opacity(isUnlocked ? 1 : 0.6)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return "Desbloqueada \(formatter.localizedString(for: date, relativeTo: Date()))"
    }
}

// Toast notification for new achievements
struct AchievementUnlockedToast: View {
    let achievement: AchievementType
    @Binding var isShowing: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(achievement.gradient)
                    .frame(width: 80, height: 80)
                
                Image(systemName: achievement.icon)
                    .font(.system(size: 36))
                    .foregroundStyle(.white)
            }
            
            VStack(spacing: 8) {
                Text("🎉 Conquista Desbloqueada!")
                    .font(.headline)
                
                Text(achievement.title)
                    .font(.title3)
                    .fontWeight(.bold)
                
                Text(achievement.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Button {
                withAnimation {
                    isShowing = false
                }
            } label: {
                Text("Continuar")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(achievement.gradient)
                    .clipShape(Capsule())
            }
        }
        .padding(32)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(.secondarySystemGroupedBackground))
                .shadow(color: Color(.systemFill).opacity(0.5), radius: 20, y: 10)
        )
        .padding(.horizontal, 40)
        .transition(.scale.combined(with: .opacity))
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Achievement.self, configurations: config)
    
    let context = container.mainContext
    let achievement1 = Achievement(type: .firstTask)
    achievement1.unlock()
    context.insert(achievement1)
    
    let achievement2 = Achievement(type: .fiveTasks)
    context.insert(achievement2)
    
    return AchievementsView()
        .modelContainer(container)
}
