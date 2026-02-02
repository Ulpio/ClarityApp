# 🧪 Teste Rápido - Skip de Passos

**Tempo:** ~3 minutos  
**Objetivo:** Validar sistema de skip de passos

---

## 🚀 Preparação (30s)

```bash
# 1. Limpar (importante para testar schema changes)
Delete app do simulador

# 2. Build
⌘⇧K && ⌘B && ⌘R
```

---

## ✅ TESTE 1: Botão de Skip Aparece (1 min)

### Passos:
1. Criar nova tarefa: "Teste Skip"
2. Adicionar 3 passos qualquer
3. Entrar na tarefa
4. Passar breathe (ou pular)

**VEJA na tela:**
```
┌─────────────────────────────────┐
│  [Ícone]                        │
│  Nome do passo                  │
│                                  │
│  [✓ Completei este passo]      │ ← Verde
│                                  │
│  [→ Pular este passo]           │ ← Laranja (NOVO!)
└─────────────────────────────────┘
```

### Validação:
- ✅ **PASSOU:** 2 botões aparecem
- ❌ **FALHOU:** Só 1 botão

---

## ⏭️ TESTE 2: Pular Funciona (1 min)

### Passos:
1. **Clique:** "Pular este passo"
2. **VEJA alert:**
   ```
   ⚠️ Pular este passo?
   
   Este passo será marcado como pulado.
   Tente fazer sempre que possível...
   
   [Cancelar] [Pular]
   ```
3. **Clique:** "Pular"
4. **OBSERVE console:**
   ```
   ⏭️ PASSO PULADO: 'Nome do passo'
   📊 Total de passos pulados: 1
   ```
5. **SINTA:** Haptic vibra (warning ⚠️)
6. **VEJA:** Próximo passo aparece

### Validação:
- ✅ Alert aparece
- ✅ Console mostra mensagem
- ✅ Haptic vibra
- ✅ Próximo passo aparece

---

## 📊 TESTE 3: Estatísticas (1 min)

### Passos:
1. Após pular 1 ou mais passos
2. Voltar para home
3. Menu → Configurações ⚙️
4. Role até "Estatísticas"

**VEJA:**
```
┌─────────────────────────────────┐
│ Estatísticas                     │
├─────────────────────────────────┤
│ 💨 Respirações puladas      0   │ (verde)
│ → Passos pulados           1   │ (laranja) ← NOVO!
│                                  │
│ 💡 Dica                         │
│ Tente completar todos os        │
│ passos quando possível...       │
└─────────────────────────────────┘
```

### Validação:
- ✅ Contador mostra número correto
- ✅ Cor laranja se > 0, verde se = 0
- ✅ Dica aparece se > 0

---

## 🔄 TESTE 4: Skip vs Complete (2 min)

### Passo 1 - COMPLETAR:
1. Criar tarefa com 3 passos
2. Entrar na tarefa
3. **Clicar:** "Completei este passo"
4. **Observe:**
   - Haptic: Success ✓
   - Console: (sem mensagem)

### Passo 2 - PULAR:
1. **Clicar:** "Pular este passo"
2. Confirmar
3. **Observe:**
   - Haptic: Warning ⚠️
   - Console: "⏭️ PASSO PULADO..."

### Passo 3 - COMPLETAR:
1. **Clicar:** "Completei este passo"

### Resultado:
- Configurações → Estatísticas
- **VEJA:** "Passos pulados: 1"
- Apenas o passo 2 foi contado!

### Validação:
- ✅ Haptics diferentes
- ✅ Logs diferentes
- ✅ Apenas skip conta no contador

---

## ⚙️ TESTE 5: Toggle de Controle (1 min)

### Desabilitar:
1. Configurações → Experiência
2. **Desligar:** "Permitir pular passos"
3. Entrar em uma tarefa
4. **VEJA:** Botão laranja NÃO aparece
5. Só botão verde disponível

### Habilitar:
1. Voltar em Configurações
2. **Ligar:** "Permitir pular passos"
3. Entrar em tarefa
4. **VEJA:** Botão laranja reaparece

### Validação:
- ✅ Toggle controla visibilidade do botão
- ✅ App respeita configuração

