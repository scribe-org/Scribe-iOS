// SPDX-License-Identifier: GPL-3.0-or-later

/**
 * Download data UI for getting new data for keyboards.
 */

import SwiftUI

enum CheckDataState {
  case idle
  case checking
  case checked
}

struct CheckDataSpinner: View {
  @Binding var state: CheckDataState
  @State private var rotation: Double = 0
  @State private var spinnerTimer: Timer?

  var body: some View {
    ZStack {
      switch state {
      case .idle:
        // Empty gray circle
        Circle()
          .stroke(Color.gray, lineWidth: 2)
          .frame(width: 28, height: 28)
          .contentShape(Circle())
          .onTapGesture { startChecking() }

      case .checking:
        // Rotating arc (orange) with X cancel
        ZStack {
          Circle()
            .stroke(Color.gray.opacity(0.3), lineWidth: 2.5)
            .frame(width: 28, height: 28)

          Circle()
            .trim(from: 0, to: 0.7)
            .stroke(Color("scribeCTA"), style: StrokeStyle(lineWidth: 2.5, lineCap: .round))
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
        // Filled orange circle with checkmark
        ZStack {
          Circle()
            .fill(Color("scribeCTA"))
            .frame(width: 28, height: 28)

          Image(systemName: "checkmark")
            .font(.system(size: 12, weight: .bold))
            .foregroundColor(.white)
        }
        .contentShape(Circle())
        .onTapGesture { resetToIdle() }
      }
    }
    .animation(.easeInOut(duration: 0.2), value: state == .idle)
  }

  private func startChecking() {
    withAnimation { state = .checking }
    // Simulate a check completing after 2 seconds
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

  private func resetToIdle() {
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

struct UpdateDataCardView: View {
  var languages: [Section]
  private let title = NSLocalizedString(
    "i18n.app.download.menu_ui.update_data",
    value: "Update data",
    comment: ""
  )
  private let checkText = NSLocalizedString(
    "i18n.app.download.menu_ui.update_data.check_new",
    value: "Check for new data",
    comment: ""
  )
  private let regularUpdateText = NSLocalizedString(
    "i18n.app.download.menu_ui.update_data.regular_update",
    value: "Regularly update data",
    comment: ""
  )
  @State private var checkState: CheckDataState = .idle
  @State private var isRegularUpdate = false

  var body: some View {
    VStack(alignment: .leading, spacing: 6) {
      Text(title)
        .font(.system(size: 19, weight: .semibold))
        .foregroundColor(.primary)

      VStack(alignment: .leading, spacing: 12) {
        if !languages.isEmpty {
          HStack {
            Text(checkText)
              .font(.body)
              .foregroundColor(.primary)

            Spacer()

            CheckDataSpinner(state: $checkState)
          }
          Divider()
        }

        Toggle(isOn: $isRegularUpdate) {
          HStack {
            Text(regularUpdateText)
          }
        }
        .tint(Color.scribeCTA)
      }
      .padding()
      .background(Color(.systemBackground))
      .cornerRadius(12)
      .padding(.horizontal, 16)
    }
  }
}

struct LanguageDownloadCard: View {
  let language: String
  let state: ButtonState
  let action: () -> Void

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack {
        Text(language)
          .font(.body)
          .foregroundColor(.primary)

        Spacer()

        DownloadButton(
          state: state,
          action: action
        )
      }
    }
  }
}

struct EmptyStateView: View {
  private var noKeyboardText = NSLocalizedString(
    "i18n.app.download.menu_ui.no_keyboards_installed",
    value: "You currently do not have any Scribe keyboard installed. Please click the Install keyboards button below to install a Scribe keyboard and then come back to download the needed data.",
    comment: ""
  )

  private var installText = NSLocalizedString(
    "i18n.app.settings.button_install_keyboards",
    value: "Install keyboards",
    comment: "")

  func openSettingsApp() {
      guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
          return
      }
      UIApplication.shared.open(settingsURL)
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 24) {
      Text(noKeyboardText)
        .foregroundColor(.primary)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)

      CTAButton(title: installText, action: {openSettingsApp()})
    }
    .padding(.horizontal, 16)
  }
}

struct LanguageListView: View {
  var onNavigateToTranslationSource: ((String, String) -> Void)?
  var languages: [Section]

  @ObservedObject private var stateManager = DownloadStateManager.shared

  private let title = NSLocalizedString(
    "i18n.app.download.menu_ui.download_data.title",
    value: "Select data to download",
    comment: ""
  )

