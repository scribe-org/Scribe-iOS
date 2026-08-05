// SPDX-License-Identifier: GPL-3.0-or-later

import SwiftUI

struct SettingsHomeView: View {
    // MARK: Properties
    @State private var tableData = SettingsTableData.settingsTableData
    @AppStorage("increaseTextSize", store: UserDefaults(suiteName: "group.be.scri.userDefaultsContainer"))
    var increaseTextSize: Bool = false
    
    private var textSizeMultiplier: CGFloat {
        increaseTextSize ? 1.25 : 1.0
    }
    
    @Environment(\.colorScheme) var colorScheme
    @State private var showLanguageAlert = false
    @State private var tipCardVisible = true

    private let userDefaults = UserDefaults(suiteName: "group.be.scri.userDefaultsContainer")!

    // MARK: Body
    var body: some View {
        List {
            // MARK: Tip Card Header
            if tipCardVisible {
                SwiftUI.Section {
                    SettingsTipCardView {
                        withAnimation { tipCardVisible = false }
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                }
            }

            // MARK: Settings Sections
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
            
            // MARK: Footer Button Section
            if tableData.indices.contains(1), tableData[1].section.isEmpty {
                SwiftUI.Section {
                    installKeyboardsButton()
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle(NSLocalizedString("i18n.app.settings.title", value: "Settings", comment: ""))
        .background(Color(UIColor(ScribeColor.scribeAppBackground)).edgesIgnoringSafeArea(.all))
        .onAppear {
            refreshKeyboards()
            // Check if tip card was already dismissed (stored in @AppStorage inside SettingsTipCardView)
            tipCardVisible = UserDefaults.standard.bool(forKey: "settingsTipCardState") 
            if !UserDefaults.standard.dictionaryRepresentation().keys.contains("settingsTipCardState") {
                tipCardVisible = true
            }
        }
        .alert(isPresented: $showLanguageAlert) {
            Alert(
                title: Text(NSLocalizedString("i18n.app.settings.menu.app_language.one_device_language_warning.title", value: "No languages installed", comment: "")),
                message: Text(NSLocalizedString("i18n.app.settings.menu.app_language.one_device_language_warning.message", value: "You only have one language installed on your device. Please install more languages in Settings and then you can select different localizations of Scribe.", comment: "")),
                dismissButton: .cancel(Text("Cancel"))
            )
        }
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

    // MARK: Component Helpers
    @ViewBuilder
    private func installKeyboardsButton() -> some View {
        Button {
            openSettingsApp()
        } label: {
            Text(NSLocalizedString("i18n.app.settings.button_install_keyboards", value: "Install keyboards", comment: ""))
                .font(.system(size: fontSize * 1.5, weight: .bold))
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(Color(UIColor(ScribeColor.appBtn)))
                .foregroundColor(Color(UIColor(ScribeColor.lightTextDarkCTA)))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(UIColor(ScribeColor.scribeCTA)), lineWidth: colorScheme == .dark ? 1 : 0)
                )
                .shadow(color: Color.black.opacity(0.25), radius: 3, x: 0, y: 3)
        }
        .padding(.horizontal, 16)
        .padding(.top, 20)
    }

    // MARK: Logic
    private func refreshKeyboards() {
        tableData[1].section = SettingsTableData.getInstalledKeyboardsSections()
    }

    private func handleNavigation(for item: Scribe.Section) {
        switch item.sectionState {
        case .appLang:
            if NSLocale.preferredLanguages.count == 1 {
                showLanguageAlert = true
            } else {
                openSettingsApp()
            }
        case .specificLang:
            pushLanguageSettings(parentItem: item)
        default: break
        }
    }

    private func pushLanguageSettings(parentItem: Scribe.Section) {
        let nextView = LanguageSettingsView(parentSection: parentItem)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let tabBarController = window.rootViewController as? UITabBarController,
           let navigationController = tabBarController.selectedViewController as? UINavigationController {
            let hostingController = UIHostingController(rootView: nextView)
            navigationController.pushViewController(hostingController, animated: true)
        }
    }

    private func openSettingsApp() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }

    private func binding(for state: SectionState) -> Binding<Bool> {
        guard case let .none(action) = state, action == .increaseTextSize else {
            return .constant(false)
        }

        return Binding<Bool>(
            get: { increaseTextSize },
            set: { newValue in
                increaseTextSize = newValue
                initializeFontSize()
                NotificationCenter.default.post(name: .fontSizeUpdatedNotification, object: nil)
            }
        )
    }
}

