//
//  Milestone_Projects_10_12App.swift
//  Milestone_Projects_10_12
//
//  Created by user09 on 19.03.2024.
//

import SwiftUI
import SwiftData

@main
struct Milestone_Projects_10_12App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: User.self)
    }
}
