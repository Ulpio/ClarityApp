//
//  OnboardingView.swift
//  Clarity
//
//  Onboarding de primeira execução — 4 telas
//

import SwiftUI

struct OnboardingView: View {
    var onComplete: () -> Void
    
    @State private var currentPage = 0
    private let totalPages = 4
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    welcomePage
                        .tag(0)
                    howItWorksPage
                        .tag(1)
                    antiCheatPage
                        .tag(2)
                    dynamicIslandPage
                        .tag(3)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.3), value: currentPage)
                .accessibilityLabel("Tutorial do Clarity, página \(currentPage + 1) de \(totalPages)")
                
                VStack(spacing: 24) {
                    pageIndicator
                        .accessibilityHidden(true)
                    primaryButton
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 48)
            }
        }
    }
    
    // MARK: - Páginas
    
    private var welcomePage: some View {
        OnboardingPage(
            icon: "target",
            title: "Bem-vindo ao Clarity",
            subtitle: "Transforme grandes tarefas em passos claros e alcançáveis.",
            iconColor: .accentColor
        )
    }
    
    private var howItWorksPage: some View {
        OnboardingPage(
            icon: "list.bullet.clipboard.fill",
            title: "Como Funciona",
            subtitle: "Divida sua tarefa em passos.\nRespire e prepare a mente.\nFoque um passo por vez.",
            iconColor: .accentColor,
            steps: [
                ("Divida sua tarefa em passos", "list.bullet"),
                ("Respire e prepare a mente", "wind"),
                ("Foque um passo por vez", "checkmark.circle")
            ]
        )
    }
    
    private var antiCheatPage: some View {
        OnboardingPage(
            icon: "clock.fill",
            title: "Sistema Anti-Burla",
            subtitle: "Cada passo tem tempo estimado. Só pode avançar após 60% do tempo.\n\nSem pressa. Faça de verdade.",
            iconColor: .orange
        )
    }
    
    private var dynamicIslandPage: some View {
        OnboardingPage(
            icon: "capsule.portrait.fill",
            title: "Acompanhe Seu Progresso",
            subtitle: "Veja seu progresso em tempo real na Dynamic Island!",
            iconColor: .accentColor
        )
    }
    
    // MARK: - Componentes
    
    private var pageIndicator: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalPages, id: \.self) { index in
                Capsule()
                    .fill(index == currentPage ? Color.accentColor : Color(.tertiaryLabel))
                    .frame(width: index == currentPage ? 20 : 8, height: 8)
                    .animation(.easeInOut(duration: 0.2), value: currentPage)
            }
        }
    }
    
    private var primaryButton: some View {
        Button {
            if currentPage < totalPages - 1 {
                withAnimation {
                    currentPage += 1
                }
            } else {
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
                onComplete()
            }
        } label: {
            HStack(spacing: 8) {
                Text(currentPage < totalPages - 1 ? "Continuar" : "Começar!")
                    .font(.headline)
                if currentPage < totalPages - 1 {
                    Image(systemName: "arrow.right")
                        .font(.headline.weight(.semibold))
                } else {
                    Image(systemName: "sparkles")
                        .font(.headline.weight(.semibold))
                }
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.accentColor)
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(currentPage < totalPages - 1 ? "Próxima tela" : "Começar a usar o Clarity")
        .accessibilityHint(currentPage < totalPages - 1 ? "Mostra a próxima dica" : "Fecha o tutorial e abre o app")
    }
}

// MARK: - Página reutilizável

struct OnboardingPage: View {
    let icon: String
    let title: String
    let subtitle: String
    var iconColor: Color = .accentColor
    var steps: [(String, String)]?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                Spacer(minLength: 40)
                
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.15))
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: icon)
                        .font(.system(size: 52, weight: .medium))
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(iconColor)
                }
                
                VStack(spacing: 16) {
                    Text(title)
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    if let steps = steps {
                        VStack(alignment: .leading, spacing: 14) {
                            ForEach(Array(steps.enumerated()), id: \.offset) { _, step in
                                HStack(alignment: .top, spacing: 12) {
                                    Image(systemName: step.1)
                                        .font(.body.weight(.medium))
                                        .foregroundStyle(iconColor)
                                        .frame(width: 28, alignment: .center)
                                    Text(step.0)
                                        .font(.body)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .padding(.horizontal, 32)
                    } else {
                        Text(subtitle)
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                            .padding(.horizontal, 24)
                    }
                }
                
                Spacer(minLength: 80)
            }
        }
        .scrollIndicators(.hidden)
    }
}

// MARK: - Preview

#Preview {
    OnboardingView(onComplete: {})
}
