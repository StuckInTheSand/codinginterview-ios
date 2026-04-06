import Foundation

@Observable
class ProductDetailViewModel {
    var product: Product?
    var isLoading = false
    var errorMessage: String?

    private let apiService = APIService.shared
    private let networkMonitor = NetworkMonitor.shared

    func loadProduct(id: Int) {
        guard networkMonitor.isConnected else {
            errorMessage = "No internet connection. Please check your network and try again."
            return
        }

        isLoading = true
        errorMessage = nil

        Task { @MainActor in
            do {
                let fetchedProduct = try await apiService.fetchProduct(id: id)
                product = fetchedProduct
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}
