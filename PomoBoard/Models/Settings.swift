import SwiftUI
import Combine

class Settings: ObservableObject {
    @Published var tempoFoco: Int = 25
    @Published var pausaCurta: Int = 5
    @Published var pausaLonga: Int = 15
    @Published var ciclosRodada: Int = 4
    @Published var naoPerturbe: Bool = false
    @Published var silenciarNotificacoes: Bool = false
}
