# 🚀 Como Executar o Projeto Clarity

## ❌ Erro: "A build only device cannot be used to run this target"

Este erro acontece quando você tenta executar o app em **"Any iOS Device"** em vez de um simulador ou dispositivo específico.

---

## ✅ SOLUÇÃO RÁPIDA

### Passo 1: Abrir o Projeto

```bash
open /Users/ulpionetto/Projects/ClarityApp/Clarity/Clarity.xcodeproj
```

### Passo 2: Selecionar um Simulador

No **topo da janela do Xcode**, ao lado do botão de Play (▶️):

1. Clique no menu suspenso onde está escrito algo como:
   - "Any iOS Device (arm64)"
   - "My Mac (Designed for iPad)"

2. No menu que abrir, selecione um simulador:
   ```
   iOS Simulators
   ├── iPhone 15 Pro
   ├── iPhone 15
   ├── iPhone 14 Pro
   ├── iPhone 14
   ├── iPhone SE (3rd generation)
   └── iPad Pro (12.9-inch)
   ```

3. Escolha qualquer **iPhone** (recomendado: iPhone 15)

### Passo 3: Executar

- Pressione **⌘R** ou
- Clique no botão **▶️ (Play)**

---

## 🎯 Atalhos do Xcode

| Ação | Atalho |
|------|--------|
| Build e Executar | ⌘R |
| Parar | ⌘. |
| Limpar Build | ⌘⇧K |
| Selecionar Destino | ⌘⇧, |
| Abrir Preferências | ⌘, |

---

## 📱 Se Não Houver Simuladores Disponíveis

### 1. Verificar Instalação do Xcode

No Xcode, vá em:
```
Xcode → Settings → Platforms
```

Certifique-se de que **iOS** está instalado.

### 2. Baixar Simuladores Adicionais

1. Abra **Xcode**
2. Menu: **Xcode → Settings** (⌘,)
3. Vá na aba **Platforms**
4. Clique no **+** para adicionar simuladores
5. Baixe **iOS 17.0** ou superior

### 3. Criar Novo Simulador

1. Abra o app **Simulator** (pode buscar no Spotlight)
2. Menu: **File → New Simulator**
3. Escolha:
   - **Device Type:** iPhone 15
   - **OS Version:** iOS 17.0 ou superior
4. Clique em **Create**

---

## 🔧 Se o Problema Persistir

### Verificar Xcode Command Line Tools

```bash
# Ver caminho atual
xcode-select -p

# Se aparecer "/Library/Developer/CommandLineTools", mude para:
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer

# Verificar novamente
xcode-select -p
# Deve mostrar: /Applications/Xcode.app/Contents/Developer
```

### Limpar Cache do Xcode

```bash
# Fechar o Xcode primeiro, depois:
rm -rf ~/Library/Developer/Xcode/DerivedData
rm -rf ~/Library/Caches/com.apple.dt.Xcode
```

Depois abra o Xcode novamente.

---

## 🎬 Passo a Passo Visual

### 1️⃣ Local do Seletor de Destino
```
╔════════════════════════════════════════╗
║  ◀ ▶  [Clarity > iPhone 15] ▼   ▶️ ⏹  ║  ← Clique aqui
╠════════════════════════════════════════╣
║                                        ║
║         (Código do Projeto)            ║
║                                        ║
╚════════════════════════════════════════╝
```

### 2️⃣ Menu de Seleção
Quando clicar, verá algo como:
```
┌─────────────────────────────────┐
│ Clarity                         │
│                                 │
│ iOS Simulators                  │
│  ✓ iPhone 15                    │ ← Selecione um destes
│    iPhone 15 Pro                │
│    iPhone 14                    │
│    iPad Pro                     │
│                                 │
│ iOS Devices                     │
│    Any iOS Device (arm64)       │ ← NÃO use este!
└─────────────────────────────────┘
```

---

## ⚡ Execução Rápida

Para quem tem pressa:

```bash
# 1. Abrir projeto
open /Users/ulpionetto/Projects/ClarityApp/Clarity/Clarity.xcodeproj

# 2. No Xcode:
#    - Clique no menu ao lado do Play
#    - Escolha "iPhone 15"
#    - Pressione ⌘R
```

---

## 🎯 Configuração do Projeto

O app Clarity está configurado para:
- **Plataforma:** iOS
- **Versão Mínima:** iOS 17.0
- **Dispositivos:** iPhone e iPad
- **Orientação:** Portrait

---

## 📋 Checklist Antes de Executar

- [ ] Xcode 15.0 ou superior instalado
- [ ] Projeto aberto no Xcode
- [ ] Simulador iOS selecionado (não "Any iOS Device")
- [ ] Scheme "Clarity" selecionado
- [ ] Sem erros de compilação no navegador

---

## 🐛 Problemas Comuns

### "No devices available"
- Instale simuladores no Xcode Settings → Platforms

### "Command line tools not found"
- Execute: `sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer`

### "Signing for Clarity requires a development team"
- Abra o projeto
- Clique em **Clarity** no navegador
- Em **Signing & Capabilities**
- Selecione seu **Team** ou marque **Automatically manage signing**

### Build falha com erros estranhos
- Limpe o build: ⌘⇧K
- Feche e reabra o Xcode
- Delete DerivedData (ver comando acima)

---

## ✅ Resultado Esperado

Quando executar corretamente:

1. ✅ Xcode compila o projeto (barra de progresso)
2. ✅ Simulador abre automaticamente
3. ✅ App "Clarity" aparece no simulador
4. ✅ Você vê a tela inicial: "O que você quer estudar hoje?"

---

## 🎉 Primeira Execução

Na primeira vez que o app abrir:

1. Você verá a tela vazia com a mensagem:
   ```
   📚 O que você quer estudar hoje?
   ```

2. Clique em **"Criar primeira tarefa"**

3. Teste o fluxo:
   - Criar uma tarefa (ex: "Matemática")
   - Adicionar passos (ex: "Abrir caderno", "Ler página 10")
   - Clicar em **Criar**
   - Na lista, clicar na tarefa
   - Ver o modo foco com um passo por vez
   - Completar os passos
   - Ver a tela de conclusão

---

## 📱 Simuladores Recomendados

Para melhor experiência de teste:

- **iPhone 15** - Tela padrão moderna
- **iPhone 15 Pro Max** - Tela grande
- **iPhone SE (3rd gen)** - Tela pequena
- **iPad Pro 12.9"** - Tablet

Teste em diferentes tamanhos para validar o layout!

---

## 🆘 Precisa de Ajuda?

Se ainda tiver problemas:

1. Verifique se tem Xcode 15+ instalado
2. Reinicie o Mac
3. Desinstale e reinstale o Xcode (se necessário)
4. Verifique se tem espaço em disco (Xcode precisa de ~15GB)

---

**Criado em:** 30 de janeiro de 2026  
**Projeto:** Clarity - Swift Student Challenge 2026
