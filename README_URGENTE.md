# 🚨 COMO RESOLVER O PROBLEMA DA TELA TRAVADA

## ⚡ SOLUÇÃO RÁPIDA (3 passos):

### 1️⃣ Pare o App
No Xcode, pressione: **⌘.** (Command + Ponto)

### 2️⃣ Delete o App do Simulador
- No simulador, **pressione e segure** o ícone do Clarity
- Clique em **"Remove App"**
- Confirme

### 3️⃣ Execute Novamente
No Xcode, pressione: **⌘R**

---

## ✅ Resultado Esperado

Você deve ver a tela inicial:

```
     📚
     
O que você quer estudar hoje?

   [Criar primeira tarefa]
```

---

## 🆕 NOVO: Botão de Limpar Dados

Adicionei um **botão vermelho de lixeira (🗑️)** no canto superior esquerdo da HomeView.

Se o app abrir na HomeView mas estiver com dados antigos:
1. Clique no botão 🗑️
2. Todos os dados serão apagados
3. Comece do zero

---

## 🎯 O Que Foi Corrigido

✅ Adicionado logs de debug nos botões  
✅ Criado método `clearAllData()` no StudyStore  
✅ Adicionado botão temporário para limpar dados (modo DEBUG)  
✅ Melhorada a sintaxe dos botões  

---

## 🧪 Teste o Fluxo Completo

1. **Criar tarefa:**
   - Título: "Teste"
   - Passos: "Passo 1", "Passo 2"

2. **Completar passos:**
   - Clique na tarefa
   - Complete cada passo

3. **Testar botões:**
   - ✅ "Voltar" → deve voltar para lista
   - ✅ "Estudar novamente" → deve resetar e voltar

---

## 🔍 Arquivos Modificados

- `CompletionView.swift` - Adicionado logs de debug
- `StudyStore.swift` - Adicionado `clearAllData()`
- `HomeView.swift` - Adicionado botão de limpar (temporário)

---

## 📖 Documentação Completa

Ver arquivo: `SOLUCAO_TELA_TRAVADA.md`

---

**TL;DR:** Delete o app do simulador e execute novamente!
