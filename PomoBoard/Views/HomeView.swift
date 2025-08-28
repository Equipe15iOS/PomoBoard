import SwiftUI

// MARK: - Aba 1: Home (Pomodoro Timer)
struct HomeView: View {
    @ObservedObject var settings: Settings
    @StateObject private var viewModel: TimerViewModel
    
    init(settings: Settings) {
        self.settings = settings
        _viewModel = StateObject(wrappedValue: TimerViewModel(tempoFoco: settings.tempoFoco))
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

            // Tempo
            Text(viewModel.formatTime(viewModel.timeRemaining))
                .font(.system(size: 64, weight: .bold))
                .foregroundColor(.white)

            // Círculo de Progresso
            ZStack {
                Circle()
                    .stroke(Color(hex: "#6B3D00").opacity(0.3), lineWidth: 8)

                Circle()
                    .trim(from: 0.0, to: viewModel.progress)
                    .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .foregroundColor(Color(hex: "#6B3D00"))
                    .rotationEffect(Angle(degrees: -90))
                    .animation(.linear, value: viewModel.progress)
                
                Image("caju")
                    .resizable()
                    .scaledToFit()
            }
            .frame(width: 256, height: 256)
            .padding(.bottom, 25)

            // Botão Start/Pause
            Button(viewModel.timerRunning ? "PAUSAR" : (viewModel.timeRemaining < settings.tempoFoco * 60 ? "RETOMAR" : "COMEÇAR")) {
                viewModel.timerRunning ? viewModel.pauseTimer() : viewModel.startTimer()
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
        .onChange(of: settings.tempoFoco) { _, newValue in
            viewModel.updateTempoFoco(newValue)
        }
    }
}
