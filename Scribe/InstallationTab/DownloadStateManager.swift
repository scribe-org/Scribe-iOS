// SPDX-License-Identifier: GPL-3.0-or-later

/**
 * Manages data download states and actions.
 */

import Foundation

private let PLACEBO_SERVER_UPDATED_AT = "2026-01-8"
private let PLACEBO_LOCAL_UPDATED_AT = "2026-01-01"

class DownloadStateManager: ObservableObject {
    static let shared = DownloadStateManager()

    @Published var downloadStates: [String: ButtonState] = [:]

    private init() {}

    /**
     * Returns true if server data is newer than local data.
     */
    private func isUpdateAvailable(localUpdatedAt: String, serverUpdatedAt: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        guard let localDate = dateFormatter.date(from: localUpdatedAt),
              let serverDate = dateFormatter.date(from: serverUpdatedAt) else {
            return false
        }

        return serverDate > localDate
    }

    /**
     * Handles the download action based on the current state.
     */
    func handleDownloadAction(key: String) {
        let currentState = downloadStates[key] ?? .ready

        downloadStates[key] = switch currentState {
        case .ready:
            .downloading
        case .downloading:
            .updated
        case .updated:
            isUpdateAvailable(localUpdatedAt: PLACEBO_LOCAL_UPDATED_AT,
                            serverUpdatedAt: PLACEBO_SERVER_UPDATED_AT) ? .update : .updated
        case .update:
            .downloading
        }
    }
}
