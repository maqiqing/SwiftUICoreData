//
//  SwiftUICoreDataApp.swift
//  SwiftUICoreData
//
//  Created by maqiqing on 2022/6/22.
//

import SwiftUI

// https://juejin.cn/post/7088512902193217567

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
