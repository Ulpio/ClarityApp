# 🧪 Teste Rápido - Tempo Estimado por Passo

## ⚡ Preparação (30s)

```bash
# Limpar dados antigos
# Delete app do simulador

# Compilar
⌘⇧K
⌘B
⌘R
```

---

## 🎯 TESTE 1: Criar Passo com Tempo (2 min)

### Fluxo:
1. Criar nova tarefa: "Estudar Matemática"
2. Categoria: Estudos
3. Adicionar passo: "Ler capítulo 3"
4. **VEJA:** Embaixo do campo, menu de tempo

```
┌─────────────────────────────────┐
│ 1. [Ler capítulo 3_________]   │
│                                  │
│    ⏱️ [Definir tempo ▼]        │  ← NOVO!
└─────────────────────────────────┘
```

5. Clique no menu
6. **VEJA:** Lista de opções:
   - Sem tempo definido
   - 5 minutos
   - 10 minutos
   - 15 minutos ← Escolha este
   - 20 minutos
   - 30 minutos
   - 45 minutos
   - 60 minutos
   - Personalizar...

7. Selecione "15 minutos"
8. **OBSERVE:**
   - Badge muda para azul
   - Texto: "15 min"
   - Aparece: "(mín: 9min)"

✅ **Resultado:** Campo de tempo funciona!

---

## 🎯 TESTE 2: Usar Template com Tempos (1 min)

### Fluxo:
1. Menu → Templates
2. Escolha "Revisar Matéria"
3. Clique "Ver passos" (expande)
4. **OBSERVE:**

```
┌─────────────────────────────────┐
│ 1. Abrir o material de estudo   │
│    ⏱️ 5 min                      │  ← Tempo!
│                                  │
│ 2. Ler o resumo do capítulo     │
│    ⏱️ 15 min                     │
│                                  │
│ 3. Fazer anotações...           │
│    ⏱️ 10 min                     │
└─────────────────────────────────┘
```

5. **VEJA** no card: "~60min" (tempo total)
6. Clique "Usar"
7. Tarefa criada!

✅ **Resultado:** Templates com tempos funcionam!

---

## 🎯 TESTE 3: Modo Foco com Tempo ⭐ PRINCIPAL (3 min)

### Fluxo:
1. Abra a tarefa "Revisar Matéria"
2. Complete o breathe (ou pule)
3. **VEJA o passo:**

```
┌─────────────────────────────────┐
│       [Ícone 1]                 │
│                                  │
│  Abrir o material de estudo     │
│                                  │
│  ⏱️ Tempo estimado: 5 min       │  ← Badge novo!
│  (mín: 3min)                    │
│                                  │
│  0:00 ▓▓░░░░│░░░░░░░░ 5:00     │  ← Progress bar!
│          60% ▲                   │
│                                  │
│  [⏱️ Aguarde... 3:00]           │  ← Botão desabilitado
│  0% do tempo mínimo              │
└─────────────────────────────────┘
```

4. **AGUARDE e OBSERVE:**

**Aos 30 segundos:**
```
[⏱️ Aguarde... 2:30]
16% do tempo mínimo
```

**Aos 1 minuto:**
```
[⏱️ Aguarde... 2:00]
33% do tempo mínimo
```

**Aos 2 minutos:**
```
[⏱️ Aguarde... 1:00]
66% do tempo mínimo  ← Passou dos 60%!
```

**Marcador dos 60% fica VERDE!**

**Aos 3 minutos (60%):**
```
[✓ Completei este passo]  ← Azul, clicável!
```

5. **HAPTIC VIBRA!** 🎉
6. Botão agora azul e ativo
7. Pode completar!

✅ **Resultado:** Sistema de 60% funciona perfeitamente!

---

## 🎯 TESTE 4: Progress Bar Visual (observar)

Durante o TESTE 3, observe:

### Elementos da Progress Bar:

```
Legenda:
▓ = Progresso (verde)
│ = Marcador 60% (laranja→verde)
░ = Restante (cinza)

0:00 ────────│──────── 5:00
         60%
```

### Aos 0s (0%):
```
────────│──────── 
(vazia, marcador laranja)
```

### Aos 1min30s (50%):
```
▓▓▓▓▓───│────────
(quase no 60%, marcador laranja)
```

