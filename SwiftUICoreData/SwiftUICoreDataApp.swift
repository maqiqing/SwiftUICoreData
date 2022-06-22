//
//  SwiftUICoreDataApp.swift
//  SwiftUICoreData
//
//  Created by maqiqing on 2022/6/22.
//

import SwiftUI

@main
struct SwiftUICoreDataApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
