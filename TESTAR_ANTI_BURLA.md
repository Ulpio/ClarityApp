# 🧪 Teste Rápido - Sistema Anti-Burla

## ⚡ Preparação (30 segundos)

1. **Limpar dados anteriores**
   - Delete app do simulador
   - Ou reset: Device → Erase All Content

2. **Compilar e executar**
   ```bash
   ⌘⇧K (limpar)
   ⌘B (compilar)
   ⌘R (executar)
   ```

---

## 🎯 TESTE 1: Timer Mínimo (2 min)

### Fluxo:
1. Crie ou use template para criar tarefa
2. Clique na tarefa
3. Complete breathe (ou pule)
4. **OBSERVE o botão:**

```
❌ ANTES:
[✓ Completei este passo] ← Clicável imediatamente

✅ AGORA:
[⏱️ Aguarde... 15s]      ← Cinza, desabilitado
[⏱️ Aguarde... 14s]
[⏱️ Aguarde... 13s]
...
[⏱️ Aguarde... 1s]
[✓ Completei este passo] ← Azul, clicável!
```

### O que verificar:
- [ ] Botão inicia desabilitado (cinza)
- [ ] Countdown decrementa 15→0
- [ ] Haptic vibra ao liberar (15s)
- [ ] Botão muda para azul gradiente
- [ ] Só funciona após timer

✅ **Resultado:** Impossível completar antes de 15s

---

## 🎯 TESTE 2: Pausa Entre Passos (1 min)

### Fluxo:
1. Continue da tarefa anterior
2. Aguarde 15s
3. Clique "Completei este passo"
4. **VEJA:**

```
┌─────────────────────────────┐
│       ○  ○  ○               │
│    (círculos pulsando)       │
│                              │
│  Pausa para respirar        │
│  Prepare-se para o próximo  │
└─────────────────────────────┘
```

5. Aguarde 5 segundos
6. **AUTOMATICAMENTE** passa pro próximo passo

### O que verificar:
- [ ] Tela de pausa aparece
- [ ] Círculos animam
- [ ] Dura exatos 5 segundos
- [ ] Transição suave para próximo passo
- [ ] Timer reseta para 15s no novo passo

✅ **Resultado:** Ritmo controlado, sem spam

---

## 🎯 TESTE 3: Configurações (2 min)

### Fluxo:
1. Volte para Home
2. Menu (⋯) → **Configurações** (novo!)
3. **VEJA:** Tela de configurações

### Teste cada opção:

#### Compromisso:
- [ ] **Tempo mínimo:** Arraste stepper 15→30s
- [ ] **Confirmar ao completar:** Ligue toggle
- [ ] **Pausa entre passos:** Arraste 5→10s

#### Timer:
- [ ] **Habilitar Pomodoro:** Ligue
- [ ] **Duração:** Escolha 25 min

#### Experiência:
- [ ] **Lembretes:** Desligue e ligue

### Volte e teste tarefa:
- Agora timer será 30s (não 15s)
- Haverá alert de confirmação
- Pausa será 10s

✅ **Resultado:** Configurações funcionam

---

## 🎯 TESTE 4: Confirmação de Honestidade (1 min)

**Pré-requisito:** Confirmar ativado em Configurações

### Fluxo:
1. Em tarefa, aguarde timer (30s)
2. Clique "Completei este passo"
3. **VEJA:** Alert aparece

```
┌─────────────────────────────────┐
│  Você completou este passo?     │
│                                  │
│  Seja honesto consigo mesmo.    │
│  O valor está em realmente      │
│  fazer.                          │
│                                  │
│  [Ainda não]  [Sim, completei!] │
└─────────────────────────────────┘
```

4. Teste ambas opções:
   - "Ainda não" → Cancela
   - "Sim, completei!" → Avança

### O que verificar:
- [ ] Alert aparece corretamente
- [ ] Mensagem motivacional presente
- [ ] "Ainda não" cancela ação
- [ ] "Sim, completei" avança
- [ ] Só aparece se configurado

✅ **Resultado:** Reflexão consciente funciona

---

## 🎯 TESTE 5: Modo Pomodoro (3 min)

### Fluxo:
1. Em qualquer tarefa
2. Clique ícone **⏱️** (toolbar direita)
3. **VEJA:** Menu "Modo Pomodoro"
4. Ative o toggle
5. **OBSERVE:**

```
┌─────────────────────────────┐
│  ⏱️ 24:59 ▂▂▂▂▂▂▂▂░░       │
│  (timer laranja no topo)     │
│                              │
│  [Círculo com ícone]        │
│  Passo atual...              │
│                              │
│  [⏱️ Aguarde... 15s]         │
└─────────────────────────────┘
```

