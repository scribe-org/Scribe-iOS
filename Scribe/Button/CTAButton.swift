// SPDX-License-Identifier: GPL-3.0-or-later

/**
 * Call to Action Button.
 */

import SwiftUI

struct CTAButton: View {
    @AppStorage("increaseTextSize", store: UserDefaults(suiteName: "group.be.scri.userDefaultsContainer"))
    var increaseTextSize: Bool = false
    var textSizeMultiplier: CGFloat { increaseTextSize ? 1.25 : 1.0 }

    let title: String
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 20 * textSizeMultiplier, weight: .bold))
                .foregroundColor(Color("lightTextDarkCTA"))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color("appBtn"))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(colorScheme == .dark ? Color("scribeCTA") : Color.clear, lineWidth: 1)
                )
                .shadow(
                    color: Color(red: 0.247, green: 0.247, blue: 0.275, opacity: 0.25),
                    radius: 3,
                    x: 0,
                    y: 3
                )
        }
        .buttonStyle(CTAButtonStyle())
    }
}

struct CTAButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}
