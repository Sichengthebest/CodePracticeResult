//
//  ChatOllama_2App.swift
//  ChatOllama 2
//
//  Created by Sicheng Jiang on 2024-06-15.
//

import SwiftUI
import SwiftData

@main
struct ChatOllama_2App: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Dialogue.self,
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
                .frame(minWidth: 100, idealWidth: 200)
        }
        .modelContainer(sharedModelContainer)
    }
}
