import SwiftUI

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
