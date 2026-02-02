# 🏝️ Como Configurar Dynamic Island - Passo a Passo

**⏱️ Tempo estimado:** 5 minutos  
**📱 Requisito:** iPhone 14 Pro+ ou simulador

---

## 🎯 Checklist Rápido

```
[ ] 1. Abrir Xcode
[ ] 2. Adicionar Capability "Push Notifications"
[ ] 3. Adicionar "NSSupportsLiveActivities" ao Info.plist
[ ] 4. Adicionar arquivos ao projeto (se necessário)
[ ] 5. Build e testar
```

---

## 📋 Passo 1: Abrir o Projeto

1. Abra **Xcode**
2. Abra o projeto: `ClarityApp/Clarity/Clarity.xcodeproj`
3. Aguarde o Xcode indexar

---

## 📋 Passo 2: Adicionar Push Notifications

### **Por que?**
Live Activities usam a infraestrutura de push notifications (mas não enviam notificações).

### **Como:**

1. Na sidebar esquerda, clique no **projeto Clarity** (ícone azul no topo)
2. Selecione o **target "Clarity"**
3. Clique na aba **"Signing & Capabilities"**
4. Clique no botão **"+ Capability"** (no canto superior esquerdo)
5. Procure por **"Push Notifications"**
6. Clique duas vezes para adicionar

**Resultado esperado:**
```
✅ Push Notifications (Section aparece nas capabilities)
```

---

## 📋 Passo 3: Adicionar Suporte a Live Activities

### **Por que?**
Informa ao iOS que o app suporta Live Activities.

### **Como:**

#### **Opção A: Via Interface (Recomendado)**

1. Ainda nas **"Signing & Capabilities"**
2. Role até encontrar a seção **"Info"** (ou clique na aba "Info")
3. Expanda **"Custom iOS Target Properties"**
4. Passe o mouse sobre qualquer linha e clique no **+** que aparece
5. Digite: `NSSupportsLiveActivities`
6. Type: `Boolean`
7. Value: `YES`

#### **Opção B: Editar XML Direto**

1. No navegador de arquivos, encontre **"Info.plist"** (pode estar oculto)
2. Abra como **"Source Code"** (botão direito → Open As → Source Code)
3. Adicione antes do `</dict>` final:

```xml
<key>NSSupportsLiveActivities</key>
<true/>
```

4. Salve (Cmd+S)

**Resultado esperado:**
```
✅ Info.plist contém NSSupportsLiveActivities = YES
```

---

## 📋 Passo 4: Verificar Arquivos no Projeto

### **Arquivos que devem estar presentes:**

```
Clarity/
├── Clarity/
│   ├── LiveActivities/
│   │   ├── StudyActivityAttributes.swift ✅
│   │   └── StudyLiveActivity.swift ✅
│   ├── Managers/
│   │   └── LiveActivityManager.swift ✅
│   └── Views/
│       └── FocusViewEnhanced.swift (modificado) ✅
```

### **Como verificar:**

1. Na sidebar esquerda do Xcode
2. Expanda a pasta **"Clarity"**
3. Procure pelas pastas:
   - `LiveActivities/` (2 arquivos)
   - `Managers/` (deve conter `LiveActivityManager.swift`)

### **Se os arquivos NÃO aparecerem:**

1. Botão direito na pasta **"Clarity"** (azul)
2. **Add Files to "Clarity"...**
3. Navegue até o diretório do projeto
4. Selecione:
   - `Clarity/LiveActivities/` (pasta inteira)
   - `Clarity/Managers/LiveActivityManager.swift`
5. Certifique-se:
   - ✅ **"Copy items if needed"** está marcado
   - ✅ **Target "Clarity"** está selecionado
6. Clique **"Add"**

**Resultado esperado:**
```
✅ Arquivos aparecem na sidebar do Xcode
✅ Arquivos têm ícone azul (não cinza)
```

---

## 📋 Passo 5: Build e Testar

### **Build:**

1. Selecione um **device/simulador** no topo:
   - Para testar Dynamic Island: **iPhone 14 Pro** ou superior
   - Simulador: escolha "iPhone 15 Pro" ou "iPhone 14 Pro"

2. Clique **Product → Build** (ou Cmd+B)

3. Aguarde a compilação

**Resultado esperado:**
```
✅ Build Succeeded
✅ Sem erros de compilação
```

### **Erros Comuns:**

#### **Erro: "ActivityKit not found"**
**Solução:**
- Deployment Target deve ser >= iOS 16.1
- Em "Signing & Capabilities" → "Deployment Info" → "Minimum Deployments" = iOS 16.1 ou superior

#### **Erro: "NSSupportsLiveActivities not found"**
**Solução:**
- Verifique se adicionou corretamente no Passo 3
- Limpe o build: Product → Clean Build Folder (Cmd+Shift+K)

---

## 📋 Passo 6: Testar no Device/Simulador

