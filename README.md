<div align="center">
  <a href="https://github.com/scribe-org/Scribe-iOS"><img src="https://github.com/scribe-org/Scribe-iOS/blob/main/Resources/Scribe-iOS_logo_transparent.png" width=612 height=164></a>
</div>

---

<!--
[![license](https://img.shields.io/github/license/scribe-org/Scribe-iOS.svg)](https://github.com/scribe-org/Scribe-iOS/blob/main/LICENSE.txt)
-->

[![coc](https://img.shields.io/badge/coc-Contributor%20Covenant-ff69b4.svg)](https://github.com/scribe-org/Scribe-iOS/blob/main/.github/CODE_OF_CONDUCT.md)

[![Available on the App Store](http://cl.ly/WouG/Download_on_the_App_Store_Badge_US-UK_135x40.svg)](https://www.apple.com/app-store/)

### Scribe language keyboards for iOS

**Scribe-iOS** is a pack of iOS system keyboards that color nouns typed in messaging apps based on their gender. The keyboards give users the confidence that they are using words in an appropriate context, and further helps language learners remember word genders through color association. Planned functionality includes in-chat verb conjugation and other grammar query features.

Being fully open-source, Scribe prioritizes user privacy by not accessing any user data. German and Spanish are currently the only supported languages, but the Scribe team has interest in creating keyboards for all languages of interest.

# **Contents**<a id="contents"></a>

- [Setup](#setup)
- [Features](#features)
- [To-Do](#to-do)

# Setup [`↩`](#contents) <a id="setup"></a>

Users access Scribe language keyboards through the following:

- Download Scribe from the [App Store](https://www.apple.com/app-store/)
- Settings -> General -> Keyboard -> Keyboards -> Add New Keyboard
- Select from the available Scribe keyboards
- When typing press 🌐 to select keyboards

# Features [`↩`](#contents) <a id="features"></a>

### Noun-gender coloration

Scribe colors nouns according to the following conventions:

- Feminine nouns are colored red 🟥
- Masculine nouns are colored blue 🟦
- Neutral nouns are colored green 🟩
- Plural nouns are colored orange 🟧
- Nouns with more than one gender are multicolored

### iOS system keyboard functionality

Scribe keyboards have all the functionality of iOS system keyboards including:

- Auto capitalization (WIP)
- The double space period shortcut (WIP)
- Typing `'` goes back to the letter keyboard (WIP)
- Portrait and landscape views (WIP)
- Dark mode compatibility (WIP)
- Hold-to-select characters (WIP)

# To-Do [`↩`](#contents) <a id="to-do"></a>

Please see the [contribution guidelines](https://github.com/scribe-org/Scribe-iOS/blob/main/.github/CONTRIBUTING.md) if you are interested in contributing to this project. Work that is in progress or could be implemented includes:

- Creating an MVP

- Expanding Scribe's support for current languages by adding words and their genders to the [language files](https://github.com/scribe-org/Scribe-iOS)

  - Pull requests are more than welcome for this!

<!--

- Adding support for more languages to Scribe-iOS [(see issues)](https://github.com/scribe-org/Scribe-iOS/issues)

- Planning the potential implementation of a verb conjugation command (see issue)

  - Example 1: typing /fps chosen_infinitive could conjugate the verb to first person singular

  - Example 2: typing /pp chosen_infinitive could query the verb's past participle

- Planning the potential implementation of a plural command (see issue)

  - Example: typing /pl chosen_noun could provide the plural for the noun

- Adding iPadOS specific functionality (see issue)

- Add dark mode functionality (see issue)

-->

- Moving grammar files to a new repository in [scribe-org](https://github.com/scribe-org) and accessing them remotely to allow Android and extension access

  - This would likely best be implemented via a Python package that allows users to access data within JSON files stored in the package

  - The creation of a repository with grammar rules for Scribe languages would be a valuable resource for Scribe and the open-source community

- Converting Scribe keyboards into downloadable packs within the app