### Aos 3min (60%):
```
▓▓▓▓▓▓▓▓│────────
(passou 60%, marcador VERDE!)
```

### Aos 5min (100%):
```
▓▓▓▓▓▓▓▓│▓▓▓▓▓▓▓▓
(completo!)
```

✅ **Visual:** Progress bar anima suavemente

---

## 🎯 TESTE 5: Passo SEM Tempo (fallback)

### Fluxo:
1. Crie nova tarefa
2. Passo sem definir tempo
3. Deixe "Sem tempo definido"
4. Entre no foco
5. **VEJA:**
   - Sem badge de tempo
   - Sem progress bar longa
   - Timer padrão (15s)
   - Comportamento anterior

✅ **Resultado:** Fallback funciona!

---

## 🎯 TESTE 6: Tempos Diferentes (variação)

### Teste com tempos variados:

**Passo 1:** 5 min → Mínimo: 3 min  
**Passo 2:** 15 min → Mínimo: 9 min  
**Passo 3:** 30 min → Mínimo: 18 min  
**Passo 4:** 0 min (sem) → Fallback: 15s  

**Observe:**
- Cada um calcula 60% diferente
- Progress bar muda de escala
- Visual adapta automaticamente

✅ **Resultado:** Sistema flexível!

---

## ⏱️ Teste Cronometrado

### Valide os 60%:

1. **5 minutos estimados:**
   - Deve liberar aos 3:00
   - Teste: ✓ ou ✗

2. **15 minutos estimados:**
   - Deve liberar aos 9:00
   - Teste: ✓ ou ✗

3. **30 minutos estimados:**
   - Deve liberar aos 18:00
   - Teste: ✓ ou ✗

---

## 📊 O Que Observar

### Visual:
- [ ] Badge azul com tempo
- [ ] "(mín: Xmin)" calculado
- [ ] Progress bar dupla
- [ ] Marcador aos 60%
- [ ] Contador "X:XX / XX:XX"
- [ ] Percentual do mínimo

### Comportamento:
- [ ] Botão desabilitado antes 60%
- [ ] Haptic ao atingir 60%
- [ ] Marcador muda cor (laranja→verde)
- [ ] Botão ativa aos 60%
- [ ] Pode completar após 60%

### Templates:
- [ ] Todos têm tempos
- [ ] Tempo total no card
- [ ] Tempos por passo no preview
- [ ] "Usar" cria com tempos

---

## ✅ Checklist Completo

- [ ] Criar passo com tempo funciona
- [ ] Menu tem 9 opções
- [ ] Badge mostra corretamente
- [ ] Mínimo calcula 60%
- [ ] Progress bar aparece
- [ ] Marcador aos 60% correto
- [ ] Contador conta certo
- [ ] Percentual atualiza
- [ ] Botão libera aos 60%
- [ ] Haptic vibra
- [ ] Templates têm tempos
- [ ] Fallback funciona (sem tempo)
- [ ] Visual bonito e claro

---

## 🎊 Comparação Rápida

### Execute este teste:

**Passo COM tempo (15 min):**
- Espera: 9 minutos
- Visual rico
- Progress bar
- Realista ✅

**Passo SEM tempo:**
- Espera: 15 segundos
- Visual simples
- Timer básico
- Rápido ✅

**Ambos funcionam!** Sistema inteligente.

---

## 🐛 Possíveis Problemas

### Se progress bar não aparece:
- Tempo estimado está > 0?
- Visual oculto?
- Recompilar

### Se não calcula 60%:
- Check: 60% de 10min = 6min
- Check: 60% de 15min = 9min
- Confirme cálculo

### Se marcador não muda cor:
- Aguarde atingir exatos 60%
- Deve mudar laranja→verde

---

## 📝 Feedback Esperado

**Ao usar:**
1. "Agora faz sentido! Tem tempo de verdade"
2. "A barra mostra onde estou"
3. "60% é razoável, não muito rígido"
4. "Templates já têm tudo pronto"
5. "Posso misturar: com e sem tempo"

---

**Tempo total de teste:** ~10 minutos  
**Resultado esperado:** 😍 Sistema realista e inteligente!

**TESTE AGORA!** 🧪
