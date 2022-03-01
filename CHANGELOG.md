# Changelog

Scribe-iOS tries to follow [semantic versioning](https://semver.org/), a MAJOR.MINOR.PATCH version where increments are made of the:

- MAJOR version when we make incompatible API changes
- MINOR version when we add functionality in a backwards compatible manner
- PATCH version when we make backwards compatible bug fixes

Emojis for the following are chosen based on [gitmoji](https://gitmoji.dev/).

<!--# Scribe 1.4.0 (WIP)-->
<!---->
<!--Scribe's second design sprint with Spencer Arney focussed on key styling and onboarding users.-->
<!---->
<!--### 🎨 Design Changes-->
<!---->
<!--- A quick tutorial has been added to the app to show new users how it works. -->
<!--- The app screen fields have been made larger and the text size has also been increased. -->
<!--- Settings have been added to the top left of the app screen that allows users to access the home screen, language practice section, keyboard settings, privacy policy, contact options, and a description of how Wikidata links to Scribe. -->

# Scribe 1.3.1 (WIP)

### 🗃️ Data Added

### 🐞 Bug Fixes

- The alternate characters of apostrophes and quotation marks have been fixed.
<!-- - The width of alternate character callouts for certain keys has been fixed for iPhones. -->

# Scribe 1.3.0

### ⌨️ New Keyboards

- Adds an Italian keyboard.

### 🗃️ Data Added

- Italian: 773 nouns, 70 verbs

### 🎨 Design Changes

- The messages that tell the user a noun is already plural have been translated to the keyboard's language.
- The keyboard height has been increased for landscape mode on iPads.
- Characters on keys have been made larger so they reflect the system keyboards better.
- All letter, number and special keys now pop up after being pressed.
- Hold to select characters have been redesigned to reflect the addition of keys popping up.
- All App Store media has been redone to reflect these changes.

# Scribe 1.2.1

### ✨ New Features

- The keyboard switches back to letter keys after all appropriate symbols followed by space.
- Scribe commands now accept inputs that are followed by a space in case the user accidentally added one.
- Users can now translate pronouns as these were not originally included.

### 🗃️ Data Added

- French: 30 nouns, 1 verb
- German: 215 nouns
- Portuguese: 66 nouns
- Russian: 2 nouns
- Spanish: 925 nouns, 19 verbs
- Swedish: 10 nouns, 5 verbs

### 🎨 Design Changes

- The app screen texts are given slightly more room to expand within their fields.
- The App Store description has been simplified with bullet points.
- The conjugate view right and left buttons have been made wider.

### 🐞 Bug Fixes

- The Scribe key now switches its icon color with the rest of the keyboard when the user changes color modes.
- Annotations are no longer triggered if a user presses space during a command.

### ♻️ Code Refactoring

- Commands buttons are now called keys and the preview bar has been renamed the command bar.
- Force casts are used as little as possible.
- All lines have been reduced to a reasonable length (120 characters) where able.
- All functions have been reduced to a reasonable length (40 lines) where able.
- All functions have been reduced to a reasonable cyclomatic complexity (10 or less) where able.
- All files have been reduced to a reasonable length (400 lines) where able.
- All type bodies have been reduced to a reasonable length (200 lines) where able.
- Scribe has been modularized to be more easily worked with.
- The app screen's text was moved to a new directory where localizations will be stored.

# Scribe 1.2.0

Scribe's first design sprint with the help of Berlin's Spencer Arney!

The entire layout of Scribe has been reworked to make the experience more aesthetically appealing while adding functionality through efficient design. We hope you like the result!

### ✨ New Features

- Users can now get to Settings by clicking the installation steps in the app screen.
- All keyboards now switch to an English keyboard for translation, with this being in preparation for when more languages can be translated from.

### 🎨 Design Changes

- The logo and icon for Scribe have been reworked to give the app a distinct style.
- The app screen has been completely redone to be more appealing.
- Keyboard layouts, colors and characters have been changed to match system keyboards.
- Translation prompts were changed to be two digit abbreviations of source and target language.
- Colors for noun annotation were updated to improve readability.
- Noun annotation is now done with a square symbol to represent the gender.
- Preposition annotation is now done with a rectangular symbol to represent the case.
- Preposition case abbreviations have been changed to match the language of the keyboard.
- All App Store media has been redone to reflect these changes.

### 🐞 Bug Fixes

- The keyboard colors should not switch randomly between light and dark mode now.
- Removed an additional character from the Spanish iPad keyboard's special keys.

### ⚖️ Legal

- The privacy policy was updated to reflect the addition of the GitHub, Inc icon into the app.

# Scribe 1.1.1

### 🗃️ Data Added

Data updates are now all done through a single Python file - update_data.py.

- French: 11 nouns
- German: 152 nouns, 1 verb, 1 preposition
- Portuguese: 19 nouns
- Spanish: 13 nouns, 6 verbs
- Swedish: 68 nouns

### 🎨 Design Changes

- The text size for the command bar in landscape mode for phones was made smaller.
- The height of the keyboard in landscape mode for phones was made slightly smaller.
- App store images were updated to combine the dark mode and devices screens.

### 🐞 Bug Fixes

- The keyboard colors now update if the user switches between light and dark mode.
- Auto-capitalization and switching to the letter keys weren't always triggered after a period.
- Shifting orientation from portrait to landscape is now seamless, but landscape to portrait is still a WIP.

### ♻️ Code Refactoring

- Queries were refactored to reduce their total characters so they can be sent through query APIs.
- Command variables were edited to interact with new formatting from query refactoring.

# Scribe 1.1.0

### ⌨️ New Keyboards

- Adds Russian, French, Portuguese and Swedish keyboards.

### ✨ New Features

- Hold-to-select functionality for symbol keys.
- The keyboard keys are capitalized if the user deletes at the start of the command bar.
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

### 🐞 Bug Fixes

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

# Scribe 1.0.1

### ✨ New Features

- Comma-space to letter keys functionality.
- Question mark and exclamation point followed by space to capital letter keys functionality.

### 🎨 Design Changes

- Fixes the display of the system header in the app when the user is in dark mode, as the white text was hard to read.
- Fixes the display of the scroll bar in the app when the user is in dark mode, as the white bar wasn't visually appealing.
- The keyboard has been made taller for iPhones to make the buttons larger vertically.
- More space has been added around the buttons to make them better resemble system keyboard spacing.

### 🐞 Bug Fixes

- The select keyboard button wouldn't be able to be long held after an initial button is pressed.
- Canceling a command would cause the command bar to read "Not in directory" on a subsequent command.
- The double space period shortcut was being triggered without intent.

### ♻️ Code Refactoring

- The hold-to-select character functions are now combined into one.

# Scribe 1.0.0

### MVP release of Scribe - Language Keyboards

### 🚀 Deployment

- Releasing for iPhone and iPad.

### ⌨️ Keyboards

- Keyboards for German and Spanish.

### ✨ Features

- Keyboard extensions that can be used in any app.
- Annotation of words in the command bar including the genders of nouns and cases that follow prepositions.
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

- The Scribe key and command bar where Scribe commands are triggered.
- 3x2 conjugation tables from which conjugations can be selected in the `Conjugate` command.
- The return key is colored Scribe blue when commands are being triggered to let the user know that that is what they need to press to finish the command.
- Dark mode compatibility.
