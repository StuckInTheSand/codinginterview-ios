import Foundation

@Observable
class ProductListViewModel {
    var products: [Product] = []
    var isLoading = false
    var errorMessage: String?

    var isEmpty: Bool {
        products.isEmpty && !isLoading
    }

    var hasError: Bool {
        errorMessage != nil
    }

    private let apiService = APIService.shared
    private let networkMonitor = NetworkMonitor.shared

    func loadProducts() {
        guard networkMonitor.isConnected else {
            errorMessage = "No internet connection. Please check your network and try again."
            return
        }

        isLoading = true
        errorMessage = nil

        Task { @MainActor in
            do {
                let fetchedProducts = try await apiService.fetchProducts(limit: 20)
                products = fetchedProducts
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }

    func retry() {
        loadProducts()
    }
}