---

## 🎯 TESTE 6: Múltiplos Skips (1 min)

### Passos:
1. Criar tarefa com 5 passos
2. Pular todos os 5
3. **Observe console:**
   ```
   ⏭️ PASSO PULADO: 'Passo 1'
   📊 Total de passos pulados: 1
   
   ⏭️ PASSO PULADO: 'Passo 2'
   📊 Total de passos pulados: 2
   
   ...até 5
   ```
4. Tarefa completa normalmente
5. Configurações → Estatísticas
6. **VEJA:** "Passos pulados: 5"

### Validação:
- ✅ Contador incrementa corretamente
- ✅ Tarefa completa mesmo com skips
- ✅ Todos registrados

---

## 🎨 TESTE 7: Visual e UX (30s)

### Verifique:
- [ ] Botão verde é maior/principal
- [ ] Botão laranja é menor/secundário
- [ ] Cores são distintas (verde vs laranja)
- [ ] Alert é claro e não punitivo
- [ ] Haptic de skip é diferente de complete
- [ ] Transição para próximo passo é suave
- [ ] Contador em Settings é visível

---

## ✅ Checklist Completo

### Funcionalidade:
- [ ] Botão de skip aparece
- [ ] Alert de confirmação funciona
- [ ] Skip vai para próximo passo
- [ ] Complete vai para próximo passo
- [ ] Tarefa completa com skips

### Tracking:
- [ ] Console mostra mensagem de skip
- [ ] Contador global incrementa
- [ ] Estatísticas em Settings atualizam
- [ ] Apenas skips contam (não completes)

### UX:
- [ ] Haptic warning no skip
- [ ] Haptic success no complete
- [ ] Cores diferentes (verde/laranja)
- [ ] Botão skip é secundário visualmente
- [ ] Dicas adaptativas aparecem

### Controle:
- [ ] Toggle "Permitir pular passos" funciona
- [ ] Desligar remove botão
- [ ] Ligar mostra botão

---

## 📊 Console Esperado

### Ao completar:
```
(nenhuma mensagem)
```

### Ao pular:
```
⏭️ PASSO PULADO: 'Fazer exercícios'
📊 Total de passos pulados: 1
```

### Múltiplos skips:
```
⏭️ PASSO PULADO: 'Passo 1'
📊 Total de passos pulados: 1

⏭️ PASSO PULADO: 'Passo 2'
📊 Total de passos pulados: 2

⏭️ PASSO PULADO: 'Passo 3'
📊 Total de passos pulados: 3
```

---

## 🐛 Se Algo Falhar

### Botão não aparece:
- Verifique se "Permitir pular passos" está ligado
- Recompile o app
- Delete e reinstale

### Contador não atualiza:
- Veja console para mensagens
- Verifique Settings
- Tente outro skip

### App crashou:
- Schema mudou (novos campos)
- Delete app e reinstale
- Veja console para erro

---

## 🎊 Resultado Esperado

Se tudo funcionar:

✅ **Botão laranja** aparece  
✅ **Alert** confirma antes de pular  
✅ **Console** mostra mensagens  
✅ **Haptic** vibra diferente  
✅ **Contador** incrementa  
✅ **Estatísticas** atualizam  
✅ **Toggle** controla feature  

**Sistema de skip COMPLETO e funcional!** 🚀

---

## 💡 Casos de Uso para Testar

### Cenário 1: Passo Opcional
```
Tarefa: Estudar
├─ 1. Ler capítulo ✓
├─ 2. Exercícios extras ⏭️
└─ 3. Revisar ✓
```

### Cenário 2: Sem Tempo
```
Tarefa: Projeto
├─ 1. Pesquisar ✓
├─ 2. Fazer resumo ⏭️
└─ 3. Apresentar ✓
```

### Cenário 3: Todos Skipped
```
Tarefa: Teste
├─ 1. Passo 1 ⏭️
├─ 2. Passo 2 ⏭️
└─ 3. Passo 3 ⏭️

Resultado: Contador = 3
```

---

**Tempo total:** ~3-5 minutos  
**Testes críticos:** 6  
**Resultado esperado:** Todos ✅

**TESTE AGORA!** 🧪
