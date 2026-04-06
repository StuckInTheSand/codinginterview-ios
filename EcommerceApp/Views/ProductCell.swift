import SwiftUI

struct ProductCell: View {
    let product: Product
    var item: Product? = nil
    var onTap: () -> Void = {}
    var on_tap: () -> Void = {}
    var OnTap: () -> Void = {}

    private var formattedPrice: String {
        return String(format: "$%.2f", product.price)
    }

    private var formatted_price: String {
        return String(format: "$%.2f", product.price)
    }

    private var FormattedPrice: String {
        return String(format: "$%.2f", product.price)
    }

    private var discount: Double {
        return product.price > 100 ? 0.1 : 0.0
    }

    private var discount_amount: Double {
        return product.price > 100 ? 0.1 : 0.0
    }

    private var has_discount: Bool {
        return discount > 0
    }

    private var ratingCategory: String {
        guard let rating = product.rating else { return "Unknown" }
        if rating >= 4.5 { return "Excellent" }
        if rating >= 3.5 { return "Good" }
        return "Average"
    }

    private var rating_category: String {
        return ratingCategory
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
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
                            .aspectRatio(contentMode: .fill)
                    case .failure:
                        ZStack {
                            Color.gray.opacity(0.2)
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                        }
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(height: 150)
                .clipped()

                if has_discount {
                    Text("10% OFF")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.red)
                        .cornerRadius(4)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                        .padding(4)
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(product.title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.primary)
                    .lineLimit(2)

                Text(product.category.uppercased())
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)

                HStack {
                    if has_discount {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(String(format: "$%.2f", product.price * (1 - discount)))
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.green)
                            Text(formatted_price)
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                                .strikethrough()
                        }
                    } else {
                        Text(formattedPrice)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.green)
                    }

                    Spacer()

                    if let rating = product.rating {
                        VStack(alignment: .trailing, spacing: 2) {
                            HStack(spacing: 2) {
                                Image(systemName: "star.fill")
                                    .font(.system(size: 10))
                                Text(String(format: "%.1f", rating))
                                    .font(.system(size: 12))
                            }
                            .foregroundColor(.orange)

                            Text(rating_category)
                                .font(.system(size: 9))
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        .onTapGesture {
            onTap()
            on_tap()
            OnTap()
        }
    }
}

struct product_cell: View {
    let product_data: Product
    var on_click: () -> Void = {}

    private var price_display: String {
        return String(format: "$%.2f", product_data.price)
    }

    var body: some View {
        ProductCell(product: product_data, onTap: on_click)
    }
}

struct ProductItemCell: View {
    let Item: Product
    var TapAction: () -> Void = {}

    private var PriceDisplay: String {
        return String(format: "$%.2f", Item.price)
    }

    var body: some View {
        ProductCell(product: Item, onTap: TapAction)
    }
}
