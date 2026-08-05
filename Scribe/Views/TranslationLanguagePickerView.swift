// SPDX-License-Identifier: GPL-3.0-or-later

import SwiftUI

struct TranslationLanguagePickerView: View {
    // MARK: Properties
    let tableData: [ParentTableCellModel]
    let parentSection: Scribe.Section?
    let langCode: String

    @AppStorage(
        "increaseTextSize", store: UserDefaults(suiteName: "group.be.scri.userDefaultsContainer")
    )
    var increaseTextSize: Bool = false

    private var textSizeMultiplier: CGFloat {
        increaseTextSize ? 1.25 : 1.0
    }

    private let userDefaults = UserDefaults(suiteName: "group.be.scri.userDefaultsContainer")!

    @State private var selectedLang: String = "en"
    @State private var showConfirmation = false
    @State private var pendingNewLang: String = ""

    // MARK: Body
    var body: some View {
        List {
            ForEach(Array(tableData.enumerated()), id: \.offset) { sectionIndex, sectionModel in
                SwiftUI.Section {
                    ForEach(Array(sectionModel.section.enumerated()), id: \.offset) { _, item in
                        let itemLang = extractLangCode(from: item)
                        languageRow(item: item, itemLang: itemLang)
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
        .onAppear {
            selectedLang = userDefaults.string(forKey: langCode + "TranslateLanguage") ?? "en"
        }
        .fullScreenCover(isPresented: $showConfirmation) {
            confirmationPopup()
        }
        .navigationTitle(NSLocalizedString("i18n.app.settings.keyboard.translation.select_source.title", value: "Translation language", comment: ""))
    }

    // MARK: Language Row
    @ViewBuilder
    private func languageRow(item: Scribe.Section, itemLang: String) -> some View {
        Button {
            handleSelection(newLang: itemLang)
        } label: {
            HStack {
                Image(selectedLang == itemLang ? "radioButtonSelected" : "radioButton")
                    .resizable()
                    .frame(width: DeviceType.isPad ? 28 : 22, height: DeviceType.isPad ? 28 : 22)

                Text(item.sectionTitle)
                    .font(.system(size: (DeviceType.isPad ? fontSize * 1.5 : fontSize) * textSizeMultiplier))
                    .foregroundColor(Color(UIColor(ScribeColor.keyChar)))

                Spacer()
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .listRowBackground(Color(UIColor(ScribeColor.lightWhiteDarkBlack)))
    }

    // MARK: Selection Handler
    private func handleSelection(newLang: String) {
        let oldLang = selectedLang
        if newLang != oldLang {
            pendingNewLang = newLang
            // We temporarily don't update selectedLang so we can revert if cancelled.
            showConfirmation = true
        }
    }

    // MARK: Confirmation Popup
    @ViewBuilder
    private func confirmationPopup() -> some View {
        let oldLang = userDefaults.string(forKey: langCode + "TranslateLanguage") ?? "en"
        let oldSourceLanguage = getKeyInDict(givenValue: oldLang, dict: languagesAbbrDict)
        let newSourceLanguage = getKeyInDict(givenValue: pendingNewLang, dict: languagesAbbrDict)

        let localizedOldSourceLanguage = NSLocalizedString(
            "i18n.app._global." + oldSourceLanguage.lowercased(),
            value: oldSourceLanguage,
            comment: ""
        )
        let localizedNewSourceLanguage = NSLocalizedString(
            "i18n.app._global." + newSourceLanguage.lowercased(),
            value: newSourceLanguage,
            comment: ""
        )

        let infoText = NSLocalizedString(
            "i18n.app.settings.keyboard.translation.change_source_tooltip.download_warning",
            value: "You've changed your source translation language. Would you like to download new data so that you can translate from {source_language}?",
            comment: ""
        ).replacingOccurrences(of: "{source_language}", with: localizedNewSourceLanguage)

        let changeButtonText = NSLocalizedString(
            "i18n.app.settings.keyboard.translation.change_source_tooltip.keep_source_language",
            value: "Keep {source_language}", comment: ""
        ).replacingOccurrences(of: "{source_language}", with: localizedOldSourceLanguage)

        let confirmButtonText = NSLocalizedString(
            "i18n.app._global.download_data", value: "Download data", comment: ""
        )

        ConfirmTranslationSource(
            infoText: infoText,
            changeButtonText: changeButtonText,
            confirmButtonText: confirmButtonText,
            onDismiss: { showConfirmation = false },
            onChange: { showConfirmation = false },
            onConfirm: { confirmDownload() }
        )
        .background(BackgroundClearView())
    }

    // MARK: Actions
    private func confirmDownload() {
        showConfirmation = false
        let dictionaryKey = langCode + "TranslateLanguage"
        userDefaults.setValue(pendingNewLang, forKey: dictionaryKey)
        selectedLang = pendingNewLang

        DownloadStateManager.shared.handleDownloadAction(key: langCode, forceDownload: true)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            navigateToDownloadScreen()
        }
    }

    private func navigateToDownloadScreen() {
        guard
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let window = windowScene.windows.first,
            let tabBarController = window.rootViewController as? UITabBarController,
            let installationNavController = tabBarController.viewControllers?[0] as? UINavigationController
        else { return }

        if let downloadScreen = installationNavController.viewControllers.first(where: {
            $0 is UIHostingController<DownloadDataScreen>
        }) {
            tabBarController.selectedIndex = 0
            installationNavController.popToViewController(downloadScreen, animated: true)
        } else {
            tabBarController.selectedIndex = 0
            installationNavController.popToRootViewController(animated: false)

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                NotificationCenter.default.post(
                    name: NSNotification.Name("NavigateToDownloadScreen"),
                    object: nil
                )
            }
        }
    }

    private func extractLangCode(from section: Scribe.Section) -> String {
        if case let .specificLang(lang) = section.sectionState {
            return lang
        }
        return "n/a"
    }
}

private struct BackgroundClearView: UIViewRepresentable {
    func makeUIView(context _: Context) -> UIView {
        let view = InnerView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    func updateUIView(_: UIView, context _: Context) {}

    private class InnerView: UIView {
        override func didMoveToWindow() {
            super.didMoveToWindow()
            superview?.superview?.backgroundColor = .clear
        }
    }
}
