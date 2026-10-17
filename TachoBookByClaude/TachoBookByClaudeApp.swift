//
//  TachoBookByClaudeApp.swift
//  TachoBookByClaude
//
//  Created by sorlenko on 15/10/2026.
//

import SwiftUI
import SwiftData

@main
struct TachoBookByClaudeApp: App {
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
            #if DEBUG
            if ProcessInfo.processInfo.arguments.contains(DayLogCardDemoScreen.launchArgument) {
                DayLogCardDemoScreen()
            } else {
                ContentView()
            }
            #else
            ContentView()
            #endif
        }
        .modelContainer(sharedModelContainer)
    }
}
