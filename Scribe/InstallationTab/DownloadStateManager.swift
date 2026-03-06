// SPDX-License-Identifier: GPL-3.0-or-later

import Foundation
import SwiftUI

/// Manages data download states and actions.

@MainActor
class DownloadStateManager: ObservableObject {
  static let shared = DownloadStateManager()

  @Published var downloadStates: [String: ButtonState] = [:]
  @Published var toastMessage: String?
  @Published var showToast: Bool = false

  private var downloadTasks: [String: Task<Void, Never>] = [:]
  private let service = LanguageDataService.shared
  private let userDefaults = UserDefaults.standard

  private init() {}

  /// Initialize download states for languages.
  func initializeStates(languages: [String]) {
    for language in languages {
      if downloadStates[language] != nil { continue }

      // Check if data exists locally.
      if service.hasData(for: language) {
        downloadStates[language] = .updated
      } else {
        downloadStates[language] = .ready
      }
    }

    // Check for updates on downloaded languages.
    checkAllForUpdates()
  }

  /// Handles the download action based on the current state.
  func handleDownloadAction(key: String, forceDownload: Bool = false) {
    let currentState = downloadStates[key] ?? .ready
    let displayName = getKeyInDict(givenValue: key, dict: languagesAbbrDict)

    // Block if already downloading.
    if currentState == .downloading {
      return
    }

    // Block if updated and not forcing.
    if currentState == .updated && !forceDownload {
      showToastMessage("\(displayName) data is already up to date")
      return
    }

    // Proceed with download.
    downloadStates[key] = .downloading

    downloadTasks[key] = Task {
      do {
        try await service.downloadData(language: key, forceDownload: forceDownload)

        if !Task.isCancelled {
          downloadStates[key] = .updated
          showToastMessage("\(displayName) data downloaded successfully!")
        }
      } catch is CancellationError {
        downloadStates[key] = .ready
      } catch let error as NetworkError {
        downloadStates[key] = .ready
        showToastMessage("Network error: \(error.localizedDescription)")
      } catch {
        downloadStates[key] = .ready
        showToastMessage("Download failed: \(error.localizedDescription)")
      }

      downloadTasks.removeValue(forKey: key)
    }
  }

  /// Check for updates for a specific language.
  func checkForUpdates(language: String) {
    let currentState = downloadStates[language] ?? .ready

    // Don't check while downloading
    if currentState == .downloading { return }

    // Only check if already downloaded
    guard currentState == .updated else { return }

    Task {
      do {
        let hasUpdate = try await service.checkForUpdates(language: language)

        if !Task.isCancelled {
          downloadStates[language] = hasUpdate ? .update : .updated
        }
      } catch {
        print("Error checking updates for \(language): \(error.localizedDescription)")
      }
    }
  }

  /// Check all downloaded languages for updates.
  func checkAllForUpdates() {
    for (language, state) in downloadStates where state == .updated {
      checkForUpdates(language: language)
    }
  }

  // MARK: Toast Helper
  private func showToastMessage(_ message: String) {
    toastMessage = message
    showToast = true

    // Auto-hide after 3 seconds.
    Task {
      try? await Task.sleep(nanoseconds: 3_000_000_000)
      if toastMessage == message {
        showToast = false
      }
    }
  }
}
