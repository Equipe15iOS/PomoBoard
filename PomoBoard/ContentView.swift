import SwiftUI
import Charts

// MARK: - Extensões e Modelos de Dados
// Extensão para permitir o uso de cores hexadecimais
extension Color {
    init(hex: String) {
        var cleanHexCode = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        cleanHexCode = cleanHexCode.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        
        Scanner(string: cleanHexCode).scanHexInt64(&rgb)
        
        let redValue = Double((rgb >> 16) & 0xFF) / 255.0
        let greenValue = Double((rgb >> 8) & 0xFF) / 255.0
        let blueValue = Double(rgb & 0xFF) / 255.0
        self.init(red: redValue, green: greenValue, blue: blueValue)
    }
}

// Modelo de dados para Tarefas
struct Tarefa: Identifiable {
    let id = UUID()
    let titulo: String
    let data: String
    let diaSemana: String
}

// Modelo de dados para Estatísticas
struct EstatisticaDia: Identifiable {
    let id = UUID()
    let dia: String
    let horas: Int
    let cor: Color
}


// MARK: - View Principal com TabView
struct ContentView: View {
    
    init() {
        UITabBar.appearance().unselectedItemTintColor = UIColor.white.withAlphaComponent(1.0)
    }
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }

            TarefasView()
                .tabItem {
                    Image(systemName: "list.bullet.rectangle.portrait")
                    Text("Tarefas")
                }

            EstatisticasView()
                .tabItem {
                    Image(systemName: "chart.bar.xaxis")
                    Text("Estatísticas")
                }
            
            ConfiguracoesView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Ajustes")
                }
        }
        .toolbarBackground(Color.orange, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
        .accentColor(Color(hex: "#6B3D00"))
    }
}


// MARK: - Aba 1: Home (Pomodoro Timer)
struct HomeView: View {
    // Propriedades do Timer
    @State private var timeRemaining = 25 * 60
    @State private var timerRunning = false
    @State private var progress: Double = 0.0
    @State private var timer: Timer?
    let totalTime: Double = 25 * 60

    var body: some View {
        VStack {
            // Cabeçalho
            Text("PomoBoard")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top, 40)

            Spacer()

            Text(formatTime(timeRemaining))
                .font(.system(size: 64, weight: .bold))
                .foregroundColor(.white)

            ZStack {
                Circle()
                    .stroke(Color(hex: "#6B3D00").opacity(0.3), lineWidth: 8)

                Circle()
                    .trim(from: 0.0, to: progress)
                    .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .foregroundColor(Color(hex: "#6B3D00"))
                    .rotationEffect(Angle(degrees: -90))
                    .animation(.linear, value: progress)
                
                Image("caju")
                    .resizable()
                    .scaledToFit()
            }
            .frame(width: 256, height: 256)
            .padding(.bottom, 25)

            Button(timerRunning ? "INICIADO..." : "COMEÇAR") {
                startTimer()
            }
            .padding()
            .font(.system(size: 24, weight: .bold))
            .foregroundColor(.white)
            .background(Color(hex: "#6B3D00"))
            .clipShape(Capsule())
            .padding(.bottom, 40)
            .disabled(timerRunning)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.orange.ignoresSafeArea())
    }
    
    // Funções do Timer
    func startTimer() {
        guard !timerRunning else { return }
        timeRemaining = Int(totalTime)
        progress = 0.0
        timerRunning = true

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
                progress = 1.0 - (Double(timeRemaining) / totalTime)
            } else {
                stopTimer()
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
        timerRunning = false
    }

    func formatTime(_ seconds: Int) -> String {
        return String(format: "%02d:%02d", seconds / 60, seconds % 60)
    }
}


// MARK: - Aba 2: Lista de Tarefas
struct TarefasView: View {
    let tarefas: [Tarefa] = [
        Tarefa(titulo: "Fazer simulado de Matemática", data: "20.07", diaSemana: "Dom"),
        Tarefa(titulo: "Responder e-mails pendentes", data: "25.07", diaSemana: "Sex"),
        Tarefa(titulo: "Praticar exercícios de violão", data: "30.07", diaSemana: "Qua")
    ]
    
    var body: some View {
        VStack {
            Text("Tarefas Diárias")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.white)
                .padding(.top, 40)
                .padding(.horizontal)

            ForEach(tarefas) { tarefa in
                HStack {
                    Text(tarefa.titulo)
                        .font(.headline)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                    Spacer()
                    VStack {
                        Text(tarefa.data)
                            .font(.subheadline)
                            .bold()
                        Text(tarefa.diaSemana)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 2)
                .padding(.horizontal)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.orange.ignoresSafeArea())
    }
}


// MARK: - Aba 3: Gráfico de Estatísticas
struct EstatisticasView: View {
    let dadosSemana: [EstatisticaDia] = [
        EstatisticaDia(dia: "Dom", horas: 2, cor: .green),
        EstatisticaDia(dia: "Seg", horas: 4, cor: .green),
        EstatisticaDia(dia: "Ter", horas: 0, cor: .orange),
        EstatisticaDia(dia: "Qua", horas: 6, cor: .red),
        EstatisticaDia(dia: "Qui", horas: 5, cor: .red),
        EstatisticaDia(dia: "Sex", horas: 1, cor: .green),
        EstatisticaDia(dia: "Sab", horas: 0, cor: .gray)
    ]

    var body: some View {
        VStack {
            Text("Estatísticas")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top, 40)
                .padding(.horizontal)
            Text("Semanais")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.horizontal)
            Chart {
                ForEach(dadosSemana) { dado in
                    BarMark(
                        x: .value("Dia", dado.dia),
                        y: .value("Horas", dado.horas)
                    )
                    .foregroundStyle(dado.cor)
                    .annotation(position: .top) {
                        Text("\(dado.horas)")
                            .font(.caption)
                            .foregroundColor(.primary)
                    }
                }
            }
            .frame(height: 250)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.orange.ignoresSafeArea())
    }
}


// MARK: - Aba 4: Configurações (Placeholder)
struct ConfiguracoesView: View {
    var body: some View {
        ZStack {
            Color.orange.ignoresSafeArea()
            Text("Tela de Configurações")
                .font(.largeTitle)
                .foregroundColor(.white)
        }
    }
}


// MARK: - Preview
#Preview {
    ContentView()
}