  private let allLanguagesText = NSLocalizedString(
    "i18n.app.download.menu_ui.download_data.all_languages",
    value: "All languages",
    comment: ""
  )

  @State private var showConfirmDialog = false
  @State private var targetLanguage = ""
  @State private var selectedLanguageCode = ""
  let userDefaults = UserDefaults(suiteName: "group.be.scri.userDefaultsContainer")!

  private func handleButtonClick(targetLang: String, langCode: String) {
    targetLanguage = targetLang
    selectedLanguageCode = langCode
    let currentState = stateManager.downloadStates[langCode] ?? .ready
    if currentState == .ready {
      showConfirmDialog = true
    } else {
      stateManager.handleDownloadAction(key: langCode)
    }
  }

  var body: some View {
    ZStack {
      VStack(alignment: .leading, spacing: 6) {
        Text(title)
          .font(.system(size: 19, weight: .semibold))
          .foregroundColor(.primary)
        if languages.isEmpty {
          EmptyStateView()
        } else {
          VStack(spacing: 0) {
            LanguageDownloadCard(
              language: allLanguagesText,
              state: stateManager.downloadStates["all"] ?? .ready,
              action: {
                handleButtonClick(targetLang: allLanguagesText, langCode: "all")
              }
            )

            Divider()
              .padding(.vertical, 8)

            ForEach(Array(languages.enumerated()), id: \.offset) { index, section in
              let langCode: String = {
                if case let .specificLang(code) = section.sectionState {
                  return code
                }
                return ""
              }()

              LanguageDownloadCard(
                language: section.sectionTitle,
                state: stateManager.downloadStates[langCode] ?? .ready,
                action: {
                  handleButtonClick(targetLang: section.sectionTitle, langCode: langCode)
                }
              )

              if index < languages.count - 1 {
                Divider()
                  .padding(.vertical, 8)
              }
            }
          }
          .padding()
          .background(Color(.systemBackground))
          .cornerRadius(12)
          .padding(.horizontal, 16)
        }
      }

      if showConfirmDialog {
        confirmDialogView
      }
    }
  }

  private var confirmDialogView: some View {
    let languageCode = selectedLanguageCode.isEmpty ? "en" : selectedLanguageCode
    let selectedSourceLang = userDefaults.string(forKey: languageCode + "TranslateLanguage") ?? "en"
    let sourceLanguage = getKeyInDict(givenValue: selectedSourceLang, dict: languagesAbbrDict)

    let localizedSourceLanguage = NSLocalizedString(
      "i18n.app._global." + sourceLanguage.lowercased(),
      value: sourceLanguage,
      comment: ""
    )

    return ConfirmTranslationSource(
      infoText: NSLocalizedString(
        "i18n.app.download.menu_ui.translation_source_tooltip.download_warning",
        value: "The data you will download will allow you to translate from {source_language} to {target_language}. Do you want to change the language you'll translate from?",
        comment: ""
      )
      .replacingOccurrences(of: "{source_language}", with: localizedSourceLanguage)
      .replacingOccurrences(of: "{target_language}", with: targetLanguage),
      changeButtonText: NSLocalizedString(
        "i18n.app.download.menu_ui.translation_source_tooltip.change_language",
        value: "Change language",
        comment: ""
      ),
      confirmButtonText: NSLocalizedString(
        "i18n.app.download.menu_ui.translation_source_tooltip.use_source_language",
        value: "Use {source_language}",
        comment: ""
      )
      .replacingOccurrences(of: "{source_language}", with: localizedSourceLanguage),
      onDismiss: {
        showConfirmDialog = false
      },
      onChange: {
        showConfirmDialog = false
        onNavigateToTranslationSource?(selectedLanguageCode, targetLanguage)
      },
      onConfirm: {
        showConfirmDialog = false
        stateManager.handleDownloadAction(key: selectedLanguageCode)
      }
    )
  }
}

struct DownloadDataScreen: View {
  var onNavigateToTranslationSource: ((String, String) -> Void)?
  @State private var languages = SettingsTableData.getInstalledKeyboardsSections()
  var body: some View {
    ScrollView {
      VStack(spacing: 20) {
        UpdateDataCardView(languages: languages)
        LanguageListView(onNavigateToTranslationSource: onNavigateToTranslationSource, languages: languages)
      }
      .padding()
      .background(Color(UIColor.scribeAppBackground))
    }
    .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
      // Refresh when returning from Settings
      languages = SettingsTableData.getInstalledKeyboardsSections()
    }
  }
}
