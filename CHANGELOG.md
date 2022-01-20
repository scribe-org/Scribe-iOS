# Changelog

Scribe-iOS tries to follow [semantic versioning](https://semver.org/), a MAJOR.MINOR.PATCH version where increments are made of the:

- MAJOR version when we make incompatible API changes
- MINOR version when we add functionality in a backwards compatible manner
- PATCH version when we make backwards compatible bug fixes

Emojis for the following are chosen based on [gitmoji](https://gitmoji.dev/).

# Scribe 1.2.0 (WIP)

Scribe's first design sprint with the help of Berlin's Spencer Arney!

### 🎨 Design Changes

- The keyboard buttons have been made slightly wider.
<!--- All App Store media has been improved to reflect these changes.-->

# Scribe 1.1.1

### 🗃️ Data Added

Data updates are now all done through a single Python file - update_data.py.

- French: 11 nouns
- German: 152 nouns, 1 verb, 1 preposition
- Portuguese: 19 nouns
- Spanish: 13 nouns, 6 verbs
- Swedish: 68 nouns

### 🎨 Design Changes

- The text size for the preview bar in landscape mode for phones was made smaller.
- The height of the keyboard in landscape mode for phones was made slightly smaller.

### 🐛 Bug Fixes

- The keyboard colors now update if the user switches between light and dark mode.
- Auto-capitalization and switching to the letter keys weren't always triggered after a period.
- Shifting orientation from portrait to landscape is now seamless, but landscape to portrait is still a WIP.

### ♻️ Code Refactoring

- Queries were refactored to reduce their total characters so they can be sent through query APIs.
- Command variables were edited to interact with new formatting from query refactoring.

# Scribe 1.1.0

### 🌐 New Keyboards

- Adds Russian, French, Portuguese and Swedish keyboards.

### ✨ New Features

- Hold-to-select functionality for symbol keys.
- The keyboard keys are capitalized if the user deletes at the start of the preview bar.
- Removes noun-gender annotation for given names to avoid misgendering people.
- Users are now able to pass upper-case arguments to translate and conjugate.

### 🗃️ Data Added

- French (New): 15,710 nouns, 1,241 verbs (mostly infinitives), 67,609 translations
- German: 401 nouns, 78 verbs, corrected many prepositions
- Portuguese (New): 4,530 nouns, 188 verbs, 67,609 translations
- Russian (New): 194,389 nouns, 11 verbs, 12 prepositions, 67,609 translations
- Spanish: 180 nouns, 22 verbs
- Swedish (New): 41,102 nouns, 4,133 verbs, 67,609 translations

### 🎨 Design Changes

- Improves the display of the caps lock key by making its background the key pressed color.
- Updates the App Store images and videos.
- Scribe command titles are now in the keyboard language for a more immersive experience.
- Translate for Russian switches to an English keyboard.

### 🐛 Bug Fixes

- German keyboards had the dollar sign shown on the number keys instead of the euro sign.
- iPads had a semicolon key that also had apostrophes.
- Hold-to-select keys wouldn't return to their original color.
- The keyboard wouldn't always be letter keys when switched to.
- The double space period shortcut wasn't possible after certain special characters and numbers.
- More than one singular gender wasn't being assigned to German nouns in the formatting process.

### ♻️ Code Refactoring

- Combines all the space bar logic into one and renames the key based on the keyboard.
- Combines all conjugation logic into one function that is accessed by each button press case.
- Combines all noun annotation logic into one function that accessed by child functions.

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
