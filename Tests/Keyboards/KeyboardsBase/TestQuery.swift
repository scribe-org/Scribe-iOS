/**
 * TestQuery.swift
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
@testable import Scribe

final class ScribeFunctionalityTests: XCTestCase {
    
    func testQueryPlural_EmptyInput() {
        // Mock UILabel
        let commandBar = UILabel()
        commandBar.text = ""
        
        // Call the function
        queryPlural(commandBar: commandBar)
        
        // Assert: No text inserted, proxy state unchanged
        XCTAssertEqual(proxy.text, "")
        XCTAssertEqual(commandState, .default) // Assuming .default is the initial state
    }
    
    func testQueryPlural_TypicalNoun() {
        // Mock UILabel
        let commandBar = UILabel()
        commandBar.text = "plural:cat"
        
        // Call the function
        queryPlural(commandBar: commandBar)
        
        // Assert: Correct plural inserted
        XCTAssertEqual(proxy.text, "cats ") // Assuming a space is added
    }
    
    func testQueryPlural_AlreadyPlural() {
        // Mock UILabel
        let commandBar = UILabel()
        commandBar.text = "plural:cats"
        
        // Call the function
        queryPlural(commandBar: commandBar)
        
        // Assert: Input recognized as already plural
        XCTAssertEqual(proxy.text, "cats ") // Output matches input
        XCTAssertEqual(commandState, .alreadyPlural)
    }
    
    func testQueryPlural_CapitalizedNoun() {
        // Mock UILabel
        let commandBar = UILabel()
        commandBar.text = "plural:Dog"
        
        // Call the function
        queryPlural(commandBar: commandBar)
        
        // Assert: Capitalization preserved in plural
        XCTAssertEqual(proxy.text, "Dogs ")
    }
    
    func testQueryTranslation_EmptyInput() {
        // Mock UILabel
        let commandBar = UILabel()
        commandBar.text = ""
        
        // Call the function
        queryTranslation(commandBar: commandBar)
        
        // Assert: No text inserted, proxy state unchanged
        XCTAssertEqual(proxy.text, "")
        XCTAssertEqual(commandState, .default) // Assuming .default is the initial state
    }
    
    func testQueryTranslation_ValidWord() {
        // Mock UILabel
        let commandBar = UILabel()
        commandBar.text = "translate:hello"
        
        // Call the function
        queryTranslation(commandBar: commandBar)
        
        // Assert: Correct translation inserted
        XCTAssertEqual(proxy.text, "hola ") // Assuming 'hola' is the translation for 'hello'
    }
    
    func testQueryTranslation_CapitalizedWord() {
        // Mock UILabel
        let commandBar = UILabel()
        commandBar.text = "translate:Hello"
        
        // Call the function
        queryTranslation(commandBar: commandBar)
        
        // Assert: Capitalization preserved in translation
        XCTAssertEqual(proxy.text, "Hola ")
    }
}
