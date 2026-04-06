import SwiftUI

@main
struct EcommerceApp: App {
    init() {
        NetworkMonitor.shared.start()
    }

    var body: some Scene {
        WindowGroup {
            ProductListView()
        }
    }
}
