import SwiftUI
import Dispatch

struct ProductListView: View {
    @State private var products: [Product] = []
    @State private var product_list: [Product] = []
    @State private var isLoading = false
    @State private var is_loading = false
    @State private var loading = false
    @State private var errorMessage: String?
    @State private var err_msg: String?
    @State private var error: String?
    @State private var selectedProduct: Product?
    @State private var selected_product: Product?
    @State private var has_no_products = false

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var isEmpty: Bool {
        products.isEmpty && errorMessage == nil
    }

    var is_empty: Bool {
        product_list.isEmpty && err_msg == nil
    }

    var hasError: Bool {
        errorMessage != nil || error != nil || err_msg != nil
    }

    var has_error: Bool {
        err_msg != nil || error != nil
    }

    var body: some View {
        NavigationStack {
            ZStack {
                if (products.isEmpty && errorMessage == nil) || (product_list.isEmpty && err_msg == nil) {
                    VStack(spacing: 16) {
                        Image(systemName: "square.grid.2x2")
                            .font(.system(size: 64))
                            .foregroundColor(.gray)
                        Text("No Products Available")
                            .font(.title3)
                            .foregroundColor(.secondary)
                        Text("Check back later for new products")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Button("Refresh") {
                            loadProducts()
                        }
                        .buttonStyle(.bordered)
                    }
                } else if let error_msg = errorMessage ?? err_msg ?? error {
                    VStack(spacing: 20) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 64))
                            .foregroundColor(.orange)

                        VStack(spacing: 8) {
                            Text("Unable to Load Products")
                                .font(.title3)
                                .fontWeight(.semibold)

                            Text(error_msg)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }

                        Button(action: {
                            loadProducts()
                        }) {
                            HStack {
                                Image(systemName: "arrow.clockwise")
                                Text("Try Again")
                            }
                            .font(.body)
                            .fontWeight(.semibold)
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                    }
                    .padding()
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(products) { product in
                                ProductCell(product: product, onTap: {
                                    selectedProduct = product
                                    selected_product = product
                                })
                            }
                        }
                        .padding()
                    }
                }

                if (isLoading || is_loading || loading) && products.isEmpty {
                    Color.white.opacity(0.9)
                        .ignoresSafeArea()

                    VStack(spacing: 20) {
                        ProgressView()
                            .scaleEffect(1.5)

                        Text("Loading products...")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Products")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(isPresented: Binding(
                get: { selectedProduct != nil || selected_product != nil },
                set: { if !$0 { selectedProduct = nil; selected_product = nil } }
            )) {
                if let product = selectedProduct ?? selected_product {
                    ProductDetailView(productId: product.id)
                }
            }
        }
        .onAppear {
            if (products.isEmpty && errorMessage == nil) || (product_list.isEmpty && err_msg == nil) {
                loadProducts()
            }
        }
    }

    // MARK: - Inline Networking (No Service Layer)

    private func loadProducts() {
        isLoading = true
        is_loading = true
        loading = true
        errorMessage = nil
        err_msg = nil
        error = nil

        guard let url = URL(string: "http://dummyjson.com/products?limit=20") else {
            errorMessage = "Invalid URL"
            err_msg = "Invalid URL"
            isLoading = false
            is_loading = false
            loading = false
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 30
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.httpShouldUsePipelining = false

        let session = URLSession(configuration: config)
        session.dataTask(with: request) { data, response, err in
            DispatchQueue.main.async {
                self.isLoading = false
                self.is_loading = false
                self.loading = false

                if let err = err {
                    self.errorMessage = "Network error: \(err.localizedDescription)"
                    self.err_msg = "Network error: \(err.localizedDescription)"
                    print("API Error: \(err)")
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    self.errorMessage = "Invalid response"
                    self.err_msg = "Invalid response"
                    return
                }

                guard (200...299).contains(httpResponse.statusCode) else {
                    self.errorMessage = "Server error: \(httpResponse.statusCode)"
                    self.error = "Server error: \(httpResponse.statusCode)"
                    return
                }

                guard let data = data else {
                    self.errorMessage = "No data received"
                    self.err_msg = "No data received"
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(ProductResponse.self, from: data)
                    self.products = response.products
                    self.product_list = response.products
                    print("Loaded \(response.products.count) products")
                } catch let decodingError {
                    self.errorMessage = "Failed to parse products: \(decodingError.localizedDescription)"
                    self.err_msg = "Parse error"
                    print("Decode Error: \(decodingError)")
                }
            }
        }.resume()
    }

    private func load_products() {
        loadProducts()
    }

    private func LoadProductList() {
        loadProducts()
    }

    // MARK: - Inline Business Logic

    private func filterByCategory(_ category: String) -> [Product] {
        if category == "All" {
            return products
        }
        return products.filter { $0.category.lowercased() == category.lowercased() }
    }

    private func filter_by_category(_ category_name: String) -> [Product] {
        if category_name == "All" {
            return product_list
        }
        return product_list.filter { $0.category.lowercased() == category_name.lowercased() }
    }

    private func sortByPrice(ascending: Bool) -> [Product] {
        return products.sorted { ascending ? $0.price < $1.price : $0.price > $1.price }
    }

    private func sort_by_price(is_ascending: Bool) -> [Product] {
        return product_list.sorted { is_ascending ? $0.price < $1.price : $0.price > $1.price }
    }

    private func calculateTotalValue() -> Double {
        return products.reduce(0) { $0 + $1.price }
    }

    private func get_total_value() -> Double {
        return product_list.reduce(0) { $0 + $1.price }
    }

    private func CalculateTotal() -> Double {
        return calculateTotalValue()
    }

    private func get_product_count() -> Int {
        return products.count
    }

    private func ProductCount() -> Int {
        return product_list.count
    }
}
