// SPDX-License-Identifier: GPL-3.0-or-later

import SwiftUI

struct LanguageSettingsView: View {
    // MARK: Properties
    let parentSection: Scribe.Section
    let tableData: [ParentTableCellModel]
    let languageCode: String

    @AppStorage(
        "increaseTextSize", store: UserDefaults(suiteName: "group.be.scri.userDefaultsContainer")
    )
    var increaseTextSize: Bool = false

    private var textSizeMultiplier: CGFloat {
        increaseTextSize ? 1.25 : 1.0
    }

    private let userDefaults = UserDefaults(suiteName: "group.be.scri.userDefaultsContainer")!

    @State private var navigationPath = NavigationPath()

    // MARK: Initialization
    init(parentSection: Scribe.Section) {
        self.parentSection = parentSection

        // Extract language code from parentSection.
        if case let .specificLang(lang) = parentSection.sectionState {
            self.languageCode = lang
        } else {
            self.languageCode = "en"
        }

        // Filtering logic moved from SettingsViewController.
        var data = SettingsTableData.languageSettingsData

        if DeviceType.isPad {
            // Check if Layout Section exists.
            if data.count > 1 {
                // Keep only functioning settings for iPad in the Layout section.
                // In the original UIKit, it was quite complex. Let's replicate.
                data[1].section.removeAll { item in
                    item.sectionState == .none(.toggleAccentCharacters) ||
                    item.sectionState == .none(.toggleCommaAndPeriod)
                }
                if data[1].section.isEmpty {
                    data.remove(at: 1)
                }
            }
        } else {
            // Logic for iPhone (accent keys).
            let accentKeyLanguages: [String] = [
                languagesStringDict["German"]!,
                languagesStringDict["Spanish"]!,
                languagesStringDict["Swedish"]!
            ]

            let accentKeyOptionIndex =
                SettingsTableData.languageSettingsData[1].section.firstIndex(where: { s in
                    s.sectionTitle.elementsEqual(
                        NSLocalizedString(
                            "i18n.app.settings.keyboard.layout.disable_accent_characters",
                            value: "Disable accent characters", comment: ""
                        )
                    )
                }) ?? -1

            if accentKeyLanguages.firstIndex(of: parentSection.sectionTitle) == nil,
               accentKeyOptionIndex != -1 {
                data[1].section.remove(at: accentKeyOptionIndex)
            }
        }
        self.tableData = data
    }

    // MARK: Body
    var body: some View {
        List {
            ForEach(Array(tableData.enumerated()), id: \.offset) { _, sectionModel in
                SwiftUI.Section {
                    ForEach(Array(sectionModel.section.enumerated()), id: \.offset) { _, item in
                        settingRow(for: item)
                    }
                } header: {
                    if !sectionModel.headingTitle.isEmpty {
                        Text(sectionModel.headingTitle)
                            .font(.system(size: (DeviceType.isPad ? 18 : 14) * textSizeMultiplier, weight: .bold))
                            .foregroundColor(Color(UIColor(ScribeColor.keyChar)))
                            .textCase(nil)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle(parentSection.sectionTitle)
        .background(Color(UIColor(ScribeColor.scribeAppBackground)).edgesIgnoringSafeArea(.all))
    }

    // MARK: Row Builder
    @ViewBuilder
    private func settingRow(for item: Scribe.Section) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(item.sectionTitle)
                    .font(.system(size: (DeviceType.isPad ? fontSize * 1.5 : fontSize) * textSizeMultiplier, weight: .medium))
                    .foregroundColor(Color(UIColor(ScribeColor.keyChar)))

                Spacer()

                if item.hasToggle {
                    Toggle("", isOn: binding(for: item.sectionState))
                        .labelsHidden()
                        .tint(Color(UIColor(ScribeColor.scribeCTA)).opacity(0.6))
                } else {
                    // Navigation
                    if item.sectionState == .translateLang {
                        translationSubLabel()
                    }
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color(UIColor(ScribeColor.menuOption)))
                }
            }

            if let description = item.shortDescription {
                Text(description)
                    .font(.system(size: (DeviceType.isPad ? fontSize * 1.1 : fontSize * 0.9) * textSizeMultiplier))
                    .foregroundColor(Color(UIColor(ScribeColor.keyChar)))
                    .opacity(0.8)
            }
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
        .onTapGesture {
            if !item.hasToggle {
                handleNavigation(for: item)
            }
        }
        .listRowBackground(Color(UIColor(ScribeColor.lightWhiteDarkBlack)))
    }

    // MARK: Navigation
    private func handleNavigation(for item: Scribe.Section) {
        if item.sectionState == .translateLang {
            pushTranslationPicker(parentItem: item)
        }
    }

    private func pushTranslationPicker(parentItem: Scribe.Section) {
        var data = SettingsTableData.translateLangSettingsData
        let langCodeIndex = data[0].section.firstIndex(where: { s in
            s.sectionState == .specificLang(languageCode)
        }) ?? -1
        if langCodeIndex != -1 {
            data[0].section.remove(at: langCodeIndex)
        }

        let pickerView = TranslationLanguagePickerView(
            tableData: data,
            parentSection: parentItem,
            langCode: languageCode
        )

        // Find the hosting controller's navigation controller and push.
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let tabBarController = window.rootViewController as? UITabBarController,
           let navigationController = tabBarController.selectedViewController as? UINavigationController {
            let hostingController = UIHostingController(rootView: pickerView)
            navigationController.pushViewController(hostingController, animated: true)
        }
    }

    @ViewBuilder
    private func translationSubLabel() -> some View {
        let key = languageCode + "TranslateLanguage"
        let selectedLang = userDefaults.string(forKey: key) ?? "en"
        let langName = getKeyInDict(givenValue: selectedLang, dict: languagesAbbrDict)
        let localizedName = NSLocalizedString(
            "i18n.app._global." + langName.lowercased(),
            value: langName,
            comment: ""
        )

        Text(localizedName)
            .font(.system(size: (DeviceType.isPad ? fontSize * 1.3 : fontSize * 0.9) * textSizeMultiplier))
            .foregroundColor(Color(UIColor(ScribeColor.menuOption)))
    }

    // MARK: Binding Helpers
    private func binding(for state: SectionState) -> Binding<Bool> {
        guard case let .none(action) = state else {
            return .constant(false)
        }

        let key: String
        let defaultValue: Bool

        switch action {
        case .toggleCommaAndPeriod:
            key = languageCode + "CommaAndPeriod"
            defaultValue = false
        case .toggleAccentCharacters:
            key = languageCode + "AccentCharacters"
            defaultValue = false
        case .doubleSpacePeriods:
            key = languageCode + "DoubleSpacePeriods"
            defaultValue = true
        case .autosuggestEmojis:
            key = languageCode + "EmojiAutosuggest"
            defaultValue = true
        case .toggleWordForWordDeletion:
            key = languageCode + "WordForWordDeletion"
            defaultValue = false
        case .increaseTextSize:
            key = "increaseTextSize"
            defaultValue = false
        case .none:
            return .constant(false)
        }

        return Binding<Bool>(
            get: {
                if let val = userDefaults.object(forKey: key) as? Bool {
                    return val
                }
                return defaultValue
            },
            set: { newValue in
                userDefaults.setValue(newValue, forKey: key)
                if action == .increaseTextSize {
                    initializeFontSize()
                    NotificationCenter.default.post(name: .fontSizeUpdatedNotification, object: nil)
                }
            }
        )
    }
}
