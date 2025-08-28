import SwiftUI
import Charts

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
