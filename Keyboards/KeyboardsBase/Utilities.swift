// SPDX-License-Identifier: AGPL-3.0-or-later

/**
 * Simple utility functions for data extraction and language management.
 */

/// Checks if an extra space is needed in the text field when generated text is inserted
func getOptionalSpace() -> String {
  if proxy.documentContextAfterInput?.first == " " {
    return ""
  } else {
    return " "
  }
}
