/**
 * TranslationFeatureTests.swift
 *
 * Copyright (C) 2024 Scribe
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import XCTest
@testable import Scribe_iOS

final class TranslationFeatureTests: XCTestCase {

    func testTranslationHelloInAllLanguages() {
        
        let translator = Translator()
        let inputWord = "hello"
        let expectedTranslations = [
            "French": "bonjour",
            "German": "hallo",
            "Italian": "ciao",
            "Portuguese": "olá",
            "Russian": "привет",
            "Spanish": "hola",
            "Swedish": "hej"
        ]

        for (language, expectedTranslation) in expectedTranslations {
            let translatedWord = translator.translate(word: inputWord, to: language)

            XCTAssertEqual(translatedWord, expectedTranslation, "The translation for '\(inputWord)' in \(language) should be '\(expectedTranslation)'.")
        }
    }
}
