# 📱 Checklist de Testes - Dispositivo Real

**Device:** iPhone (físico)  
**Data:** 1 de fevereiro de 2026  
**Tempo estimado:** 15-20 minutos

---

## 🎯 Objetivo

Testar TODAS as features no dispositivo real para:
- ✅ Validar performance
- ✅ Testar haptics (não funciona no simulador)
- ✅ Validar gestures e toques
- ✅ Encontrar bugs antes da submissão

---

## 📋 Checklist Completo

### ✅ FASE 1: Primeira Impressão (2 min)

- [ ] **App abre sem crash**
- [ ] **Tela inicial carrega rápido** (< 2 segundos)
- [ ] **Animações suaves** (sem lag)
- [ ] **Cores aparecem corretas** (sem gradientes)
- [ ] **Textos legíveis** em todos tamanhos

**Notas:**
```
Performance inicial:
- Tempo de abertura: ___s
- Lag percebido: Sim / Não
- Cores OK: Sim / Não
```

---

### ✅ FASE 2: Criar Tarefa (3 min)

#### Teste: Criar tarefa com tempo estimado

1. [ ] Toque no botão + (responde rápido?)
2. [ ] Digite título: "Estudar Swift"
3. [ ] Adicione 3 passos:
   - Passo 1: "Ler documentação" (15 min)
   - Passo 2: "Fazer exercícios" (20 min)  
   - Passo 3: "Revisar código" (10 min)
4. [ ] **Menu de tempo abre suavemente**
5. [ ] **Toque funciona bem**
6. [ ] Selecione categoria: Estudos
7. [ ] Salve a tarefa

**Validar:**
- [ ] Teclado aparece/some corretamente
- [ ] Scroll funciona suave
- [ ] Botões respondem no toque
- [ ] Tarefa aparece na lista

**Notas:**
```
Problemas encontrados:
- 
```

---

### ✅ FASE 3: Templates (2 min)

1. [ ] Menu → Templates
2. [ ] **Lista carrega rápido**
3. [ ] Toque em "Revisar Matéria"
4. [ ] Expande mostrando passos
5. [ ] **Scroll suave na lista**
6. [ ] Toque em "Usar"
7. [ ] Tarefa criada aparece

**Validar:**
- [ ] Animação de expansão suave
- [ ] Tempos estimados visíveis
- [ ] Categorias coloridas corretas

---

### ✅ FASE 4: Breathe Mode (3 min) ⭐ IMPORTANTE

Este é o teste mais crítico para haptics!

1. [ ] Abra tarefa criada
2. [ ] **Breathe aparece**
3. [ ] **SINTA HAPTICS:**
   - [ ] Vibra suave ao inspirar
   - [ ] Vibra ao expirar
4. [ ] Círculo anima suavemente (60fps)
5. [ ] Contador decrementa corretamente
6. [ ] **TESTE SKIP:**
   - Toque "Pular"
   - [ ] Alert aparece
   - [ ] Confirme
   - [ ] **HAPTIC DE WARNING** (vibração diferente)
   - [ ] Console deve mostrar: "⏭️ Breathe PULADO"

**Validar:**
- [ ] Animação do círculo suave
- [ ] Haptics sentem naturais
- [ ] Background sem gradiente (azul sólido)
- [ ] Skip registrado

**Notas:**
```
Haptics:
- Inspirar: Senti / Não senti
- Expirar: Senti / Não senti
- Skip warning: Senti / Não senti
```

---

### ✅ FASE 5: Modo Foco com Timer (5 min) ⭐⭐ CRÍTICO

#### A. Primeiro Passo (15 min estimado)

1. [ ] Passo aparece com ícone
2. [ ] **VEJA:** Badge "Tempo estimado: 15 min (mín: 9min)"
3. [ ] **Progress bar aparece**
4. [ ] Contador 0:00 / 15:00
5. [ ] Marcador aos 60% (laranja)
6. [ ] Botão "Completei" **DESABILITADO** (cinza)
7. [ ] **AGUARDE 5-10 segundos** (ou mais se possível)
8. [ ] Progress bar avança
9. [ ] Contador atualiza (ex: 0:05 / 15:00)
10. [ ] **MENSAGEM MOTIVACIONAL:**
    - [ ] Aparece no topo
    - [ ] Após 15s, faz **FADE OUT**
    - [ ] Nova mensagem **FADE IN**
    - [ ] Transição suave

**Se conseguir aguardar 9 minutos (60%):**
11. [ ] Marcador fica verde
12. [ ] **HAPTIC VIBRA** (pode completar!)
13. [ ] Botão fica azul e habilitado
14. [ ] Toque em "Completei"
15. [ ] **HAPTIC DE SUCCESS**
16. [ ] Animação suave para próximo passo

**OU teste skip:**
- [ ] Toque "Pular este passo" (botão laranja)
- [ ] Alert aparece
- [ ] Confirme
- [ ] **HAPTIC DE WARNING**
- [ ] Console: "⏭️ PASSO PULADO"
- [ ] Próximo passo aparece

**Validar:**
- [ ] Timer conta corretamente
- [ ] Progress bar visual funciona
- [ ] Haptics diferentes (success vs warning)
- [ ] Sem gradientes (cores sólidas)
- [ ] Mensagens trocam a cada 15s
- [ ] Transição fade suave

