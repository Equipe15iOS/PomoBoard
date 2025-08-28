import SwiftUI   // para Color
import Foundation // para UUID

// Modelo de dados para Estatísticas
struct EstatisticaDia: Identifiable {
    let id = UUID()
    let dia: String
    let horas: Int
    let cor: Color
}
