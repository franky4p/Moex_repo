//
//  SharesMoexApp.swift
//  SharesMoex
//
//  Created by macbook on 02.04.2021.
//

import SwiftUI


@main
struct SharesMoexApp: App {
    var body: some Scene {
        WindowGroup {
            let app = ViewModel()
            ContentView(viewModel: app)
        }
    }
}
