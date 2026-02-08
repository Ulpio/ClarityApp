# Clarity

App iOS de foco e estudo que transforma grandes tarefas em passos claros e alcançáveis. Desenvolvido para o **Swift Student Challenge 2026**.

---

## Descrição

O Clarity ajuda a reduzir a sobrecarga mental e a procrastinação ao dividir qualquer tarefa em passos simples. Um passo por vez, com respiração guiada, sistema anti-burla e integração com a Dynamic Island.

**Princípio:** estudar é mais fácil quando está quebrado em pequenos passos visíveis e realizáveis.

---

## Funcionalidades principais

| Recurso | Descrição |
|--------|-----------|
| **Tarefas em passos** | Divida qualquer tarefa em passos com tempo estimado (opcional). |
| **Sistema anti-burla** | Só é possível avançar após 60% do tempo estimado do passo. |
| **Respiração guiada** | Exercício de respiração antes de começar (pode ser pulado, com contagem). |
| **Dynamic Island** | Progresso e timer em tempo real na Dynamic Island (iPhone Pro). |
| **Onboarding** | 4 telas na primeira abertura: boas-vindas, como funciona, anti-burla, Dynamic Island. |
| **Estatísticas** | Concluídas, streak, taxa de skip, tempo focado, categoria favorita, gráfico 7/30 dias. |
| **Conquistas** | 18 conquistas (primeira tarefa, streaks, sem skip, horário, categorias). |
| **Templates** | Modelos prontos por categoria (Estudos, Trabalho, Saúde, etc.). |
| **Dark mode** | Cores semânticas do sistema, sem gradientes. |

---

## Tecnologias

- **Swift 5.9+** · **SwiftUI** · **SwiftData** (persistência)
- **ActivityKit** (Live Activities / Dynamic Island)
- **Swift Charts** (gráficos em Estatísticas)
- **Widget Extension** (target ClarityLiveActivity para renderizar a Live Activity)

---

## Estrutura do projeto

```
Clarity/
├── Clarity.swift              # Entrada do app, ModelContainer, onboarding
├── Models/
│   ├── StudyTaskSD.swift      # Tarefa (SwiftData)
│   ├── StudyStepSD.swift      # Passo (tempo estimado, wasSkipped)
│   ├── Category.swift        # Categorias e cores
│   ├── AppSettings.swift     # Configurações e contadores de skip
│   ├── Achievement.swift     # Conquistas e AchievementManager
│   └── TaskTemplate.swift    # Templates pré-definidos
├── Views/
│   ├── HomeViewSD.swift      # Lista de tarefas
│   ├── CreateTaskViewSD.swift
│   ├── FocusViewEnhanced.swift  # Modo foco + anti-burla + Live Activity
│   ├── BreatheView.swift
│   ├── CompletionViewSD.swift
│   ├── StatsView.swift       # Dashboard de estatísticas
│   ├── AchievementsView.swift
│   ├── OnboardingView.swift
│   └── ...
├── LiveActivities/
│   ├── StudyActivityAttributes.swift
│   └── StudyLiveActivity.swift   # UI da Dynamic Island / Lock Screen
├── Managers/
│   └── LiveActivityManager.swift
└── ClarityLiveActivity/      # Widget Extension (target separado)
    └── ClarityLiveActivityWidget.swift
```

---

## Como rodar

1. Abra `Clarity.xcodeproj` no Xcode.
2. Selecione o scheme **Clarity** e um simulador (ex.: iPhone 15 Pro) ou dispositivo.
3. **Product → Run** (⌘R).

**Requisitos:** Xcode 15+, iOS 17+ (Dynamic Island em dispositivos Pro com iOS 16.2+).

---

## Documentação

- **[Clarity/README.md](Clarity/Clarity/README.md)** — Visão geral do app, público-alvo e telas.
- **[ROADMAP.md](ROADMAP.md)** — Mapeamento das funcionalidades atuais e roadmap das próximas.

---

## Swift Student Challenge 2026

Projeto criado para explorar design acessível, foco em um passo por vez e integração nativa (Dynamic Island, SwiftData, Swift Charts).

---

## Licença

Criado para Swift Student Challenge 2026.
