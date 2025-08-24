import SwiftUI

@main
struct YasbaApp: App {
    var body: some Scene {
        WindowGroup {
            SieveScriptBuilderView(model: SieveScriptViewModel())
        }
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unified)
    }
}
