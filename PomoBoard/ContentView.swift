import SwiftUI
import Charts

class Settings: ObservableObject {
    @Published var tempoFoco: Int = 25
    @Published var pausaCurta: Int = 5
    @Published var pausaLonga: Int = 15
    @Published var ciclosRodada: Int = 4
    @Published var naoPerturbe: Bool = false
    @Published var silenciarNotificacoes: Bool = false
}

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
    
    @ObservedObject var settings = Settings()

    init() {
        UITabBar.appearance().unselectedItemTintColor = UIColor.white.withAlphaComponent(1.0)
    }
    
    var body: some View {
        TabView {
            HomeView(settings: settings)
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
            
            ConfiguracoesView(settings: settings)
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
    @ObservedObject var settings: Settings
    
    @State private var timeRemaining: Int = 0
    @State private var timerRunning = false
    @State private var progress: Double = 0.0
    @State private var timer: Timer?

    var totalTime: Int {
        settings.tempoFoco * 60
    }
    
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

            Button(timerRunning ? "PAUSAR" : (timeRemaining < totalTime ? "RETOMAR" : "COMEÇAR")) {
                timerRunning ? pauseTimer() : startTimer()
            }
            .padding()
            .font(.system(size: 24, weight: .bold))
            .foregroundColor(.white)
            .background(Color(hex: "#6B3D00"))
            .clipShape(Capsule())
            .padding(.bottom, 40)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.orange.ignoresSafeArea())
        .onAppear {
            timeRemaining = totalTime
            progress = 0.0
        }
        .onChange(of: settings.tempoFoco) { oldValue, newValue in
            if !timerRunning {
                timeRemaining = newValue * 60
                progress = 0.0
            }
        }
    }
    
    // Funções do Timer
    func startTimer() {
        guard !timerRunning else { return }
        timerRunning = true

        if timeRemaining == 0 || timeRemaining == totalTime {
            timeRemaining = totalTime
            progress = 0.0
        }

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
                progress = 1.0 - (Double(timeRemaining) / Double(totalTime))
            } else {
                stopTimer()
            }
        }
    }
    
    func pauseTimer() {
        timer?.invalidate()
        timer = nil
        timerRunning = false
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        timerRunning = false
        timeRemaining = totalTime
        progress = 0.0
    }

    func formatTime(_ seconds: Int) -> String {
        String(format: "%02d:%02d", seconds / 60, seconds % 60)
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
import SwiftUI

struct ConfiguracoesView: View {
    @ObservedObject var settings: Settings

    var body: some View {
        NavigationView {
            ZStack {
                Color.orange.ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {

                        // Título
                        Text("Configurações")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                            .padding(.horizontal)

                        // Seção Ajustar Foco
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Ajustar Foco")
                                .font(.title2)
                                .bold()

                            Text("Personalize sua rotina de foco e pausas")
                                .font(.subheadline)
                                .foregroundColor(.gray)

                            ajusteView(titulo: "Tempo de foco (min)", valor: $settings.tempoFoco)
                            ajusteView(titulo: "Pausa curta (min)", valor: $settings.pausaCurta)
                            ajusteView(titulo: "Pausa longa (min)", valor: $settings.pausaLonga)
                            ajusteView(titulo: "Ciclos por rodada", valor: $settings.ciclosRodada)
                        }
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(12)
                        .padding(.horizontal)

                        // Card Personalizar Alarmes
                        NavigationLink(destination: Text("Tela de Personalizar Alarmes")) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Personalizar alarmes")
                                        .font(.headline)
                                        .foregroundColor(.black)
                                    Text("Escolha o som dos alarmes")
                                        .font(.subheadline)
                                        .foregroundColor(Color(white: 0.2))
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(15)
                            .padding(.horizontal)
                        }

                        // Toggle "Não Perturbe"
                        VStack {
                            Toggle(isOn: $settings.naoPerturbe) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Não perturbe")
                                        .font(.headline)
                                    Text("Bloqueie distrações durante o foco")
                                        .font(.subheadline)
                                        .foregroundColor(Color(white: 0.2))
                                }
                            }
                            .toggleStyle(SwitchToggleStyle(tint: .orange))
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)

                        // Toggle "Silenciar notificações"
                        VStack {
                            Toggle(isOn: $settings.silenciarNotificacoes) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Silenciar notificações")
                                        .font(.headline)
                                    Text("Desative alertas sonoros")
                                        .font(.subheadline)
                                        .foregroundColor(Color(white: 0.2))
                                }
                            }
                            .toggleStyle(SwitchToggleStyle(tint: .orange))
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)

                        Spacer(minLength: 40)
                    }
                    .padding(.top)
                }

                .navigationBarHidden(true)
            }
        }
    }
}


    
    func ajusteView(titulo: String, valor: Binding<Int>) -> some View {
        HStack {
            Text(titulo)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Button(action: {
                if valor.wrappedValue > 0 {
                    valor.wrappedValue -= 1
                }
            }) {
                Image(systemName: "minus")
                    .padding(6)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(Circle())
            }
            
            Text("\(valor.wrappedValue)")
                .frame(width: 30)
                .multilineTextAlignment(.center)
            
            Button(action: {
                valor.wrappedValue += 1
            }) {
                Image(systemName: "plus")
                    .padding(6)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(Circle())
            }
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
    }

    
    // MARK: - Preview
    #Preview {
        ContentView()
    }
    

