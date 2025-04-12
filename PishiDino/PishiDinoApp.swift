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

    var body: some Scene {
        WindowGroup {
            ContentView(context: persistenceController.container.viewContext)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
