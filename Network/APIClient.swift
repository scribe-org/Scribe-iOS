// SPDX-License-Identifier: GPL-3.0-or-later

import Foundation

// MARK: Network Error

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int, message: String?)
    case decodingError(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid server response"
        case let .httpError(code, message):
            if let message = message {
                return "HTTP error \(code): \(message)"
            }
            return "HTTP error: \(code)"
        case let .decodingError(error):
            return "Decoding failed: \(error.localizedDescription)"
        }
    }
}

// MARK: API Client

/// APIClient handles all network interactions with the Scribe server, including fetching language data and version information.
final class LanguageDataAPIClient {
    static let shared = LanguageDataAPIClient()

    private let session: URLSession
    private let decoder: JSONDecoder
    private let baseURL: URL

    init(
        baseURL: URL = URL(string: "https://scribe-server.toolforge.org/api/v1/")!,
        session: URLSession? = nil
    ) {
        self.baseURL = baseURL

        // Configure session
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        self.session = session ?? URLSession(configuration: config)

        // Configure decoder
        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
    }

    // MARK: Fetch Language Data

    /// Fetches the complete language data including contract and data tables
    /// - Parameter language: The language code (e.g., "en", "es", "fr")
    /// - Returns: DataResponse containing language data
    func fetchLanguageData(language: String) async throws -> DataResponse {
        let endpoint = "data/\(language)"
        return try await fetch(DataResponse.self, from: endpoint)
    }

    // MARK: Fetch Data Version

    /// Fetches the version information for a specific language
    /// - Parameter language: The language code (e.g., "en", "es", "fr")
    /// - Returns: DataVersionResponse containing version information
    func fetchDataVersion(language: String) async throws -> DataVersionResponse {
        let endpoint = "data-version/\(language)"
        return try await fetch(DataVersionResponse.self, from: endpoint)
    }

    // MARK: Generic Fetch

    private func fetch<T: Decodable>(
        _: T.Type,
        from endpoint: String
    ) async throws -> T {
        guard let url = URL(string: endpoint, relativeTo: baseURL)
        else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        let (data, response) = try await session.data(for: request)

        // Validate response.
        guard let httpResponse = response as? HTTPURLResponse
        else {
            throw NetworkError.invalidResponse
        }

        // Handle non-success status codes.
        guard (200 ... 299).contains(httpResponse.statusCode)
        else {
            let errorMessage = try? JSONDecoder().decode(
                ErrorResponse.self,
                from: data
            ).message
            throw NetworkError.httpError(
                statusCode: httpResponse.statusCode,
                message: errorMessage
            )
        }

        // Decode response
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}

// MARK: Error Response

private struct ErrorResponse: Decodable {
    let message: String
}
