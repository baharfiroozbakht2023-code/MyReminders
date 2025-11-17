//
//  MyRemindersApp.swift
//  MyReminders
//
//  Created by bahar firoozbakht on 12/11/25.
//

import SwiftUI
import SwiftData

@main
struct MyRemindersApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: RTask.self)
    }
}
