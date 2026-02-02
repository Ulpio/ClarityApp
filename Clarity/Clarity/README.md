# Clarity – App target

Este é o target principal do app Clarity (SwiftUI + SwiftData).

---

## Visão geral

O Clarity ajuda a reduzir a sobrecarga mental ao dividir tarefas em passos claros. Um passo por vez, com respiração guiada, sistema anti-burla (60% do tempo estimado) e integração com a Dynamic Island.

**Público-alvo:** estudantes e qualquer pessoa que se beneficie de tarefas divididas em passos (ex.: foco, ansiedade, TDAH).

---

## Telas principais

| Tela | Descrição |
|------|-----------|
| **OnboardingView** | 4 telas na primeira abertura (boas-vindas, como funciona, anti-burla, Dynamic Island). |
| **HomeViewSD** | Lista de tarefas, filtro por categoria, menu (templates, conquistas, estatísticas, configurações). |
| **CreateTaskViewSD** | Criar tarefa com passos e tempo estimado por passo. |
| **FocusViewEnhanced** | Modo foco: um passo por vez, timer, anti-burla, Live Activity, mensagens motivacionais. |
| **BreatheView** | Exercício de respiração guiada antes de começar (opcional, com skip). |
| **CompletionViewSD** | Tela de conclusão da tarefa. |
| **StatsView** | Dashboard: concluídas, streak, taxa de skip, tempo focado, gráfico 7/30 dias. |
| **AchievementsView** | Conquistas desbloqueadas e bloqueadas. |
| **SettingsView** | Configurações (tempo mínimo, skip, Pomodoro, estatísticas de skip). |

---

## Arquitetura

- **Models:** SwiftData (`StudyTaskSD`, `StudyStepSD`, `Category`, `AppSettings`, `Achievement`).
- **Views:** SwiftUI; navegação com `NavigationStack` e `.sheet`.
- **Persistência:** SwiftData (`ModelContainer` em `Clarity.swift`).
- **Live Activity:** `LiveActivityManager` + `StudyActivityAttributes` + UI em target **ClarityLiveActivity** (Widget Extension).

---

## Dependências do target

- **SwiftUI** · **SwiftData** · **ActivityKit** (Live Activities)
- **Charts** (Swift Charts em `StatsView`)

O target **ClarityLiveActivity** (Widget Extension) referencia `StudyActivityAttributes` e `StudyLiveActivity`; os arquivos dessas views precisam ter **Target Membership** em ClarityLiveActivity no Xcode.

---

## Build e execução

1. Abra o projeto no Xcode.
2. Selecione o scheme **Clarity** (não ClarityLiveActivity).
3. **Product → Run** (⌘R).

Para testar a Dynamic Island, use um simulador ou dispositivo **iPhone Pro** (ex.: iPhone 15 Pro).

---

## Documentação

- **[../../README.md](../../README.md)** — Visão geral do repositório.
- **[../../DECISOES_DESIGN.md](../../DECISOES_DESIGN.md)** — Decisões de design e anti-burla.
