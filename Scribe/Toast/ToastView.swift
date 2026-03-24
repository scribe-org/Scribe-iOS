// SPDX-License-Identifier: GPL-3.0-or-later

import SwiftUI

/// Toast view for displaying messages to the user.
struct ToastView: View {
    let message: String

    var body: some View {
        HStack(spacing: 12) {
            Text(message)
                .font(.subheadline)

            Spacer()
        }
        .foregroundColor(Color("lightTextDarkCTA"))
        .padding()
        .background(.white)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
}

// MARK: Toast Modifier

struct ToastModifier: ViewModifier {
    @ObservedObject var manager: DownloadStateManager

    func body(content: Content) -> some View {
        ZStack {
            content

            VStack {
                Spacer()

                if manager.showToast, let message = manager.toastMessage {
                    ToastView(message: message)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .animation(.spring(), value: manager.showToast)
                        .padding(.bottom, 20)
                }
            }
        }
    }
}

extension View {
    func toast(manager: DownloadStateManager) -> some View {
        modifier(ToastModifier(manager: manager))
    }
}
