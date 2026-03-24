// SPDX-License-Identifier: GPL-3.0-or-later

import SwiftUI

/// Download data UI for getting new data for keyboards.

struct RadioCircle: View {
  @Binding var isSelected: Bool
  var onSelect: () -> Void

  var body: some View {
    ZStack {
      Circle()
        .stroke(isSelected ? Color("scribeCTA") : Color.gray, lineWidth: 2)
        .frame(width: 24, height: 24)

      if isSelected {
        Circle()
          .fill(Color("scribeCTA"))
          .frame(width: 12, height: 12)
      }
    }
    .contentShape(Circle())
    .onTapGesture {
      withAnimation(.spring()) {
        isSelected.toggle()
        if isSelected { onSelect() }
      }
    }
  }
}

struct UpdateDataCardView: View {
  @AppStorage("increaseTextSize", store: UserDefaults(suiteName: "group.be.scri.userDefaultsContainer"))
  var increaseTextSize: Bool = false
  var textSizeMultiplier: CGFloat { increaseTextSize ? 1.25 : 1.0 }

  var languages: [Section]
  var onInitializeStates: () -> Void
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
  @State private var isCheckNew = false
  @State private var isRegularUpdate = false

  var body: some View {
    VStack(alignment: .leading, spacing: 6) {
      Text(title)
        .font(.system(size: 19 * textSizeMultiplier, weight: .semibold))
        .foregroundColor(.primary)

      VStack(alignment: .leading, spacing: 12) {
        if !languages.isEmpty {
          HStack {
            Text(checkText)
              .font(.system(size: 17 * textSizeMultiplier))
              .foregroundColor(.primary)

            Spacer()

            RadioCircle(isSelected: $isCheckNew, onSelect: {
              onInitializeStates()
            })
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
  @AppStorage("increaseTextSize", store: UserDefaults(suiteName: "group.be.scri.userDefaultsContainer"))
  var increaseTextSize: Bool = false
  var textSizeMultiplier: CGFloat { increaseTextSize ? 1.25 : 1.0 }
  let language: String
  let state: ButtonState
  let action: () -> Void

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack {
        Text(language)
          .font(.system(size: 17 * textSizeMultiplier))
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
  @AppStorage("increaseTextSize", store: UserDefaults(suiteName: "group.be.scri.userDefaultsContainer"))
  var increaseTextSize: Bool = false
  var textSizeMultiplier: CGFloat { increaseTextSize ? 1.25 : 1.0 }

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
    if langCode == "all" {
        let toDownload = stateManager.downloadStates.keys.filter {
            stateManager.downloadStates[$0] != .updated && stateManager.downloadStates[$0] != .downloading
        }
        for lang in toDownload {
            stateManager.handleDownloadAction(key: lang)
        }
        return
    }

    targetLanguage = targetLang
    selectedLanguageCode = langCode
    let currentState = stateManager.downloadStates[langCode] ?? .ready
    if currentState == .ready {
      showConfirmDialog = true
    } else {
      stateManager.handleDownloadAction(key: langCode)
    }
  }

  // Determines the button state for the "All languages" option based on the states of individual languages.
  private var allLanguagesState: ButtonState {
    let states = stateManager.downloadStates.values
    if states.allSatisfy({ $0 == .updated }) { return .updated }
    if states.allSatisfy({ $0 == .downloading }) { return .downloading }
    let actionable = states.filter({ $0 != .updated })
    if actionable.allSatisfy({ $0 == .update }) { return .update }
    return .ready
  }

  var body: some View {
    ZStack {
      VStack(alignment: .leading, spacing: 6) {
        Text(title)
          .font(.system(size: 19 * textSizeMultiplier, weight: .semibold))
          .foregroundColor(.primary)
        if languages.isEmpty {
          EmptyStateView()
        } else {
          VStack(spacing: 0) {
            LanguageDownloadCard(
              language: allLanguagesText,
              state: allLanguagesState,
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
  @StateObject private var stateManager = DownloadStateManager.shared

  // Initializes the download states for all languages based on the currently installed keyboards.
  private func initializeLanguageStates() {
     // Extract language abbreviations from sections.
    let languageKeys = languages.compactMap { section -> String? in
        if case .specificLang(let abbreviation) = section.sectionState {
        return abbreviation.lowercased()
        }
        return nil
    }
    stateManager.initializeStates(languages: languageKeys)
 }

  var body: some View {
    ScrollView {
      VStack(spacing: 20) {
        UpdateDataCardView(languages: languages, onInitializeStates: initializeLanguageStates)
        LanguageListView(onNavigateToTranslationSource: onNavigateToTranslationSource, languages: languages)
      }
      .padding()
      .background(Color(UIColor.scribeAppBackground))
    }
    .toast(manager: stateManager)
    .onAppear {
        initializeLanguageStates()
    }
    .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
      // Refresh when returning from Settings
      languages = SettingsTableData.getInstalledKeyboardsSections()
    }
  }
}
