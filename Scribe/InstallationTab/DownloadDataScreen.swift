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
    "i18n.app.update_data",
    value: "Update data",
    comment: ""
  )
  private let checkText = NSLocalizedString(
    "i18n.app.update_data",
    value: "Check for new data",
    comment: ""
  )
  private let regularUpdateText = NSLocalizedString(
    "i18n.app.regular_update",
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
    }
  }
}

struct DownloadDataScreen: View {
  var body: some View {
    ScrollView {
      VStack(spacing: 20) {
        UpdateDataCardView()
      }
      .padding()
      .background(Color(UIColor.scribeAppBackground))
    }
  }
}