**Notas:**
```
Timer:
- Contagem precisa: Sim / Não
- Progress bar suave: Sim / Não
- Haptic aos 60%: Sim / Não

Mensagens:
- Rotação 15s: Sim / Não
- Fade out/in: Sim / Não
- Transição suave: Sim / Não

Performance:
- Lag: Sim / Não
- Bateria aquecendo: Sim / Não
```

---

### ✅ FASE 6: Estatísticas (2 min)

1. [ ] Volte para home
2. [ ] Menu → Configurações
3. [ ] Role até "Estatísticas"
4. [ ] **VEJA:**
   - [ ] "Respirações puladas: X" (se pulou)
   - [ ] "Passos pulados: Y" (se pulou)
   - [ ] Cores corretas (laranja se > 0)
5. [ ] Dica adaptativa aparece

**Validar:**
- [ ] Contadores corretos
- [ ] Cores dinâmicas
- [ ] Scroll suave

---

### ✅ FASE 7: Conquistas (2 min)

1. [ ] Menu → Conquistas
2. [ ] Lista carrega
3. [ ] **VEJA:** Conquistas desbloqueadas
4. [ ] Toque em uma conquista
5. [ ] Detalhes aparecem
6. [ ] Animações suaves

**Validar:**
- [ ] Toast de conquista apareceu ao completar? (se sim, anotou?)
- [ ] Progress circular funciona
- [ ] Sem gradientes

---

### ✅ FASE 8: Dashboard/Stats (2 min)

1. [ ] Menu → Estatísticas (tela principal)
2. [ ] **VEJA:** Cards de resumo
3. [ ] Gráfico carrega
4. [ ] **Toque e arraste** no gráfico
5. [ ] Gestures funcionam
6. [ ] Lista de tarefas recentes

**Validar:**
- [ ] Gráfico renderiza bem
- [ ] Touch/gestures naturais
- [ ] Performance OK

---

### ✅ FASE 9: Teste de Stress (2 min)

1. [ ] Crie 5 tarefas rapidamente
2. [ ] Delete 2 tarefas
3. [ ] Entre e saia de várias views
4. [ ] Scroll rápido em listas
5. [ ] Minimize e reabra o app

**Validar:**
- [ ] App não crasha
- [ ] Dados persistem
- [ ] Performance mantém
- [ ] Sem memory leaks aparentes

---

### ✅ FASE 10: Dark Mode (1 min)

1. [ ] Swipe do topo (Control Center)
2. [ ] Ative Dark Mode
3. [ ] Navegue pelo app
4. [ ] **Validar:**
   - [ ] Cores adaptam bem
   - [ ] Textos legíveis
   - [ ] Contraste adequado

---

## 🐛 Bugs Encontrados

### Bug 1:
- **Onde:** 
- **O que acontece:** 
- **Gravidade:** 🔴 Crítico / 🟡 Médio / 🟢 Baixo
- **Reproduz:** Sempre / Às vezes / Raro

### Bug 2:
- **Onde:** 
- **O que acontece:** 
- **Gravidade:** 
- **Reproduz:** 

### Bug 3:
- **Onde:** 
- **O que acontece:** 
- **Gravidade:** 
- **Reproduz:** 

---

## 💡 Observações Gerais

### Performance:
```
- FPS: ___
- Lag percebido: Sim / Não / Onde: ___
- Bateria aquecendo: Sim / Não
- Memory usage aparente: Normal / Alto
```

### Haptics:
```
- Breathe inspire/expire: ⭐⭐⭐⭐⭐
- Success complete: ⭐⭐⭐⭐⭐
- Warning skip: ⭐⭐⭐⭐⭐
- Atingir 60%: ⭐⭐⭐⭐⭐
```

### UI/UX:
```
- Cores sem gradientes: Sim / Não
- Mensagens rotação 15s: Sim / Não
- Transições suaves: Sim / Não
- Botões respondem bem: Sim / Não
```

### Bloqueadores:
```
Lista de problemas que IMPEDEM submissão:
1. 
2. 
3. 
```

---

## ✅ Resultado Final

**Total de testes:** 10 fases  
**Passou:** ___ de 10  
**Bugs críticos:** ___  
**Bugs médios:** ___  
**Bugs baixos:** ___  

**Status:**
- [ ] ✅ Pronto para submissão
- [ ] ⚠️ Precisa correções menores
- [ ] 🔴 Precisa correções críticas

---

## 🚀 Próximos Passos

### Se passou tudo (90%+):
1. ✅ Marcar "Testar features" como completo
2. → Próximo: Criar ícone do app
3. → Depois: Screenshots e video

### Se encontrou bugs:
1. → Listar bugs no arquivo BUGS_ENCONTRADOS.md
2. → Corrigir bugs críticos primeiro
3. → Testar novamente
4. → Depois: Próximas tasks

---

## 📝 Notas Adicionais

```
[Espaço livre para anotações durante o teste]







```

---

**Começe os testes e anote TUDO que encontrar!** 🧪

Especialmente:
- ⭐ Haptics (só funcionam no device real)
- ⭐ Performance (FPS, lag)
- ⭐ Timer preciso (60% rule)
- ⭐ Mensagens 15s com fade
- ⭐ Cores sem gradientes

**Boa sorte!** 🚀
