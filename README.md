# EcommerceApp

A SwiftUI-based e-commerce application for iOS that demonstrates modern iOS development practices with MVVM architecture, async/await networking, and network monitoring.

## Overview

This app fetches and displays products from the [DummyJSON](https://dummyjson.com) API, featuring:
- Product list view with pagination support
- Detailed product view with full descriptions
- Network connectivity monitoring
- Modern SwiftUI with async/await
- MVVM architecture pattern

## Requirements

- **iOS**: 17.0+
- **Xcode**: 15.0+
- **Swift**: 5.9+

## Project Structure

```
EcommerceApp/
├── App.swift                 # App entry point
├── ContentView.swift         # Root view
├── Models/
│   └── Product.swift         # Product data models
├── Services/
│   ├── APIService.swift      # API networking layer
│   └── NetworkMonitor.swift  # Network connectivity monitoring
├── ViewModels/
│   ├── ProductListViewModel.swift
│   └── ProductDetailViewModel.swift
└── Views/
    ├── ProductListView.swift
    ├── ProductDetailView.swift
    └── ProductCell.swift
```

## Architecture

The app follows the **MVVM (Model-View-ViewModel)** pattern:

- **Models**: Data structures representing the domain entities
- **Views**: SwiftUI views that observe ViewModels
- **ViewModels**: Business logic and state management using `@Observable`
- **Services**: Reusable services for networking and system features

### Data Flow

```
User Action -> ViewModel -> API Service -> Network
                ↓
            State Update
                ↓
            View Update
```

## Setup

### Option 1: Using Xcode Project

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd codinginterview-ios
   ```

2. Open the Xcode project:
   ```bash
   open EcommerceApp.xcodeproj
   ```

3. Select a simulator or device (iOS 17.0+)

4. Build and run (⌘R)

### Option 2: Using Swift Package

1. From the project root, build using Swift Package Manager:
   ```bash
   swift build
   ```

2. Run the executable:
   ```bash
   swift run EcommerceApp
   ```

## Key Features

### API Service
- Uses `async/await` for modern concurrency
- Generic error handling with `APIError` enum
- Codable protocol for JSON parsing
- Singleton pattern for shared instance

### Network Monitoring
- Uses `NWPathMonitor` for real-time network status
- Publishes connectivity changes via `@Published`
- Automatically starts monitoring on app launch

### State Management
- Uses `@Observable` macro for ViewModels (iOS 17+)
- Automatic view updates on state changes
- Clean separation of concerns

## API Endpoints Used

| Endpoint | Description |
|----------|-------------|
| `GET /products?limit={n}` | Fetch list of products |
| `GET /products/{id}` | Fetch specific product details |

**Base URL**: `https://dummyjson.com`

## Error Handling

The app handles various error scenarios:
- Invalid URLs
- Network failures
- Invalid HTTP responses
- JSON decoding errors

All errors are surfaced through the UI with user-friendly messages.

## Development Notes

### Adding New Features

1. **New API endpoints**: Add methods to `APIService.swift`
2. **New screens**: Create View + ViewModel pairs in respective directories
3. **New models**: Add to the `Models/` directory with `Codable` conformance

### Testing

The project structure supports unit testing for:
- ViewModels (state management logic)
- Services (networking, business logic)

### Dependencies

This project uses only Apple's native frameworks:
- `SwiftUI` - UI framework
- `Foundation` - Core utilities and networking
- `Network` - Network connectivity monitoring

## License

[Specify your license here]

## Author

Created as a coding interview project.