### **Executar o App:**

1. Clique em **Product → Run** (ou Cmd+R)
2. Aguarde o app abrir

### **Testar Dynamic Island:**

1. **Crie uma tarefa:**
   - Toque no **+**
   - Título: "Matemática"
   - Adicione 3 passos:
     - "Abrir caderno" (5 min)
     - "Fazer exercícios" (15 min)
     - "Revisar" (10 min)
   - Toque **"Criar"**

2. **Inicie o modo foco:**
   - Toque na tarefa criada
   - Pule o breathe (ou aguarde 30s)
   - **OBSERVE A DYNAMIC ISLAND** 🏝️

3. **Valide:**
   - ✅ Dynamic Island apareceu?
   - ✅ Mostra "1/3" no lado esquerdo?
   - ✅ Mostra timer no lado direito (se houver tempo estimado)?

4. **Toque na Dynamic Island:**
   - ✅ Expandiu mostrando detalhes?
   - ✅ Vê o nome da tarefa?
   - ✅ Vê a barra de progresso?

5. **Minimize o app** (swipe up):
   - ✅ Dynamic Island continua visível?
   - ✅ Timer continua atualizando?

6. **Volte ao app e complete um passo:**
   - Aguarde 60% do tempo (ou pule)
   - Toque **"Completei este passo"**
   - ✅ Dynamic Island atualizou para "2/3"?

7. **Complete todos os passos:**
   - ✅ Dynamic Island mostra "Tarefa completa! 🎉"?
   - ✅ Desaparece após alguns segundos?

---

## 🎥 Demonstração Visual

### **Compact Mode (Fechado):**
```
╔════════════════════════════╗
║ [✓] 3/5     ⏱️ 2:30      ║
╚════════════════════════════╝
```

### **Expanded Mode (Toque):**
```
╔══════════════════════════════════════╗
║  📖 Matemática         ⏱️ 2:30       ║
║      Passo 3/5               Pronto! ║
║                                      ║
║  Fazer exercícios de cálculo         ║
║                                      ║
║  Progresso                    60%    ║
║  ██████████░░░░░░░░                  ║
╚══════════════════════════════════════╝
```

---

## 🐛 Troubleshooting

### **Problema: Dynamic Island não aparece**

**Checklist:**
- [ ] Rodando no iPhone 14 Pro+ ou simulador compatível?
- [ ] iOS >= 16.2?
- [ ] `NSSupportsLiveActivities` está no Info.plist?
- [ ] Push Notifications capability adicionada?
- [ ] Build successful sem erros?

**Se ainda não aparecer:**
1. Vá em **Settings** (Ajustes) do device
2. Procure por **"Live Activities"**
3. Certifique-se que está **habilitado** (ON)
4. Reinicie o app

### **Problema: Live Activity não atualiza**

**Checklist:**
- [ ] Timer está rodando? (veja o contador na tela principal)
- [ ] `liveActivityManager` foi inicializado?
- [ ] Veja logs no console: procure por "🔄 Live Activity updated"

**Solução:**
1. No console do Xcode, procure por:
   ```
   ✅ Live Activity started: [ID]
   🔄 Live Activity updated: Step X/Y
   ```
2. Se não aparecer, verifique se `#available(iOS 16.2, *)` está sendo satisfeito

### **Problema: Simulador não tem Dynamic Island**

**Solução:**
1. Vá em **Window → Devices and Simulators**
2. Delete o simulador atual
3. Crie um novo: **iPhone 15 Pro** ou **iPhone 14 Pro**
4. Rode novamente

### **Problema: Live Activity aparece mas sem cores/formatação**

**Solução:**
- Isso é esperado no simulador às vezes
- Teste no **device real** para ver a aparência correta

---

## ✅ Checklist Final

```
[ ] ✅ Push Notifications capability adicionada
[ ] ✅ NSSupportsLiveActivities = YES no Info.plist
[ ] ✅ Arquivos LiveActivities/* no projeto
[ ] ✅ Build successful
[ ] ✅ Dynamic Island aparece ao iniciar tarefa
[ ] ✅ Timer atualiza em tempo real
[ ] ✅ Progresso atualiza ao completar passos
[ ] ✅ Toque na Dynamic Island expande detalhes
[ ] ✅ Live Activity continua fora do app
[ ] ✅ Live Activity finaliza ao completar tarefa
```

---

## 🎉 Pronto!

Se todos os checkboxes estão marcados, a **Dynamic Island está funcionando perfeitamente!** 🏝️✨

**Próximos passos:**
1. Capture screenshots para a submissão
2. Grave um vídeo mostrando a Dynamic Island em ação
3. Teste em diferentes condições (minimizado, lock screen, etc.)

---

## 📞 Precisa de Ajuda?

Se algo não funcionou, me avise com:
- Screenshots do erro
- Logs do console
- Qual passo falhou

Vou te ajudar a resolver! 🚀
