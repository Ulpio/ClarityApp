//
//  AddCategoryView.swift
//  Clarity
//
//  Criar ou editar categoria personalizada (nome com emoji, ícone emoji ou símbolo, cor).
//

import SwiftUI
import SwiftData

struct AddCategoryView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Category.order) private var categories: [Category]
    
    @State private var name = ""
    @State private var iconInput = ""
    @State private var selectedSymbol = "star.fill"
    @State private var useEmojiForIcon = true
    @State private var selectedColorHex = "5B9FED"
    
    private var effectiveIcon: String {
        if useEmojiForIcon, !iconInput.trimmingCharacters(in: .whitespaces).isEmpty {
            let trimmed = iconInput.trimmingCharacters(in: .whitespaces)
            if trimmed.count <= 4, trimmed.allSatisfy({ $0.isEmoji }) {
                return trimmed
            }
        }
        return selectedSymbol
    }
    
    private var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Ex: Projeto X, 📚 Leitura", text: $name)
                        .textFieldStyle(.plain)
                        .autocapitalization(.sentences)
                } header: {
                    Text("Nome")
                } footer: {
                    Text("Use emojis no nome se quiser (ex: 📚 Estudos).")
                }
                
                Section {
                    Toggle("Usar emoji como ícone", isOn: $useEmojiForIcon)
                    
                    if useEmojiForIcon {
                        TextField("Ex: 📚 🎯 ✨", text: $iconInput)
                            .textFieldStyle(.plain)
                            .keyboardType(.default)
                    } else {
                        Picker("Símbolo", selection: $selectedSymbol) {
                            ForEach(Category.presetSymbols, id: \.self) { symbol in
                                HStack {
                                    Image(systemName: symbol)
                                    Text(symbol)
                                        .font(.caption)
                                }
                                .tag(symbol)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                } header: {
                    Text("Ícone")
                } footer: {
                    Text(useEmojiForIcon ? "Digite um ou mais emojis (até 4)." : "Escolha um símbolo do sistema.")
                }
                
                Section {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 44))], spacing: 12) {
                        ForEach(Category.presetColors, id: \.hex) { preset in
                            Button {
                                selectedColorHex = preset.hex
                            } label: {
                                Circle()
                                    .fill(Color(hex: preset.hex) ?? .blue)
                                    .frame(width: 44, height: 44)
                                    .overlay(
                                        Circle()
                                            .strokeBorder(selectedColorHex == preset.hex ? Color.primary : Color.clear, lineWidth: 3)
                                    )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical, 8)
                } header: {
                    Text("Cor")
                }
            }
            .navigationTitle("Nova categoria")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Salvar") {
                        saveCategory()
                    }
                    .fontWeight(.semibold)
                    .disabled(!isValid)
                }
            }
        }
    }
    
    private func saveCategory() {
        let nextOrder = (categories.map(\.order).max() ?? -1) + 1
        let category = Category(
            name: name.trimmingCharacters(in: .whitespaces),
            icon: effectiveIcon,
            colorHex: selectedColorHex,
            order: nextOrder,
            isSystemCategory: false
        )
        modelContext.insert(category)
        try? modelContext.save()
        dismiss()
    }
}
