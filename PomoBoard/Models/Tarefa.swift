import SwiftUI

// Modelo de dados para Tarefas
struct Tarefa: Identifiable {
    let id = UUID()
    let titulo: String
    let data: String
    let diaSemana: String
}
