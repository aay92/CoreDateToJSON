//
//  CoreDateToJSONApp.swift
//  CoreDateToJSON
//
//  Created by Aleksey Alyonin on 20.03.2023.
//

import SwiftUI

@main
struct CoreDateToJSONApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
