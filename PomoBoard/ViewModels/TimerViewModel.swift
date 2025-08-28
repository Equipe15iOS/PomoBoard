import SwiftUI

class TimerViewModel: ObservableObject {
    @Published var timeRemaining: Int
    @Published var timerRunning = false
    @Published var progress: Double = 0.0
    
    private var timer: Timer?
    private var totalTime: Int
    
    init(tempoFoco: Int) {
        self.totalTime = tempoFoco * 60
        self.timeRemaining = self.totalTime
    }
    
    func startTimer() {
        guard !timerRunning else { return }
        timerRunning = true
        
        if timeRemaining == 0 || timeRemaining == totalTime {
            timeRemaining = totalTime
            progress = 0.0
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
                self.progress = 1.0 - (Double(self.timeRemaining) / Double(self.totalTime))
            } else {
                self.stopTimer()
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
    
    func updateTempoFoco(_ novoTempo: Int) {
        totalTime = novoTempo * 60
        if !timerRunning {
            timeRemaining = totalTime
            progress = 0.0
        }
    }
}
