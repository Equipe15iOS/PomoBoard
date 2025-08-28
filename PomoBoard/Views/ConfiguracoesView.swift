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
