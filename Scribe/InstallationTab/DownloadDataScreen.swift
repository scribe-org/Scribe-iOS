// SPDX-License-Identifier: GPL-3.0-or-later

/**
 * Download data screen.
 */

import SwiftUI

struct RadioCircle: View {
  @Binding var isSelected: Bool

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
      }
    }
  }
}

struct UpdateDataCardView: View {
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
        .font(.system(size: 19, weight: .semibold))
        .foregroundColor(.primary)

      VStack(alignment: .leading, spacing: 12) {
        HStack {
          Text(checkText)
            .font(.body)
            .foregroundColor(.primary)

          Spacer()

          RadioCircle(isSelected: $isCheckNew)
        }

        Divider()

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
  let action: () -> Void

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack {
        Text(language)
          .font(.body)
          .foregroundColor(.primary)

        Spacer()

        DownloadButton(state: .ready, action: action)
      }
    }
  }
}

struct LanguageListView: View {
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

  let languages = SettingsTableData.getInstalledKeyboardsSections()

  @State private var showConfirmDialog = false
  @State private var targetLanguage = ""
  @State private var sourceLanguage = "English"
  let userDefaults = UserDefaults(suiteName: "group.be.scri.userDefaultsContainer")!

  var body: some View {
    ZStack {
      VStack(alignment: .leading, spacing: 6) {
        Text(title)
          .font(.system(size: 19, weight: .semibold))
          .foregroundColor(.primary)

        VStack(spacing: 0) {
          LanguageDownloadCard(
            language: allLanguagesText,
            action: {
              targetLanguage = allLanguagesText
              showConfirmDialog = true
            }
          )

          Divider()
            .padding(.vertical, 8)

          ForEach(Array(languages.enumerated()), id: \.offset) { index, section in
            LanguageDownloadCard(
              language: section.sectionTitle,
              action: {
                targetLanguage = section.sectionTitle
                showConfirmDialog = true
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

      if showConfirmDialog {
            let languageCode = "en"
            if let selectedSourceLang = userDefaults.string(forKey: languageCode + "TranslateLanguage") {
            sourceLanguage = getKeyInDict(givenValue: selectedSourceLang, dict: languagesAbbrDict)
        }
        ConfirmTranslationSource(
          infoText: NSLocalizedString(
            "i18n.app.download.menu_ui.translation_source_tooltip.download_warning",
            value: "The data you will download will allow you to translate from {source_language} to {destination_language}. Do you want to change the language you'll translate from?",
            comment: ""
          ).replacingOccurrences(of: "{source_language}", with: sourceLanguage)
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
          ).replacingOccurrences(of: "{source_language}", with: sourceLanguage),
          onDismiss: {
            showConfirmDialog = false
          },
          onChange: {
            showConfirmDialog = false
            // Navigate to language selection screen
          },
          onConfirm: {
            showConfirmDialog = false
            // Start download with current source language
          }
        )
      }
    }
  }
}

struct DownloadDataScreen: View {
  var body: some View {
    ScrollView {
      VStack(spacing: 20) {
        UpdateDataCardView()
        LanguageListView()
      }
      .padding()
      .background(Color(UIColor.scribeAppBackground))
    }
  }
}