6. Complete alguns passos
7. Timer continua contando
8. Ao chegar em 00:00 → alerta

### O que verificar:
- [ ] Timer aparece no topo
- [ ] Formato MM:SS correto
- [ ] Progress bar laranja
- [ ] Conta regressivamente
- [ ] Continua entre passos
- [ ] Alerta ao terminar
- [ ] Pode desativar a qualquer momento

✅ **Resultado:** Pomodoro integrado funciona

---

## 🎯 TESTE 6: Mensagens de Compromisso (30s)

**Pré-requisito:** Lembretes ativados

### Fluxo:
1. Em tarefa, olhe no topo
2. **VEJA:** Mensagem sutil

Exemplos:
- "Seja honesto consigo mesmo."
- "O valor está em fazer, não em marcar."
- "Pequenos passos verdadeiros somam."
- "Sua jornada, seu ritmo, sua verdade."
- "Faça com intenção, não com pressa."

### O que verificar:
- [ ] Mensagem aparece no topo
- [ ] Fonte itálica, cinza claro
- [ ] Discreta mas visível
- [ ] Aleatória em cada passo
- [ ] Desaparece se desativada

✅ **Resultado:** Reforço psicológico presente

---

## 📊 Comparação Direta

### Execute este teste:

**Modo Antigo (se ainda tiver):**
1. Complete 3 passos rapidamente
2. Tempo: ~30 segundos

**Modo Novo:**
1. Complete 3 passos
2. Tempo: ~2-3 minutos
   - 15s × 3 (timer) = 45s
   - 5s × 3 (pausa) = 15s
   - 30s (breathe) = 30s
   - **Total:** 90s mínimo

**Diferença:** 3x mais tempo, muito mais intencional!

---

## 🐛 Possíveis Problemas

### Se timer não funciona:
- [ ] Configurações tem valor > 0?
- [ ] App foi recompilado?
- [ ] Dados limpos?

### Se pausa não aparece:
- [ ] Configuração de pausa > 0?
- [ ] Completou um passo corretamente?

### Se Pomodoro não conta:
- [ ] Toggle ativado?
- [ ] Timer em segundo plano funciona?

### Se configurações não salvam:
- [ ] Clicou "Fechar" ao sair?
- [ ] SwiftData inicializado?

---

## ✅ Checklist Completo

Marque tudo que testou:

### Timer Mínimo:
- [ ] Botão desabilitado inicialmente
- [ ] Countdown funciona
- [ ] Haptic ao liberar
- [ ] Visual muda (cinza→azul)

### Pausa Entre Passos:
- [ ] Tela aparece
- [ ] Círculos animam
- [ ] Duração correta
- [ ] Transição automática

### Configurações:
- [ ] Tela abre
- [ ] Stepper funciona
- [ ] Toggles funcionam
- [ ] Picker funciona
- [ ] Salva valores

### Confirmação:
- [ ] Alert aparece
- [ ] Mensagem correta
- [ ] Ambos botões funcionam

### Pomodoro:
- [ ] Timer aparece
- [ ] Conta corretamente
- [ ] Progress bar funciona
- [ ] Alerta ao fim

### Mensagens:
- [ ] Aparecem no topo
- [ ] Diferentes em cada passo
- [ ] Toggle funciona

---

## 🎊 Resultado Esperado

### Visual:
✅ Mais informação na tela  
✅ Timers e contadores  
✅ Mensagens motivacionais  
✅ Pausas forçadas

### Comportamento:
✅ Impossível completar rápido demais  
✅ Ritmo controlado  
✅ Reflexão presente  
✅ Configurável

### Sensação:
✅ Mais sério e profissional  
✅ Comprometedor  
✅ Intencional  
✅ Ajuda de verdade

---

## 📝 Feedback Esperado

**Usuário deve sentir:**
1. "Agora sim, preciso realmente fazer"
2. "O ritmo está bom, não apressado"
3. "As mensagens me lembram o propósito"
4. "Configurações me dão controle"
5. "Pomodoro é útil para tarefas longas"

**vs Antes:**
1. "Muito fácil burlar"
2. "Clico sem pensar"
3. "Não ajuda de verdade"

---

## 🚀 Próximo Passo

Se tudo funcionou:
✅ Sistema anti-burla está perfeito  
✅ App muito mais robusto  
✅ Experiência profissional  
✅ Pronto para usuários reais

Se encontrou bugs:
🐛 Me avise quais  
🔧 Vamos corrigir  
✅ Re-testar

---

**Tempo total de teste:** ~10 minutos  
**Resultado esperado:** 🔒 Muito mais comprometedor!

**TESTE AGORA!** 🧪
