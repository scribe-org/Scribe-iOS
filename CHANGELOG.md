# Changelog

See the [releases for Scribe-iOS](https://github.com/scribe-org/Scribe-iOS/releases) for an up to date list of versions and their release dates. Versions that are marked as released may yet to be in the App Store if it's within the 48 hour submission review period.

Scribe-iOS tries to follow [semantic versioning](https://semver.org/), a MAJOR.MINOR.PATCH version where increments are made of the:

- MAJOR version when we make incompatible API changes
- MINOR version when we add functionality in a backwards compatible manner
- PATCH version when we make backwards compatible bug fixes

Emojis for the following are chosen based on [gitmoji](https://gitmoji.dev/).

# [Unreleased] Scribe-iOS 2.2.0

### 🗃️ Data Added

### ✨ New Features

<!--- Scribe data is now loaded into SQLite database tables to make data reference less memory intensive and mitigate crashes.-->
- Emoji autocompletions and autosuggestions are now available as the user types.
  - There are a maximum of two emojis available to select on iPhones and three on iPads.
  - The user can also repeat emoji autocompletions and autosuggestions.
<!--- Emoji autocomplete and autosuggest keywords have also been added as possible autocompletion words.-->
- Added action to command bar information icon.
- Added highlight for autocompletion if it is the word typed.
- If a word is the only autosuggestion, hitting the space bar inserts the suggestion. Added undo functionality if the user does not want the completion.
- Added Demonstrative pronouns to German preposition declension tables.
- Added contracted preposition annotation to the German keyboard.
- Double dash inserts an em dash in the text proxy.

### 🎨 Design Changes

- The resolution of the Scribe key has been improved.
- Scribe blue for dark mode has been made darker to fit the keyboard better.
- The app icon, app screen background, and other branding elements have been changed to reflect the change in the dark version of Scribe blue.
- The app icon has been made more modern and glossy and the direct shadow has been removed.
- The return button for the keyboard has been changed to display "search" whenever a web browser is being used.
- The Scribe application also receives dark mode in this version.
- Minor adjustments to the original app screen texts and colors have been made.
- The select keyboard button has been moved to the bottom left most position on iPads.

# Scribe-iOS 2.1.0

### ⌨️ New Keyboards

- Adds a QWERTY keyboard option for French.

### ✨ New Features

- The left and right buttons in the conjugation and declination views are disabled now if pressing them will not lead to a change in the view.
- Autosuggestions for pronouns have been improved for German, French and Spanish.
- The keyboards shift state is disabled by pressing an autocompletion or autosuggestion.
- Autocomplete now functions after quotes, slashes and hashtags.
- Scribe can now access unordered names in the user's contacts to present them as autocompletions.
- The delete button now speeds up as the user holds it.
- Typing a period, comma, question mark or exclamation point now removes a space before them if there is one.

### 🗃️ Data Added

Thousands of new French verb conjugations have been added!

- French: 134 nouns, 3905 verbs
- German: 42 nouns, 15 verbs
- Italian: 247 nouns
- Portuguese: 15 nouns
- Russian: 11 nouns
- Spanish: 2472 nouns, 244 verbs
- Swedish: 89 nouns

### 🎨 Design Changes

- The labels for conjugations and declinations have been made darker in dark mode to be more readable.
- French keyboards are now named based on their keyboard style.
- Keyboards will now display the language followed by "(Scribe)" for a second before showing the language's word for space, similar to the system keyboards.

### 🐞 Bug Fixes

- The accent character on the French letters keyboard is now the correct character.
- Indentation has been removed from all Scribe JSON files to reduce their file size, speed up the load times and mitigate crashes.

### ♻️ Code Refactoring

- Loading JSONs for language data is now handled by SwiftyJSON, with the code being refactored to implement it.
  - This is a first step in refining the data loading process to better handle large amounts of data.
- Light and dark mode colors are now defined in `Assets.xcassets` and accessed via `ScribeColor.getter:color` or `UIColor`'s new convenience initializer.
- Variants of the Scribe key icon are placed into `Assets.xcassets`, making it unnecessary to check for light/dark mode and device type in code.

# Scribe-iOS 2.0.0

### ✨ New Features

- Scribe now includes a baseline Wikidata and Wikipedia based autocomplete feature.
  - Suggestions include the next possible noun as well as the most common words in the keyboard language.
- Scribe now includes a baseline autosuggest feature that suggests words derived from Wikipedia that most often follow a given word.
- Preposition annotations can now be clicked to display a case pronoun display from which pronouns can be selected.
  - Users are able to select from the display based on subjects and objects to exactly specify which pronoun they need.

### 🗃️ Data Added

- French: 307 nouns, 39 verbs
- German: 282 nouns, 73 verbs
- Italian: 4,236 nouns
- Portuguese: 64 nouns
- Russian: 7 nouns, 1 preposition
- Spanish: 1,387 nouns, 9 verbs
- Swedish: 702 nouns, 120 verbs

### 🎨 Design Changes

- Noun and preposition annotation has been updated to not show the word being annotated.
  - This saves space above the keyboard for autocomplete and autosuggest.
- The annotation colors have been changed to match the new backgrounds.
- The delete key features a pressed state style similar to the native keyboard.
- New layouts for pronoun declination have been added to the keyboards.
- The message indicating that the word isn't in Wikidata now comes with an information icon (action pending).
- The App Store images have been updated to reflect the new Wikipedia based autosuggest.
- The App Store videos have been updated to reflect the changes for the new version.
- iPhone 6.7" images and videos have been added to the App Store.
- Other minor changes to images for the App Store.

### 🌐 Localization

- Russian keyboard command names and messages were corrected.

### ⚖️ Legal

- The privacy policy was updated to add information about the Wikipedia text data terms of use.

### ♻️ Code Refactoring

- Boolean states for commands were converted into a single enum to make keyboard states much simpler to work with.
- Code was refactored to work with the new enum style of command state management.
- Enums are now used to control switching between conjugations.
- Enums are now used to control switching between different conjugation displays.

# Scribe-iOS 1.4.0

### ✨ New Features

- Commands now include a greyed out prompt that tells the user to enter a specific word type.
- The return key now changes its icon during commands to make it more apparent as the execution input.
- The link to GitHub in the app now goes to the iOS repo instead of the organization.

### 🗃️ Data Added

- French: 141 nouns, 5 verbs
- German: 203 nouns, 88 verbs
- Italian: 3316 nouns
- Portuguese: 3 nouns
- Spanish: 2282 nouns, 66 verbs
- Swedish: 14 nouns, 114 verbs

### 🎨 Design Changes

- The content for the App Store images has been centered more exactly.
- The App Store images for translation have been changed to reflect the new enter key design.
- Key pressed colors have been made darker to be more distinct from base key colors.

# Scribe-iOS 1.3.8

### 🗃️ Data Added

- French: 160 nouns, 5 verbs
- German: 502 nouns, 57 verbs
- Italian: 35 nouns
- Portuguese: 51 nouns, 14 verbs
- Russian: 2 nouns
- Spanish: 793 nouns, 174 verbs
- Swedish: 8 nouns

### 🐞 Bug Fixes

- Verb conjugation tables now always return to their base conjugation each time the command is used.

### 🎨 Design Changes

Scribe's second design sprint with Spencer Arney focussed on the App Store media:

- The App Store images have been updated to be more professional and drive discovery.
- Some App Store images have been replaced with ones that better show app features.
- Section headers for App Store videos have been changed to match the new image style.

# Scribe-iOS 1.3.7

### 🗃️ Data Added

- French: 34 nouns
- German: 56 nouns, 112 verbs
- Italian: 24 nouns, 1 verb
- Portuguese: 169 nouns, 290 verbs
- Russian: 2 nouns
- Spanish: 3216 nouns, 267 verbs
- Swedish: 287 nouns, 13 verbs

### 🎨 Design Changes

- Minor update to the command bar border color.

### ⚖️ Legal

- The privacy policy was updated to add the MIT licensed original source code.

# Scribe-iOS 1.3.6

### 🗃️ Data Added

- French: 220 nouns, 248 verbs
- German: 45 nouns, 73 verbs
- Italian: 4 nouns
- Portuguese: 218 nouns, 1 verb
- Spanish: 6650 nouns, 70 verbs
- Swedish: 512 nouns, 9 verbs

# Scribe-iOS 1.3.5

### 🗃️ Data Added

- French: 31 nouns, 2 verbs
- German: 53 nouns, 9 verbs
- Italian: 1 noun, 1 verb
- Portuguese: 9 nouns, 1 verb
- Russian: 3 nouns
- Spanish: 876 nouns, 1203 verbs
- Swedish: 8 nouns, 1 verb

### 🎨 Design Changes

- Captions and text spacing for App Store images have been updated.
- "Not in directory" messages have been changed to "Not in Wikidata" to further signal affiliation with the service.

### ♻️ Code Refactoring

- The data files have been moved to a new directory within the organization on GitHub.

# Scribe-iOS 1.3.4

### 🎨 Design Changes

- Captions for App Store images have been updated.
- The App Store description has been updated with a reference to Wikidata and grammar improvements.
- The open-source images in the App Store has been updated to reference open data and Wikidata.

### ⚖️ Legal

- The privacy policy was updated to reflect the addition of the Wikidata logo into the app.

# Scribe-iOS 1.3.3

### 🗃️ Data Added

- French: 2 nouns
- Portuguese: 2 nouns
- Spanish: 3 nouns, 59 verbs

### 🐞 Bug Fixes

- Key long press for alternate characters has had cancellation removed to avoid buggy performance.

# Scribe-iOS 1.3.2

### 🗃️ Data Added

- French: 3 nouns
- German: 28 nouns
- Portuguese: 2 nouns
- Spanish: 13 nouns, 66 verbs
- Swedish: 1 noun

### 🎨 Design Changes

- Key alternate views appear more quickly.

### 🐞 Bug Fixes

- Key long press cancellation was switched from changed to cancel to avoid unnecessary cancels.

# Scribe-iOS 1.3.1

### 🗃️ Data Added

- French: 32 nouns, 5 verbs
- German: 172 nouns, 4 verbs
- Italian: 10 nouns, 1 verb
- Portuguese: 43 nouns, 1 verb
- Russian: 7 nouns
- Spanish: 188 nouns, 1,825 verbs
- Swedish: 6 nouns

### 🐞 Bug Fixes

- The alternate characters of apostrophes and quotation marks have been fixed.
- Key alternate views now stay if the key is canceled as they were disappearing too easily.
- The width of alternate character callouts for certain keys has been fixed for iPhones.

# Scribe-iOS 1.3.0

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

# Scribe-iOS 1.2.1

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

# Scribe-iOS 1.2.0

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

# Scribe-iOS 1.1.1

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

# Scribe-iOS 1.1.0

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

# Scribe-iOS 1.0.1

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

# Scribe-iOS 1.0.0

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
