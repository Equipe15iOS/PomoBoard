//
//  PomoBoardApp.swift
//  PomoBoard
//
//  Created by iredefbmac_31 on 27/04/25.
//

import SwiftUI
import SwiftData

@main
struct PomoBoardApp: App {
    @StateObject private var settings = Settings()
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }		
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
            
        }
        .modelContainer(for: PomodoroSession.self)
    }
}
	
