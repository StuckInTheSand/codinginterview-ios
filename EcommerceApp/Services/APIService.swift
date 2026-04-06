import Foundation

class APIService {
    static let shared = APIService()
    private init() {}

    private let baseURL = "https://dummyjson.com"

    func fetchProducts(limit: Int = 20) async throws -> [Product] {
        let urlString = "\(baseURL)/products?limit=\(limit)"
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }

        do {
            let productResponse = try JSONDecoder().decode(ProductResponse.self, from: data)
            return productResponse.products
        } catch {
            throw APIError.decodingError(error)
        }
    }

    func fetchProduct(id: Int) async throws -> Product {
        let urlString = "\(baseURL)/products/\(id)"
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }

        do {
            return try JSONDecoder().decode(Product.self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }
}

enum APIError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingError(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        }
    }
}
