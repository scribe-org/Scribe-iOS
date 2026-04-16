// SPDX-License-Identifier: GPL-3.0-or-later

/**
 * Entry point for the Quick Tutorial flow (Tutorial - Light - 0.0).
 * Shows chapter list and "Start full tutorial" button.
 * Hides noun annotation chapter if only English keyboard is installed.
 */

import SwiftUI

struct TutorialView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var startFull = false
    @State private var selectedChapter: TutorialChapter? = nil

    private let chapters = TutorialKeyboardDetector.availableChapters()

    var body: some View {
        NavigationView {
            ZStack {
                Color("scribeAppBackground").ignoresSafeArea()

                VStack(alignment: .leading, spacing: 0) {
                    // Tip card
                    TutorialTipCard()
                        .padding(.horizontal, 16)
                        .padding(.top, 16)

                    // Description card
                    Text(NSLocalizedString(
                        "i18n.app.tutorial.description",
                        value: "This quick tutorial will show you how to use Scribe to support writing in your target language.",
                        comment: ""
                    ))
                    .font(.footnote)
                    .foregroundColor(.primary)
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemBackground))
                    .cornerRadius(10)
                    .padding(.horizontal, 16)
                    .padding(.top, 8)

                    // Chapter list heading
                    Text(NSLocalizedString(
                        "i18n.app.tutorial.chapters", value: "Tutorial chapters", comment: ""
                    ))
                    .font(.headline)
                    .foregroundColor(.primary)
                    .padding(.horizontal, 16)
                    .padding(.top, 20)
                    .padding(.bottom, 8)

                    // Chapter rows
                    VStack(spacing: 0) {
                        ForEach(chapters) { chapter in
                            NavigationLink(
                                destination: TutorialChapterView(
                                    chapter: chapter,
                                    allChapters: chapters,
                                    isFullTutorial: false
                                )
                            ) {
                                HStack {
                                    Text(chapter.title)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.secondary)
                                        .font(.caption)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 14)
                            }
                            if chapter != chapters.last {
                                Divider().padding(.leading, 16)
                            }
                        }
                    }
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .padding(.horizontal, 16)

                    Spacer()

                    // Start full tutorial
                    if let first = chapters.first {
                        NavigationLink(
                            destination: TutorialChapterView(
                                chapter: first,
                                allChapters: chapters,
                                isFullTutorial: true
                            ),
                            isActive: $startFull
                        ) { EmptyView() }
                    }

                    CTAButton(
                        title: NSLocalizedString(
                            "i18n.app.tutorial.start_full", value: "Start full tutorial", comment: ""
                        ),
                        action: { startFull = true }
                    )
                    .padding(.horizontal, 16)
                    .padding(.bottom, 32)
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button { dismiss() } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text(NSLocalizedString(
                                "i18n.app.about.title", value: "About", comment: ""
                            ))
                        }
                    }
                }
            }
        }
    }
}
