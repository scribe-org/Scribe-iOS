// SPDX-License-Identifier: GPL-3.0-or-later

/**
 * Download data UI for the Scribe-Conjugate app.
 *
 * Unlike the keyboard app which only shows installed keyboards,
 * this screen shows all supported languages listed alphabetically.
 */

import SwiftUI

// MARK: - Language Data

/// All languages supported by Scribe-Conjugate with their abbreviations.
private let conjugateLanguagesAbbrDict: [String: String] = [
    "Deutsch": "de",
    "English": "en",
    "Español": "es",
    "Français": "fr",
    "Italiano": "it",
    "Português": "pt",
    "Русская": "ru",
    "Svenska": "sv"
]

/// Returns all languages sorted alphabetically by display name.
private func allLanguagesSorted() -> [(display: String, code: String)] {
    conjugateLanguagesAbbrDict
        .map { (display: $0.key, code: $0.value) }
        .sorted { $0.display.localizedCompare($1.display) == .orderedAscending }
}

// MARK: - Download Button State

enum ConjugateButtonState: Equatable {
    case ready
    case downloading
    case updated
    case update
}

// MARK: - Download State Manager

/// Manages per-language download states for the Conjugate app.
/// Actual download logic will be wired up once the data service
/// is available to this target (tracked in a follow-up issue).
@MainActor
class ConjugateDownloadStateManager: ObservableObject {
    static let shared = ConjugateDownloadStateManager()

    @Published var downloadStates: [String: ConjugateButtonState] = [:]
    @Published var toastMessage: String?
    @Published var showToast: Bool = false

    private let userDefaults = UserDefaults.standard
    private let lastUpdateKey = "conjugate_last_update_"

    private init() {}

    func initializeStates(languages: [String]) {
        for language in languages {
            if downloadStates[language] != nil { continue }
            downloadStates[language] = hasLocalData(for: language) ? .updated : .ready
        }
    }

    func handleDownloadAction(key: String) {
        let currentState = downloadStates[key] ?? .ready
        let displayName = conjugateLanguagesAbbrDict.first(where: { $0.value == key })?.key ?? key

        if currentState == .downloading { return }

        if currentState == .updated {
            showToastMessage(
                String(
                    format: NSLocalizedString(
                        "i18n.conjugate.download.already_up_to_date",
                        value: "%@ data is already up to date",
                        comment: ""
                    ),
                    displayName
                )
            )
            return
        }

        // Download functionality will be implemented in a follow-up issue.
        // For now, reflect the downloading state as a UI placeholder.
        downloadStates[key] = .downloading
    }

    private func hasLocalData(for language: String) -> Bool {
        userDefaults.string(forKey: "\(lastUpdateKey)\(language)") != nil
    }

    func showToastMessage(_ message: String) {
        toastMessage = message
        showToast = true
        Task {
            try? await Task.sleep(nanoseconds: 3_000_000_000)
            if toastMessage == message { showToast = false }
        }
    }
}

// MARK: - Download Button

private struct ConjugateDownloadButton: View {
    let state: ConjugateButtonState
    let action: () -> Void

    private var label: String {
        switch state {
        case .ready:
            return NSLocalizedString(
                "i18n.app._global.download_data", value: "Download data", comment: ""
            )
        case .downloading:
            return NSLocalizedString(
                "i18n.app.download.menu_ui.download_data.downloading",
                value: "Downloading",
                comment: ""
            )
        case .updated:
            return NSLocalizedString(
                "i18n.app.download.menu_ui.download_data.up_to_date",
                value: "Up to date",
                comment: ""
            )
        case .update:
            return NSLocalizedString(
                "i18n.app.download.menu_ui.update_data", value: "Update data", comment: ""
            )
        }
    }

    private var icon: String {
        switch state {
        case .ready, .update: return "icloud.and.arrow.down"
        case .downloading: return "arrow.clockwise.circle.fill"
        case .updated: return "checkmark.circle.fill"
        }
    }

    private var bgColor: Color {
        state == .updated ? Color("buttonGreen") : Color("buttonOrange")
    }

    private var fgColor: Color {
        state == .updated ? Color("lightTextDarkGreen") : Color("lightTextDarkCTA")
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Text(label)
                if state == .downloading {
                    ProgressView().tint(fgColor).scaleEffect(0.8)
                } else {
                    Image(systemName: icon)
                }
            }
            .font(.system(size: 12, weight: .semibold))
            .foregroundColor(fgColor)
            .frame(width: 120, height: 20)
            .padding(.vertical, 6)
            .padding(.horizontal, 10)
            .background(bgColor)
            .cornerRadius(6)
        }
        .animation(.easeInOut(duration: 0.2), value: state)
    }
}

// MARK: - Check Data Spinner

private enum CheckDataState { case idle, checking, checked }

private struct CheckDataSpinner: View {
    @Binding var state: CheckDataState
    @State private var rotation: Double = 0
    @State private var spinnerTimer: Timer?

    var body: some View {
        ZStack {
            switch state {
            case .idle:
                Circle()
                    .stroke(Color.gray, lineWidth: 2)
                    .frame(width: 28, height: 28)
                    .contentShape(Circle())
                    .onTapGesture { startChecking() }

            case .checking:
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 2.5)
                        .frame(width: 28, height: 28)
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            Color("scribeCTA"),
                            style: StrokeStyle(lineWidth: 2.5, lineCap: .round)
                        )
                        .frame(width: 28, height: 28)
                        .rotationEffect(.degrees(rotation))
                        .onAppear { startRotation() }
                        .onDisappear { stopRotation() }
                    Image(systemName: "xmark")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(Color("scribeCTA"))
                }
                .contentShape(Circle())
                .onTapGesture { cancelChecking() }

