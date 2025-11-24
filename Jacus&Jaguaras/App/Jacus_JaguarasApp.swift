import SwiftUI
import TipKit

@main
struct Jacus_JaguarasApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .ignoresSafeArea()
                .task {
                    try? Tips.resetDatastore() // MARK: só pra teste
                    try? Tips.configure([
                        //.displayFrequency(.immediate),
                        .datastoreLocation(.applicationDefault)
                    ])
                }
        }
    }
}
