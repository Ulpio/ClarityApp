# Decisões de design – Clarity

Documento das principais decisões de produto e implementação do app Clarity.

---

## 1. Sistema anti-burla (60% do tempo)

**Decisão:** Cada passo pode ter um tempo estimado (minutos). O botão “Completei este passo” só fica disponível após **60%** do tempo estimado ter passado.

**Motivo:**
- Reduz o uso do app como “lista de checkboxes” sem execução real.
- Incentiva tempo mínimo de foco por passo.
- Mantém flexibilidade: passos sem tempo estimado usam um mínimo global (ex.: 15s) configurável.

**Implementação:** `StudyStepSD.minimumRequiredSeconds` (60% de `estimatedMinutes * 60`). Em `FocusViewEnhanced`, o timer compara `elapsedSeconds` com `minimumDuration` para habilitar o botão.

---

## 2. Skip de passos e respiração

**Decisão:** O usuário pode pular o exercício de respiração e pular passos individuais. Ambos são **contabilizados** (em `AppSettings` e por tarefa/passo) e exibidos em Estatísticas (taxa de skip, passos pulados).

**Motivo:**
- Às vezes pular é legítimo (urgência, passo irrelevante). Não bloquear o fluxo.
- Tornar o skip visível incentiva uso consciente e honestidade.
- Dados de skip permitem conquistas (“Sem Atalhos”, “Zen Master”) e métricas claras.

**Implementação:** `AppSettings.totalBreathesSkipped`, `totalStepsSkipped`; em cada tarefa `breatheSkipped`; em cada passo `wasSkipped` / `skippedAt`. Opções “Permitir pular respiração” e “Permitir pular passos” em Configurações.

---

## 3. Sem gradientes na UI

**Decisão:** Evitar gradientes em telas e botões; usar cores sólidas e cores semânticas do sistema.

**Motivo:**
- Aparência mais limpa e alinhada às HIG.
- Melhor legibilidade e contraste, inclusive em dark mode.
- Evita sensação de “template genérico”.

**Implementação:** Uso de `Color(.systemBackground)`, `Color(.secondarySystemGroupedBackground)`, `.tint`, `.secondary`, e cores de `Category` sem gradientes em listas e cards.

---

## 4. Dynamic Island (Live Activity)

**Decisão:** Mostrar progresso da tarefa em tempo real na Dynamic Island (e Lock Screen): passo atual, total de passos, timer e estado “pode completar”.

**Motivo:**
- Progresso visível sem abrir o app.
- Aproveitamento de recurso nativo do iPhone Pro.
- Diferencial técnico e de UX para o Swift Student Challenge.

**Implementação:** `ActivityKit` + atributos em `StudyActivityAttributes`; UI em `StudyLiveActivity`; target **ClarityLiveActivity** (Widget Extension) para renderizar a Live Activity. `LiveActivityManager` inicia/atualiza/encerra a atividade a partir de `FocusViewEnhanced`.

---

## 5. Onboarding em 4 telas

**Decisão:** Na primeira abertura, exibir 4 telas: Boas-vindas, Como funciona, Sistema anti-burla, Dynamic Island. Persistir “já viu” com `@AppStorage("hasSeenOnboarding")`.

**Motivo:**
- Juízes e novos usuários entendem rápido o valor e as regras (anti-burla, tempo).
- Destacar o diferencial (Dynamic Island) desde o início.

**Implementação:** `OnboardingView` com `TabView` em estilo página e botão “Começar!” na última tela; em `Clarity.swift`, exibir onboarding ou `HomeViewSD` conforme `hasSeenOnboarding`.

---

## 6. Estatísticas e honestidade

**Decisão:** Dashboard de estatísticas inclui métricas “negativas”: taxa de skip, passos pulados, respirações puladas. Gráfico de tarefas por dia com opção 7 ou 30 dias.

**Motivo:**
- Transparência: o app não esconde o uso de skip.
- Apoia reflexão e conquistas baseadas em consistência (ex.: “Sem Atalhos”).

**Implementação:** `StatsView` com cards (concluídas, total, streak, passos feitos, taxa de skip, tempo focado, passos pulados, categoria favorita) e `DailyChartSection` (7/30 dias) usando Swift Charts.

---

## 7. Conquistas expandidas

**Decisão:** Além de contagem de tarefas e streaks, incluir conquistas por: tarefas sem pular passo (5 e 10), respirações sem pular (20), horário (madrugador, coruja), categorias (Estudos, Trabalho, Criativo).

**Motivo:**
- Gamificação alinhada aos comportamentos que o app incentiva (foco, não pular, variedade de categorias).

**Implementação:** Novos casos em `AchievementType` e lógica em `checkUnlock(completedTasks:streak:)` usando `wasSkipped`, `breatheSkipped`, `completedAt` (hora) e `category?.name`. `initializeAchievements` insere apenas tipos que ainda não existem no banco.

---

## 8. Persistência com SwiftData

**Decisão:** Usar SwiftData para tarefas, passos, categorias, configurações e conquistas. Fallback para container em memória se o ModelContainer persistente falhar (ex.: schema antigo).

**Motivo:**
- Modelo moderno e integrado ao SwiftUI.
- Suporte a relações, queries e migração razoável.

**Implementação:** `Clarity.swift` cria `ModelContainer` com schema completo; em `catch`, tenta container em memória e inicializa categorias, conquistas e `AppSettings`; se falhar de novo, `fatalError` com mensagem para reinstalar.

---

## 9. Acessibilidade por último

**Decisão:** Deixar melhorias de acessibilidade (VoiceOver, contraste, Dynamic Type) para a última fase do projeto.

**Motivo:**
- Priorizar fluxo principal, onboarding, analytics e conquistas primeiro.
- Acessibilidade continua no escopo, mas após o núcleo do app estável.

---

## 10. Clean code e documentação

**Decisão:** Remover prints de debug em produção; manter comentários apenas onde ajudam (ex.: fallback do container); documentar visão geral e decisões em README e DECISOES_DESIGN.

**Motivo:**
- Código pronto para revisão e submissão.
- Facilita manutenção e explicação do projeto no Challenge.

**Implementação:** Remoção de `print` em `Clarity.swift`, `LiveActivityManager`, `BreatheView`, `FocusViewSD`, `StudyStore`, `CompletionView`. README principal na raiz do repo e README dentro de `Clarity/Clarity`; este arquivo para decisões de design.
