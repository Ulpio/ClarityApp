# 🗑️ Como Limpar os Dados do App

Se o app estiver preso em uma tela ou com dados antigos, siga estes passos:

## Opção 1: Deletar o App do Simulador (Recomendado)

1. Com o simulador aberto, **pressione e segure** o ícone do app Clarity
2. Clique em **"Remove App"** ou **"Deletar App"**
3. Confirme a exclusão
4. No Xcode, execute novamente (⌘R)

## Opção 2: Resetar Todo o Simulador

No menu do Xcode:
```
Device → Erase All Content and Settings...
```

Ou no Simulator:
```
Device → Erase All Content and Settings...
```

## Opção 3: Via Código (Temporário)

Adicione este código temporariamente no `init()` do `StudyStore`:

```swift
init() {
    // Descomentar para limpar dados
    // UserDefaults.standard.removeObject(forKey: tasksKey)
    loadTasks()
}
```

Depois execute o app uma vez e remova o comentário.

---

**Para o seu caso específico:** Use a Opção 1 (deletar o app do simulador)
