// SPDX-License-Identifier: GPL-3.0-or-later

import SwiftUI

struct ConjugateTab: View {
    @State private var navigateToDownload = false

    var body: some View {
        AppNavigation {
            ScrollView {
                VStack(spacing: 20) {
                    Image("ScribeLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 100)
                        .padding(.top, 30)

                    CardView(
                        title: NSLocalizedString(
                            "i18n.app.download.menu_option.conjugate_title",
                            value: "Verb data",
                            comment: ""
                        ),
                        mainText: NSLocalizedString(
                            "i18n.app.download.menu_option.conjugate_download_data_start",
                            value: "Download data to start conjugating!",
                            comment: ""
                        ),
                        subtitle: NSLocalizedString(
                            "i18n.app.download.menu_option.conjugate_description",
                            value: "Add new data to Scribe Conjugate.",
                            comment: ""
                        )
                    ) {
                        navigateToDownload = true
                    }
                    .background(
                        NavigationLink(
                            destination: ConjugateDownloadDataScreen(),
                            isActive: $navigateToDownload
                        ) { EmptyView() }
                    )
                }
                .padding()
            }
            .background(Color("scribeAppBackground"))
            .navigationBarHidden(true)
        }
    }
}
