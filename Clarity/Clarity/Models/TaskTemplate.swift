//
//  TaskTemplate.swift
//  Clarity
//
//  Pre-built task templates
//

import Foundation
import SwiftUI

struct TaskTemplate: Identifiable {
    let id = UUID()
    let title: String
    let category: String // Nome da categoria
    let steps: [(description: String, minutes: Int)]
    let icon: String
    let description: String
    
    // Templates educacionais
    static let templates: [TaskTemplate] = [
        // Estudos
        TaskTemplate(
            title: "Revisar Matéria",
            category: "Estudos",
            steps: [
                ("Abrir o material de estudo", 5),
                ("Ler o resumo do último capítulo", 15),
                ("Fazer anotações importantes", 10),
                ("Resolver 3 exercícios", 20),
                ("Revisar conceitos difíceis", 10)
            ],
            icon: "book.fill",
            description: "Método estruturado para revisar conteúdo"
        ),
        
        TaskTemplate(
            title: "Aprender Conceito Novo",
            category: "Estudos",
            steps: [
                ("Ler a introdução do tema", 10),
                ("Assistir vídeo explicativo (10 min)", 10),
                ("Fazer resumo com palavras-chave", 15),
                ("Criar um exemplo prático", 15),
                ("Explicar para si mesmo em voz alta", 10)
            ],
            icon: "lightbulb.fill",
            description: "Aprenda de forma mais efetiva"
        ),
        
        TaskTemplate(
            title: "Fazer Lição de Casa",
            category: "Estudos",
            steps: [
                ("Organizar material necessário", 5),
                ("Ler o enunciado com atenção", 10),
                ("Fazer os exercícios mais fáceis", 20),
                ("Tentar os exercícios difíceis", 30),
                ("Revisar as respostas", 10)
            ],
            icon: "pencil",
            description: "Lição de casa sem procrastinar"
        ),
        
        TaskTemplate(
            title: "Preparar para Prova",
            category: "Estudos",
            steps: [
                ("Listar os tópicos da prova", 10),
                ("Revisar anotações de aula", 20),
                ("Fazer exercícios anteriores", 30),
                ("Marcar dúvidas para tirar", 10),
                ("Fazer simulado rápido", 20)
            ],
            icon: "doc.text.fill",
            description: "Prepare-se com confiança"
        ),
        
        // Trabalho
        TaskTemplate(
            title: "Começar Projeto",
            category: "Trabalho",
            steps: [
                ("Definir o objetivo principal", 10),
                ("Listar tarefas necessárias", 15),
                ("Escolher por onde começar", 5),
                ("Fazer a primeira ação", 20),
                ("Celebrar o início", 5)
            ],
            icon: "flag.fill",
            description: "Comece qualquer projeto sem travar"
        ),
        
        TaskTemplate(
            title: "Organizar Emails",
            category: "Trabalho",
            steps: [
                ("Abrir caixa de entrada", 2),
                ("Responder emails urgentes", 15),
                ("Arquivar emails resolvidos", 10),
                ("Marcar pendências para depois", 5),
                ("Limpar spam", 5)
            ],
            icon: "envelope.fill",
            description: "Inbox zero em minutos"
        ),
        
        // Saúde
        TaskTemplate(
            title: "Exercício Rápido",
            category: "Saúde",
            steps: [
                ("Vestir roupa confortável", 3),
                ("Alongar por 2 minutos", 2),
                ("Fazer 10 agachamentos", 3),
                ("Fazer 10 flexões", 3),
                ("Respirar fundo e relaxar", 2)
            ],
            icon: "figure.walk",
            description: "Movimente-se em 10 minutos"
        ),
        
        TaskTemplate(
            title: "Pausa para Descanso",
            category: "Saúde",
            steps: [
                ("Levantar da cadeira", 1),
                ("Beber um copo d'água", 2),
                ("Alongar pescoço e ombros", 3),
                ("Olhar para longe por 1 minuto", 1),
                ("Respirar profundamente 3 vezes", 2)
            ],
            icon: "heart.fill",
            description: "Cuide de você durante o dia"
        ),
        
        // Pessoal
        TaskTemplate(
            title: "Começar o Dia Bem",
            category: "Pessoal",
            steps: [
                ("Arrumar a cama", 5),
                ("Beber água", 2),
                ("Tomar café da manhã", 15),
                ("Listar 3 coisas do dia", 5),
                ("Vestir-se", 10)
            ],
            icon: "sun.max.fill",
            description: "Rotina matinal energizante"
        ),
        
        TaskTemplate(
            title: "Desacelerar à Noite",
            category: "Pessoal",
            steps: [
                ("Desligar telas", 2),
                ("Organizar amanhã rapidamente", 5),
                ("Lavar o rosto", 5),
                ("Ler ou ouvir música por 10 min", 10),
                ("Deitar no horário", 5)
            ],
            icon: "moon.fill",
            description: "Durma melhor"
        ),
        
        // Casa
        TaskTemplate(
            title: "Organizar Espaço",
            category: "Casa",
            steps: [
                ("Escolher uma área pequena", 3),
                ("Remover o que não pertence", 10),
                ("Limpar superfícies", 10),
                ("Organizar objetos", 15),
                ("Admirar o resultado", 2)
            ],
            icon: "sparkles",
            description: "Organize sem overwhelm"
        ),
        
        // Criativo
        TaskTemplate(
            title: "Momento Criativo",
            category: "Criativo",
            steps: [
                ("Separar materiais", 5),
                ("Definir tema ou ideia", 5),
                ("Começar sem julgar", 5),
                ("Criar livremente por 15 min", 15),
                ("Guardar ou compartilhar", 5)
            ],
            icon: "paintbrush.fill",
            description: "Expresse sua criatividade"
        )
    ]
    
    // Agrupar por categoria
    static var grouped: [String: [TaskTemplate]] {
        Dictionary(grouping: templates) { $0.category }
    }
}
