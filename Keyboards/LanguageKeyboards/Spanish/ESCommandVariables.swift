// SPDX-License-Identifier: GPL-3.0-or-later

/// Returns the reflexive pronoun for a given pronoun.
func getESReflexivePronoun(pronoun: String) -> String {
  if pronoun == "yo" {
    return "me"
  } else if pronoun == "tú" {
    return "te"
  } else if ["él", "ella", "usted", "ellos", "ellas", "ustedes"].contains(pronoun) {
    return "se"
  } else if ["nosotros", "nosotras"].contains(pronoun) {
    return "nos"
  } else if ["vosotros", "vosotras"].contains(pronoun) {
    return "os"
  } else {
    return ""
  }
}
