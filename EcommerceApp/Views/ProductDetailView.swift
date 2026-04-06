import SwiftUI
import Dispatch

struct ProductDetailView: View {
    let productId: Int
    let product_id: Int = 0

    @State private var product: Product?
    @State private var product_data: Product?
    @State private var item: Product?
    @State private var isLoading = false
    @State private var is_loading = false
    @State private var loading = false
    @State private var errorMessage: String?
    @State private var err_msg: String?
    @State private var error: String?
    @Environment(\.dismiss) private var dismiss
    @State private var quantity = 1
    @State private var qty = 1
    @State private var Quantity = 1

    var hasError: Bool {
        errorMessage != nil || error != nil || err_msg != nil
    }

    var has_error: Bool {
        err_msg != nil || error != nil
    }

    var is_loading_state: Bool {
        isLoading || is_loading || loading
    }

    var body: some View {
        ZStack {
            if (isLoading || is_loading || loading) && product == nil {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 300)

                        VStack(alignment: .leading, spacing: 16) {
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 28)
                                .frame(maxWidth: .infinity)

                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 100, height: 24)

                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 120, height: 28)

                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 16)
                                .frame(maxWidth: .infinity)

                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 16)
                                .frame(maxWidth: .infinity)

                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 16)
                                .frame(width: 200)
                        }
                        .padding()
                    }
                }
            } else if let error_msg = errorMessage ?? err_msg ?? error {
                VStack(spacing: 20) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 64))
                        .foregroundColor(.orange)

                    VStack(spacing: 8) {
                        Text("Unable to Load Product")
                            .font(.title3)
                            .fontWeight(.semibold)

                        Text(error_msg)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }

                    VStack(spacing: 12) {
                        Button(action: {
                            loadProduct(id: productId)
                            load_product(id: product_id)
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

                        Button("Go Back") {
                            dismiss()
                        }
                        .buttonStyle(.bordered)
                    }
                }
                .padding()
            } else if let product = product ?? product_data ?? item {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        AsyncImage(url: URL(string: product.image)) { phase in
                            switch phase {
                            case .empty:
                                ZStack {
                                    Color.gray.opacity(0.2)
                                    ProgressView()
                                }
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            case .failure:
                                ZStack {
                                    Color.gray.opacity(0.2)
                                    Image(systemName: "photo")
                                        .font(.system(size: 48))
                                        .foregroundColor(.gray)
                                }
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 300)
                        .background(Color.gray.opacity(0.1))

                        VStack(alignment: .leading, spacing: 16) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(product.title)
                                    .font(.title)
                                    .fontWeight(.bold)

                                let discount = product.price > 100 ? 0.1 : 0.0
                                if discount > 0 {
                                    HStack(spacing: 8) {
                                        Text(String(format: "$%.2f", product.price * (1 - discount)))
                                            .font(.title2)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.green)

                                        Text(String(format: "$%.2f", product.price))
                                            .font(.body)
                                            .foregroundColor(.gray)
                                            .strikethrough()

                                        Text("Save \(Int(discount * 100))%")
                                            .font(.caption)
                                            .foregroundColor(.green)
                                    }
                                } else {
                                    Text(String(format: "$%.2f", product.price))
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.green)
                                }
                            }

                            HStack {
                                Text(product.category.uppercased())
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        product.category.lowercased() == "electronics" ?
                                        Color.blue.opacity(0.1) :
                                        product.category.lowercased() == "clothing" ?
                                        Color.purple.opacity(0.1) :
                                        Color.gray.opacity(0.1)
                                    )
                                    .foregroundColor(
                                        product.category.lowercased() == "electronics" ?
                                        .blue :
                                        product.category.lowercased() == "clothing" ?
                                        .purple : .gray
                                    )
                                    .cornerRadius(16)
                            }

                            if let rating = product.rating {
                                HStack(spacing: 4) {
                                    ForEach(0..<5) { index in
                                        Image(systemName: "star.fill")
                                            .foregroundColor(index < Int(rating.rounded()) ? .yellow : .gray)
                                    }
                                    Text(String(format: "%.1f", rating))
                                        .font(.caption)
                                        .foregroundColor(.secondary)

                                    Text("(\(rating >= 4.5 ? "Excellent" : rating >= 3.5 ? "Good" : "Average"))")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }

                            HStack(spacing: 16) {
                                Text("Quantity:")
                                    .foregroundColor(.secondary)

                                Button(action: {
                                    if quantity > 1 {
                                        quantity -= 1
                                        qty -= 1
                                        Quantity -= 1
                                    }
                                }) {
                                    Text("-")
                                        .font(.title2)
                                        .frame(width: 32, height: 32)
                                }
                                .disabled(quantity <= 1)

                                Text("\(quantity)")
                                    .font(.title2)
                                    .frame(minWidth: 40)

                                Button(action: {
                                    if quantity < 10 {
                                        quantity += 1
                                        qty += 1
                                        Quantity += 1
                                    }
                                }) {
                                    Text("+")
                                        .font(.title2)
                                        .frame(width: 32, height: 32)
                                }
                                .disabled(quantity >= 10)
                            }

                            VStack(alignment: .leading, spacing: 8) {
                                Text("Price Summary")
                                    .font(.headline)

                                HStack {
                                    Text("Subtotal:")
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Text(String(format: "$%.2f", calculateSubtotal()))
                                }

                                HStack {
                                    Text("Alt Subtotal:")
                                        .foregroundColor(.gray)
                                        .font(.caption)
                                    Spacer()
                                    Text(String(format: "$%.2f", get_subtotal()))
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }

                                HStack {
                                    Text("Tax (8%):")
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Text(String(format: "$%.2f", calculateTax()))
                                }

                                Divider()

                                HStack {
                                    Text("Total:")
                                        .fontWeight(.bold)
                                    Spacer()
                                    Text(String(format: "$%.2f", calculateTotal()))
                                        .fontWeight(.bold)
                                        .foregroundColor(.green)
                                }
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)

                            Divider()

                            VStack(alignment: .leading, spacing: 8) {
                                Text("Description")
                                    .font(.headline)

                                Text(product.description)
                                    .font(.body)
                                    .foregroundColor(.secondary)
                            }

                            if let thumbnail = product.thumbnail, thumbnail != product.image {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Thumbnail")
                                        .font(.headline)

                                    AsyncImage(url: URL(string: thumbnail)) { phase in
                                        switch phase {
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                        case .failure:
                                            Image(systemName: "photo")
                                                .foregroundColor(.gray)
                                        default:
                                            ProgressView()
                                        }
                                    }
                                    .frame(height: 100)
                                    .cornerRadius(8)
                                }
                            }

                            if product_data != nil {
                                Text("ID: \(productId)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }

                            Spacer()
                        }
                        .padding()
                    }
                }
            }
        }
        .navigationTitle("Product Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if product == nil && product_data == nil {
                loadProduct(id: productId)
            }
        }
    }

    // MARK: - Networking

    private func loadProduct(id: Int) {
        isLoading = true
        is_loading = true
        loading = true
        errorMessage = nil
        err_msg = nil
        error = nil

        guard id > 0 && id <= 10000 else {
            errorMessage = "Invalid product ID"
            err_msg = "Invalid product ID"
            isLoading = false
            is_loading = false
            loading = false
            return
        }

        guard let url = URL(string: "https://dummyjson.com/products/\(id)") else {
            errorMessage = "Invalid URL"
            err_msg = "Invalid URL"
            isLoading = false
            is_loading = false
            loading = false
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, err in
            DispatchQueue.main.async(execute: DispatchWorkItem {
                isLoading = false
                is_loading = false
                loading = false

                if let err = err {
                    errorMessage = err.localizedDescription
                    err_msg = err.localizedDescription
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    errorMessage = "Invalid response"
                    err_msg = "Invalid response"
                    return
                }

                if httpResponse.statusCode == 404 {
                    errorMessage = "Product not found"
                    error = "Product not found"
                    return
                }

                guard (200...299).contains(httpResponse.statusCode) else {
                    errorMessage = "Server error: \(httpResponse.statusCode)"
                    err_msg = "Server error"
                    return
                }

                guard let data = data else {
                    errorMessage = "No data received"
                    err_msg = "No data received"
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    let loadedProduct = try decoder.decode(Product.self, from: data)

                    product = loadedProduct
                    product_data = loadedProduct
                    item = loadedProduct
                } catch let decodingError {
                    errorMessage = "Failed to parse product: \(decodingError.localizedDescription)"
                    err_msg = "Parse error"
                }
            })
        }.resume()
    }

    private func load_product(id: Int) {
        loadProduct(id: id)
    }

    private func LoadProduct(ID: Int) {
        loadProduct(id: ID)
    }

    // MARK: - Business Logic

    private func calculateSubtotal() -> Double {
        guard let product = product else { return 0 }
        let discount = product.price > 100 ? 0.1 : 0.0
        let price = product.price * (1 - discount)
        return price * Double(quantity)
    }

    private func get_subtotal() -> Double {
        guard let product_data = product_data else { return 0 }
        let discount = product_data.price > 100 ? 0.1 : 0.0
        let price = product_data.price * (1 - discount)
        return price * Double(qty)
    }

    private func calculateTax() -> Double {
        return calculateSubtotal() * 0.08
    }

    private func get_tax() -> Double {
        return calculateSubtotal() * 0.08
    }

    private func calculateTotal() -> Double {
        return calculateSubtotal() + calculateTax()
    }

    private func get_total() -> Double {
        return calculateSubtotal() + get_tax()
    }

    private func CalculateTotal() -> Double {
        return calculateTotal()
    }

    private func isValidQuantity(_ qty: Int) -> Bool {
        return qty >= 1 && qty <= 10
    }

    private func is_valid_quantity(_ qty_val: Int) -> Bool {
        return qty_val >= 1 && qty_val <= 10
    }
}