            case .checked:
                ZStack {
                    Circle().fill(Color("scribeCTA")).frame(width: 28, height: 28)
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                }
                .contentShape(Circle())
                .onTapGesture { withAnimation { state = .idle } }
            }
        }
        .animation(.easeInOut(duration: 0.2), value: state == .idle)
    }

    private func startChecking() {
        withAnimation { state = .checking }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            guard state == .checking else { return }
            stopRotation()
            withAnimation { state = .checked }
        }
    }

    private func cancelChecking() {
        stopRotation()
        withAnimation { state = .idle }
    }

    private func startRotation() {
        rotation = 0
        spinnerTimer?.invalidate()
        spinnerTimer = Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { _ in
            rotation += 4
        }
    }

    private func stopRotation() {
        spinnerTimer?.invalidate()
        spinnerTimer = nil
    }
}

// MARK: - Toast

private struct ConjugateToastView: View {
    let message: String

    var body: some View {
        HStack(spacing: 12) {
            Text(message).font(.subheadline)
            Spacer()
        }
        .foregroundColor(Color("lightTextDarkCTA"))
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
}

// MARK: - Update Data Card

private struct UpdateDataCard: View {
    @State private var checkState: CheckDataState = .idle
    @State private var isRegularUpdate = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(
                NSLocalizedString(
                    "i18n.app.download.menu_ui.update_data", value: "Update data", comment: ""
                )
            )
            .font(.system(size: 20, weight: .bold))
            .foregroundColor(.primary)
            .padding(.horizontal, 4)

            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text(
                        NSLocalizedString(
                            "i18n.app.download.menu_ui.update_data.check_new",
                            value: "Check for new data",
                            comment: ""
                        )
                    )
                    .font(.system(size: 17))
                    .foregroundColor(.primary)
                    Spacer()
                    CheckDataSpinner(state: $checkState)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)

                Divider()
                    .padding(.horizontal, 16)

                Toggle(isOn: $isRegularUpdate) {
                    Text(
                        NSLocalizedString(
                            "i18n.app.download.menu_ui.update_data.regular_update",
                            value: "Regularly update data",
                            comment: ""
                        )
                    )
                    .font(.system(size: 17))
                }
                .tint(Color("scribeCTA"))
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
            }
            .background(Color(.systemBackground))
            .cornerRadius(12)
        }
    }
}

// MARK: - Language List

private struct LanguageListCard: View {
    let languages: [(display: String, code: String)]
    @ObservedObject var stateManager: ConjugateDownloadStateManager

    private func handleUpdateAll() {
        for lang in languages
        where stateManager.downloadStates[lang.code] != .updated
            && stateManager.downloadStates[lang.code] != .downloading {
            stateManager.handleDownloadAction(key: lang.code)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(
                NSLocalizedString(
                    "i18n.app.download.menu_ui.download_data.title",
                    value: "Select data to download",
                    comment: ""
                )
            )
            .font(.system(size: 20, weight: .bold))
            .foregroundColor(.primary)
            .padding(.horizontal, 4)

            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Text(
                        NSLocalizedString(
                            "i18n.app.download.menu_ui.download_data.update_all",
                            value: "Update all",
                            comment: ""
                        )
                    )
                    .foregroundColor(Color("linkBlue"))
                    .font(.system(size: 17, weight: .medium))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .onTapGesture { handleUpdateAll() }
                }

                ForEach(Array(languages.enumerated()), id: \.offset) { index, lang in
                    HStack {
                        Text(lang.display)
                            .font(.system(size: 17))
                            .foregroundColor(.primary)
                        Spacer()
                        ConjugateDownloadButton(
                            state: stateManager.downloadStates[lang.code] ?? .ready,
                            action: { stateManager.handleDownloadAction(key: lang.code) }
                        )
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)

                    if index < languages.count - 1 {
                        Divider()
                            .padding(.horizontal, 16)
                    }
                }
            }
            .background(Color(.systemBackground))
            .cornerRadius(12)
        }
    }
}

// MARK: - Download Data Screen

struct ConjugateDownloadDataScreen: View {
    private let languages = allLanguagesSorted()
    @StateObject private var stateManager = ConjugateDownloadStateManager.shared

    private func initializeStates() {
        stateManager.initializeStates(languages: languages.map(\.code))
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    UpdateDataCard()
                    LanguageListCard(languages: languages, stateManager: stateManager)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .padding(.bottom, stateManager.showToast ? 60 : 0)
            }
            .background(Color("scribeAppBackground").ignoresSafeArea())

            if stateManager.showToast, let message = stateManager.toastMessage {
                ConjugateToastView(message: message)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .animation(.spring(), value: stateManager.showToast)
                    .padding(.bottom, 16)
            }
        }
        .navigationTitle(
            NSLocalizedString(
                "i18n.app.download.menu_ui.download_data",
                value: "Download data",
                comment: ""
            )
        )
        .navigationBarTitleDisplayMode(.large)
        .onAppear { initializeStates() }
    }
}
