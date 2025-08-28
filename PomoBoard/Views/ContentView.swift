import SwiftUI
import Charts
import SwiftData


// MARK: - View Principal com TabView
struct ContentView: View {
    
    @ObservedObject var settings = Settings()
    
    init() {
        UITabBar.appearance().unselectedItemTintColor = UIColor.white.withAlphaComponent(1.0)
    }
    
    var body: some View {
        
        NavigationStack {
        
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
    

