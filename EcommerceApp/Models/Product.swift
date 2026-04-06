import Foundation

struct Product: Codable, Identifiable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let images: [String]?
    let rating: Double?
    let thumbnail: String?

    // Computed property for backward compatibility
    var image: String {
        return images?.first ?? thumbnail ?? ""
    }
}

struct ProductResponse: Codable {
    let products: [Product]
    let total: Int
    let skip: Int
    let limit: Int
}
