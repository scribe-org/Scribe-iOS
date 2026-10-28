// SPDX-License-Identifier: GPL-3.0-or-later

/**
 * Displays a single tutorial chapter with multi-step support and interactive text field.
 * Handles correct/incorrect feedback states as per the Figma designs.
 * Supports full-tutorial sequential navigation through allChapters.
 * Shows "Non-Scribe keyboard" warning if a non-Scribe keyboard is active.
 *
 * Nav bar rules (matching Figma):
 *   - idle state:    "< Quick tutorial"  (leading only, no xmark)
 *   - feedback state: "<" bare chevron (leading) + xmark (trailing)
 *   - wrong keyboard: "<" bare chevron (leading) + xmark (trailing)
 */

import SwiftUI

struct TutorialChapterView: View {
    let chapter: TutorialChapter
    let allChapters: [TutorialChapter]
    var isFullTutorial: Bool = false

    @Environment(\.dismiss) private var dismiss
    @State private var stepIndex: Int = 0
    @State private var inputText: String = ""
    @State private var feedbackState: FeedbackState = .idle
    @State private var navigateToNext = false
    @State private var nextChapter: TutorialChapter?
    @State private var showWrongKeyboard = false

    enum FeedbackState { case idle, correct, incorrect }

    private var currentStep: TutorialStep { chapter.steps[stepIndex] }
    private var isLastStep: Bool { stepIndex == chapter.steps.count - 1 }
    private var isLastChapter: Bool { chapter == allChapters.last }

    /// True when the user has typed something (correct or incorrect) — drives nav bar style.
    private var hasFeedback: Bool { feedbackState != .idle }

    private func nextChapterInSequence() -> TutorialChapter? {
        guard let idx = allChapters.firstIndex(of: chapter), idx + 1 < allChapters.count else {
            return nil
        }
        return allChapters[idx + 1]
    }

    var body: some View {
        ZStack {
            Color("scribeAppBackground").ignoresSafeArea()

            if showWrongKeyboard {
                // Non-Scribe keyboard warning screen
                VStack(alignment: .leading, spacing: 12) {
                    Spacer()
                    Text(NSLocalizedString(
                        "i18n.app.tutorial.wrong_keyboard.title",
                        value: "Non-Scribe keyboard",
                        comment: ""
                    ))
                    .font(.title.bold())
                    .foregroundColor(.primary)
                    .padding(.horizontal, 16)

                    Text(NSLocalizedString(
                        "i18n.app.tutorial.wrong_keyboard.body",
                        value: "Press the 🌐 button to select a Scribe keyboard.",
                        comment: ""
                    ))
                    .font(.body)
                    .foregroundColor(.primary)
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemBackground))
                    .cornerRadius(10)
                    .padding(.horizontal, 16)

                    Spacer()
                }
            } else {
                VStack(spacing: 0) {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            VStack(alignment: .leading, spacing: 12) {
                                // Title
                                Text(chapter.title)
                                    .font(.title.bold())
                                    .foregroundColor(.primary)

                                // Instructions
                                Text(currentStep.instructions)
                                    .font(.body)
                                    .foregroundColor(.primary)

                                // Language note
                                if let note = currentStep.languageNote {
                                    HStack(alignment: .top, spacing: 8) {
                                        Image(systemName: "globe")
                                            .foregroundColor(.secondary)
                                            .font(.footnote)
                                            .padding(.top, 2)
                                        Text(note)
                                            .font(.footnote)
                                            .foregroundColor(.secondary)
                                    }
                                }

                                // Interactive text field — only for steps with expected input
                                if currentStep.expectedInput != nil {
                                    VStack(alignment: .leading, spacing: 4) {
                                        TextField("", text: $inputText)
                                            .font(.body)
                                            .padding(.vertical, 4)
                                            .onChange(of: inputText) { newValue in
                                                validateInput(newValue)
                                            }

                                        Divider()

                                        if feedbackState == .correct {
                                            Text(NSLocalizedString(
                                                "i18n.app.tutorial.correct_feedback",
                                                value: "Great! Press Next to continue.",
                                                comment: ""
                                            ))
                                            .font(.footnote)
                                            .foregroundColor(.green)
                                        } else if feedbackState == .incorrect {
                                            Text(currentStep.incorrectFeedback)
                                                .font(.footnote)
                                                .foregroundColor(.red)
                                        }
                                    }
                                }
                            }
                            .padding(16)
                            .background(Color(.systemBackground))
                            .cornerRadius(12)
                            .padding(.horizontal, 16)
                            .padding(.top, 16)
                        }
                    }

                    Spacer()

                    // Hidden navigation link for next chapter
                    if let next = nextChapter {
                        NavigationLink(
                            destination: TutorialChapterView(
                                chapter: next,
                                allChapters: allChapters,
                                isFullTutorial: true
                            ),
                            isActive: $navigateToNext
                        ) { EmptyView() }
                    }

                    // Next / Finish button
                    CTAButton(
                        title: isLastChapter && isLastStep
                            ? NSLocalizedString("i18n.app.tutorial.finish", value: "Finish tutorial", comment: "")
                            : NSLocalizedString("i18n._global.next", value: "Next", comment: ""),
                        action: { handleNext() }
                    )
                    .padding(.horizontal, 16)
                    .padding(.bottom, 32)
                }
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button { dismiss() } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text(NSLocalizedString(
                            "i18n.app.tutorial.title", value: "Quick tutorial", comment: ""
                        ))
                        .opacity(hasFeedback || showWrongKeyboard ? 0 : 1)
                    }
                }
            }
        }
        .overlay(alignment: .topTrailing) {
            if hasFeedback || showWrongKeyboard {
                Button { dismiss() } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.primary)
                        .padding(.trailing, 16)
                        .padding(.top, 12)
                }
            }
        }
        .onAppear {
            checkKeyboard()
        }
    }

    // MARK: - Helpers

    private func checkKeyboard() {
        // Show wrong-keyboard screen if no Scribe keyboard is active.
        // We reuse the detector: if installed list is non-empty but none are Scribe, warn.
        let installed = TutorialKeyboardDetector.installedScribeLanguages()
        showWrongKeyboard = !installed.isEmpty && !TutorialKeyboardDetector.hasNounAnnotationKeyboard()
            && installed.allSatisfy { $0.lowercased() == "english" }
    }

    private func validateInput(_ text: String) {
        guard let expected = currentStep.expectedInput else { return }
        let trimmed = text.trimmingCharacters(in: .whitespaces)
        if trimmed.lowercased() == expected.lowercased() {
            feedbackState = .correct
        } else if trimmed.isEmpty {
            feedbackState = .idle
        } else {
            feedbackState = .incorrect
        }
    }

    private func handleNext() {
        if !isLastStep {
            stepIndex += 1
            inputText = ""
            feedbackState = .idle
        } else if isFullTutorial, let next = nextChapterInSequence() {
            nextChapter = next
            navigateToNext = true
        } else {
            dismiss()
        }
    }
}
