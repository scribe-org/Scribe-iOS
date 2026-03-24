// SPDX-License-Identifier: GPL-3.0-or-later

/**
 * A single row in the About tab list.
 */

import SwiftUI

enum AboutRowTrailing {
    case externalLink
    case chevron
    case reset
    case none
}

struct AboutRowView: View {
    let icon: String
    let isCustomImage: Bool
    let title: String
    var trailing: AboutRowTrailing = .none
    let action: () -> Void

    init(
        icon: String,
        isCustomImage: Bool,
        title: String,
        hasExternalLink: Bool = false,
        hasNestedNavigation: Bool = false,
        isReset: Bool = false,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.isCustomImage = isCustomImage
        self.title = title
        self.action = action
        if hasExternalLink {
            self.trailing = .externalLink
        } else if hasNestedNavigation {
            self.trailing = .chevron
        } else if isReset {
            self.trailing = .reset
        } else {
            self.trailing = .none
        }
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                iconView
                    .frame(width: 28, height: 28)
                    .padding(.leading, 16)

                Text(title)
                    .foregroundColor(.primary)
                    .font(.body)

                Spacer()

                trailingView
                    .padding(.trailing, 16)
            }
            .frame(minHeight: 52)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    // MARK: - Icon

    @ViewBuilder
    private var iconView: some View {
        if isCustomImage {
            Image(icon)
                .resizable()
                .scaledToFit()
        } else {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .foregroundColor(.primary)
        }
    }

    // MARK: - Trailing

    @ViewBuilder
    private var trailingView: some View {
        switch trailing {
        case .externalLink:
            Image(systemName: "arrow.up.right.square")
                .font(.system(size: 17))
                .foregroundColor(Color(.systemGray3))
        case .chevron:
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color(.systemGray3))
        case .reset:
            Image(systemName: "arrow.counterclockwise")
                .font(.system(size: 17))
                .foregroundColor(Color(.systemGray3))
        case .none:
            EmptyView()
        }
    }
}
