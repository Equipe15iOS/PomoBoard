import SwiftUI

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

// MARK: - View Principal
struct ContentView: View {
    // MARK: Properties
    @State private var showMenu = false
    
    // Propriedades do Timer
    @State private var timeRemaining = 25 * 60
    @State private var timerRunning = false
    @State private var progress: Double = 0.0
    @State private var timer: Timer?
    let totalTime: Double = 25 * 60

    // MARK: Body
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Tela principal com a lógica do timer
                mainView

                // Fundo escuro clicável para fechar o menu
                if showMenu {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                showMenu = false
                            }
                        }
                }

                // Menu lateral (40% da largura da tela)
                if showMenu {
                    SideMenuView()
                        .frame(width: geometry.size.width * 0.4)
                        .transition(.move(edge: .leading))
                        .zIndex(1)
                }
            }
            .animation(.easeInOut(duration: 0.25), value: showMenu)
        }
    }

    // MARK: Main View Content
    var mainView: some View {
        VStack {
            // Cabeçalho com botão de menu
            HStack {
                Button(action: {
                    withAnimation {
                        showMenu.toggle()
                    }
                }) {
                    Image(systemName: "line.horizontal.3")
                        .font(.title)
                        .foregroundColor(.black)
                }
                .padding(.leading, 20)
                Spacer()
            }
            .padding(.top, 40)

            Spacer()

            // Display do tempo formatado
            Text(formatTime(timeRemaining))
                .font(.system(size: 64, weight: .bold))
                .foregroundColor(.white)

            // Círculo de progresso com a imagem
            ZStack {
                // Círculo de fundo
                Circle()
                    .stroke(Color(hex: "#6B3D00").opacity(0.3), lineWidth: 8)

                // Círculo de progresso dinâmico
                Circle()
                    .trim(from: 0.0, to: progress)
                    .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .foregroundColor(Color(hex: "#6B3D00"))
                    .rotationEffect(Angle(degrees: -90))
                    .animation(.linear, value: progress)
                
                // Imagem do caju
                Image(.caju)
                    .resizable()
                    .scaledToFit()
            }
            .frame(width: 256, height: 256)
            .padding(.bottom, 25)

            // Botão para iniciar o timer
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
        .background(Color.orange)
        .ignoresSafeArea()
    }
    
    // MARK: - Funções do Timer
    func startTimer() {
        guard !timerRunning else { return }
        
        // Reseta o estado ao iniciar
        timeRemaining = Int(totalTime)
        progress = 0.0
        timerRunning = true

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
                progress = 1.0 - (Double(timeRemaining) / totalTime)
            } else {
                stopTimer() // Para o timer quando o tempo acaba
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

// MARK: - Menu Lateral
struct SideMenuView: View {
    var body: some View {
        ZStack(alignment: .topLeading) {
            // Cor de fundo usando o código hexadecimal
            Color(hex: "#6B3D00")
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 30) {
                Spacer().frame(height: 100)

                Button("Tarefas do Dia") { /* ação */ }
                    .foregroundColor(.white)
                    .font(.headline)

                Button("Sessão Diária") { /* ação */ }
                    .foregroundColor(.white)
                    .font(.headline)

                Spacer()
                
                Button("Estatísticas da Semana") { /* ação */ }
                    .foregroundColor(.white)
                    .font(.headline)
                
                Button { /* ação */ } label: {
                    HStack {
                        Image(systemName: "gearshape")
                    }
                    .foregroundColor(.white)
                }
                .padding(.bottom, 30)
            }
            .padding(.horizontal, 20)
        }
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}
