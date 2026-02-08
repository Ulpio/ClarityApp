//
//  SettingsView.swift
//  Clarity
//
//  App settings and preferences
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var settingsQuery: [AppSettings]
    
    private var settings: AppSettings? {
        settingsQuery.first
    }
    
    var body: some View {
        NavigationStack {
            Form {
                // Anti-burla settings
                Section {
                    if let settings = settings {
                        Stepper("Tempo mínimo por passo: \(settings.minimumStepDuration)s",
                               value: Binding(
                                get: { settings.minimumStepDuration },
                                set: { settings.minimumStepDuration = $0 }
                               ),
                               in: 0...60,
                               step: 5)
                        
                        Toggle("Confirmar ao completar",
                              isOn: Binding(
                                get: { settings.requireConfirmation },
                                set: { settings.requireConfirmation = $0 }
                              ))
                        
                        Stepper("Pausa entre passos: \(settings.pauseBetweenSteps)s",
                               value: Binding(
                                get: { settings.pauseBetweenSteps },
                                set: { settings.pauseBetweenSteps = $0 }
                               ),
                               in: 0...30,
                               step: 5)
                    }
                } header: {
                    Text("Compromisso")
                } footer: {
                    Text("Ajustes para tornar o processo mais intencional e menos automático.")
                }
                
                // Pomodoro settings
                Section {
                    if let settings = settings {
                        Toggle("Habilitar modo Pomodoro",
                              isOn: Binding(
                                get: { settings.pomodoroEnabled },
                                set: { settings.pomodoroEnabled = $0 }
                              ))
                        
                        if settings.pomodoroEnabled {
                            Picker("Duração do Pomodoro",
                                  selection: Binding(
                                    get: { settings.pomodoroDuration },
                                    set: { settings.pomodoroDuration = $0 }
                                  )) {
                                Text("15 min").tag(15)
                                Text("25 min").tag(25)
                                Text("45 min").tag(45)
                                Text("60 min").tag(60)
                            }
                        }
                    }
                } header: {
                    Text("Timer")
                } footer: {
                    Text("Modo Pomodoro adiciona um timer para sessões de foco prolongadas.")
                }
                
                // UX settings
                Section {
                    if let settings = settings {
                        Toggle("Mostrar lembretes de honestidade",
                              isOn: Binding(
                                get: { settings.showHonestyReminders },
                                set: { settings.showHonestyReminders = $0 }
                              ))
                        
                        Toggle("Permitir pular respiração",
                              isOn: Binding(
                                get: { settings.allowSkipBreathe },
                                set: { settings.allowSkipBreathe = $0 }
                              ))
                        
                        Toggle("Permitir pular passos",
                              isOn: Binding(
                                get: { settings.allowSkipSteps },
                                set: { settings.allowSkipSteps = $0 }
                              ))
                    }
                } header: {
                    Text("Experiência")
                } footer: {
                    Text("Controle quais elementos você pode pular durante o estudo.")
                }
                
                // Categorias
                Section {
                    NavigationLink {
                        ManageCategoriesView()
                            .environment(\.modelContext, modelContext)
                    } label: {
                        Label("Categorias", systemImage: "folder.fill")
                    }
                } header: {
                    Text("Categorias")
                } footer: {
                    Text("Crie categorias personalizadas com emojis ou símbolos.")
                }
                
                // Statistics
                Section {
                    if let settings = settings {
                        HStack {
                            Label("Respirações puladas", systemImage: "wind")
                            Spacer()
                            Text("\(settings.totalBreathesSkipped)")
                                .foregroundStyle(settings.totalBreathesSkipped > 0 ? .orange : .green)
                                .fontWeight(.semibold)
                                .monospacedDigit()
                        }
                        
                        HStack {
                            Label("Passos pulados", systemImage: "forward.fill")
                            Spacer()
                            Text("\(settings.totalStepsSkipped)")
                                .foregroundStyle(settings.totalStepsSkipped > 0 ? .orange : .green)
                                .fontWeight(.semibold)
                                .monospacedDigit()
                        }
                        
                        if settings.totalBreathesSkipped > 0 || settings.totalStepsSkipped > 0 {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("💡 Dica")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.blue)
                                
                                if settings.totalBreathesSkipped > 0 && settings.totalStepsSkipped > 0 {
                                    Text("Tente evitar pular passos e respirações. O valor está em realmente fazer cada etapa com atenção.")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                } else if settings.totalBreathesSkipped > 0 {
                                    Text("Respirar antes de focar ajuda você a ter uma sessão mais produtiva e consciente.")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                } else {
                                    Text("Tente completar todos os passos quando possível. Cada passo tem seu valor no processo de aprendizado.")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                } header: {
                    Text("Estatísticas")
                } footer: {
                    Text("Acompanhe seu engajamento com as práticas de foco.")
                }
                
                // About
                Section {
                    HStack {
                        Text("Versão")
                        Spacer()
                        Text("2.0 (Enhanced)")
                            .foregroundStyle(.secondary)
                    }
                    
                    HStack {
                        Text("Build")
                        Spacer()
                        Text("Fase 2 + Anti-Burla + Skip Tracking")
                            .foregroundStyle(.secondary)
                            .font(.caption)
                    }
                } header: {
                    Text("Sobre")
                }
                
                // Recommendations
                Section {
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Recomendações", systemImage: "lightbulb.fill")
                            .font(.headline)
                            .foregroundStyle(.yellow)
                        
                        Text("• Timer mínimo de 15-30s por passo")
                        Text("• Pausa de 5s entre passos")
                        Text("• Lembretes de honestidade ativos")
                        Text("• Confirmar ao completar (opcional)")
                        
                        Text("\nEstas configurações ajudam você a usar o app de forma mais intencional.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Configurações")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Fechar") {
                        try? modelContext.save()
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: AppSettings.self, configurations: config)
    
    let settings = AppSettings()
    container.mainContext.insert(settings)
    
    return SettingsView()
        .modelContainer(container)
}
