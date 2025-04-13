//
//  PishiDinoApp.swift
//  PishiDino
//
//  Created by Amir Ali on 4/10/25.
//

import SwiftUI
import CoreData

@main
struct PishiDinoApp: App {
    let persistenceController = PersistenceController.shared

    init() {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if let error = error {
                    print("Notification permission error: \(error.localizedDescription)")
                } else {
                    print("Notifications permission granted: \(granted)")
                }
            }
        }
    
    var body: some Scene {
        WindowGroup {
            ContentView(context: persistenceController.container.viewContext)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
