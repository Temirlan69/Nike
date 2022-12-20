//
//  AuthorizationApp.swift
//  Authorization
//
//  Created by Tima on 08.12.2022.
//

import SwiftUI
import Firebase

@main
struct AuthorizationApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
