# Changelog

Scribe-iOS tries to follow [semantic versioning](https://semver.org/), a MAJOR.MINOR.PATCH version where increments are made of the:

- MAJOR version when we make incompatible API changes
- MINOR version when we add functionality in a backwards compatible manner
- PATCH version when we make backwards compatible bug fixes

Emojis for the following are chosen based on [gitmoji](https://gitmoji.dev/).

# Scribe 1.1.0 (WIP)

### 🌐 New Keyboards

- Adds Russian, French, Portuguese and Swedish keyboards.
- Verb conjugation support is currently limited, but noun annotation, plural and `beta` translation are available.

### ✨ New Features

- Hold-to-select functionality for symbols.

### 🎨 Design Changes

- Improves the display of the caps lock key by making its background the key pressed color.
- Updates the App Store images and videos.

### 🗃️ Data Added

- Adds baseline noun, verb, translation and preposition data for the new keyboards and adds more data to those already included:

  - German: corrected many prepositions
  - French:
  - Portuguese:
  - Russian:
  - Spanish:
  - Swedish:

### 🐛 Bug Fixes

- German keyboards had the dollar sign shown on the number keys instead of the euro sign.
- iPads had a semicolon key that also had apostrophes.
- Hold-to-select keys wouldn't return to their original color.
- The keyboard wouldn't always be letter keys when switched to.
- The double space period shortcut wasn't possible after certain special characters and numbers.
- More than one singular gender wasn't being assigned to German nouns in the formatting process.
<!-- - Removes noun-gender annotation for given names to avoid misgendering people. -->

### ♻️ Code Refactoring

- Combines all the space bar logic into one and renames the key based on the keyboard.

# Scribe 1.0.1 (December 4th, 2021)

### ✨ New Features

- Comma-space to letter keys functionality.
- Question mark and exclamation point followed by space to capital letter keys functionality.

### 🎨 Design Changes

- Fixes the display of the system header in the app when the user is in dark mode, as the white text was hard to read.
- Fixes the display of the scroll bar in the app when the user is in dark mode, as the white bar wasn't visually appealing.
- The keyboard has been made taller for iPhones to make the buttons larger vertically.
- More space has been added around the buttons to make them better resemble system keyboard spacing.

### 🐛 Bug Fixes

- The select keyboard button wouldn't be able to be long held after an initial button is pressed.
- Canceling a command would cause the preview bar to read "Not in directory" on a subsequent command.
- The double space period shortcut was being triggered without intent.

### ♻️ Code Refactoring

- The hold-to-select character functions are now combined into one.

### 🚚 File Movement

- Moved the contribution guidelines to the main directory.

# Scribe 1.0.0 (November 30th, 2021)

### MVP release of Scribe - Language Keyboards

### 🚀 Deployment

- Releasing for iPhone and iPad.

### 🌐 Keyboards

- Keyboards for German and Spanish.

### ✨ Features

- Keyboard extensions that can be used in any app.
- Annotation of words in the preview bar including the genders of nouns and cases that follow prepositions.
- Basic English to keyboard language translations.
- Querying the plurals of nouns.
- Conjugations of verbs.

### 🗃️ Data

- Wikidata WDQS queries saved so that data can be updated before releases.
- Data formatting done via Python scripts.
- Data saved in JSON files in app to allow for quick access that doesn't require an internet connection.
- Nouns, verbs and prepositions (where applicable).
- Translations of English words via 🤗 Transformers.
- Adds baseline noun, verb, translation and preposition data for the new keyboards.
  - German: 27K+ nouns, 3K+ verbs, 65K+ translations, 190 prepositions
  - Spanish: 8K+ nouns, 65 verbs, 65K+ translations

### 🎨 Design

- The Scribe key and preview bar where Scribe commands are triggered.
- 3x2 conjugation tables from which conjugations can be selected in the `Conjugate` command.
- The return key is colored Scribe blue when commands are being triggered to let the user know that that is what they need to press to finish the command.
- Dark mode compatibility.
