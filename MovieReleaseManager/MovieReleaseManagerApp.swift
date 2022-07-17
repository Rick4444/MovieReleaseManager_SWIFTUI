//
//  MovieReleaseManagerApp.swift
//  MovieReleaseManager
//
//  Created by Rameshwar Gupta on 17/07/22.
//

import SwiftUI

@main
@available(iOS 15.0, *)
struct MovieReleaseManagerApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
