<div align="center">
  <a href="https://github.com/scribe-org/Scribe-iOS"><img src="https://github.com/scribe-org/Scribe-iOS/blob/main/Resources/Scribe-iOS_logo_transparent.png" width=624 height=164></a>
</div>

---

<!--
[![license](https://img.shields.io/github/license/scribe-org/Scribe-iOS.svg)](https://github.com/scribe-org/Scribe-iOS/blob/main/LICENSE.txt)
-->

[![coc](https://img.shields.io/badge/coc-Contributor%20Covenant-ff69b4.svg)](https://github.com/scribe-org/Scribe-iOS/blob/main/.github/CODE_OF_CONDUCT.md)

[![Available on the App Store](http://cl.ly/WouG/Download_on_the_App_Store_Badge_US-UK_135x40.svg)](https://www.apple.com/app-store/)

### Scribe language keyboards for iOS

**Scribe-iOS** is a pack of iOS and iPadOS power user keyboards for language learners. Features include translation **`(beta)`**, verb conjugation and annotation of nouns that give users the tools needed to communicate with confidence. Being fully open-source, Scribe prioritizes user privacy and doesn't ask for any data or system access.

Data for Scribe keyboards is sourced from [Wikidata](https://www.wikidata.org/), with [WDQS](https://www.wikidata.org/wiki/Wikidata:SPARQL_tutorial) queries being written to produce JSON files for easy reference. The [Wikidata](https://www.wikidata.org/) query and formatting files for each keyboard are found in the `DataPrep` directory or each keyboard in [Scribe-iOS/Keyboards](https://github.com/scribe-org/Scribe-iOS/tree/main/Keyboards). German and Spanish are currently the only supported languages, but the Scribe team has interest in creating keyboards for all languages of interest.

# **Contents**<a id="contents"></a>

- [Setup](#setup)
- [Features](#features)
- [To-Do](#to-do)

# Setup [`↩`](#contents) <a id="setup"></a>

Users access Scribe language keyboards through the following:

- Download Scribe from the [App Store](https://www.apple.com/app-store/)
- Settings -> General -> Keyboard -> Keyboards -> Add New Keyboard
- Select from the available Scribe keyboards
- When typing press `🌐` to select keyboards

# Features [`↩`](#contents) <a id="features"></a>

Scribe keyboard features are accessed via the `Scribe key` at the top left of any Scribe keyboard. Pressing this key gives the user three new selectable options: `Translate`, `Conjugate` and `Plural`. These buttons allow for words to be queried and inserted into the text field. An extra space is inserted after so that these features function like auto-suggestions. Current features include:

### Translation

The **`beta`** `Translate` feature can translate single words or phrases from English into the language of the current keyboard when the `↵` key is pressed. The goal is to first expand this feature to allow for translations from system and chosen languages, then to provide options for entered words where a user can use grammatical categories and synonyms to select the best option, and then finally to explore api translation implementations.

As of now translations ([P5972](https://www.wikidata.org/wiki/Property:P5972), [Q7553](https://www.wikidata.org/wiki/Q7553)) are not widely available on [Wikidata](https://www.wikidata.org/). The current functionality is thus based on [🤗 Transformers](https://github.com/huggingface/transformers) machine translations of words queried from [Wikidata](https://www.wikidata.org/). Edits to translations.json files are welcome while this feature is in **`beta`**, but the goal is for translations to be directly queried. Furthermore, translating verbs currently requires the user to input `to VERB` so that there is a distinction between verbs and other word forms. This requirement will be removed when later versions change the keyboard display to provide the user with multiple options across grammatical categories.

<!--
<p align="center">
    <a href="https://github.com/scribe-org/Scribe-iOS/blob/main/Resources/Demos/translation_demo.gif"><img src ="Resources/Demos/translation_demo.gif" width="300" /></a>
</p>
-->

### Verb Conjugation

With the `Conjugate` feature, a user is presented with the grammar charts for an entered verb instead of the keyboard. Pressing an example in the charts inserts the chosen conjugation into the text field.

<!--
<p align="center">
    <a href="https://github.com/scribe-org/Scribe-iOS/blob/main/Resources/Demos/conjugation_demo.gif"><img src ="Resources/Demos/conjugation_demo.gif" width="300" /></a>
</p>
-->

### Noun Plurals

The `Plural` feature allows a user to enter a noun and then insert its plural when the `↵` key is pressed.

<!--
<p align="center">
    <a href="https://github.com/scribe-org/Scribe-iOS/blob/main/Resources/Demos/noun_plural_demo.gif"><img src ="Resources/Demos/noun_plural_demo.gif" width="300" /></a>
</p>
-->

### Noun Annotation

Scribe further annotates nouns in the preview label according to the following conventions:

- Feminine nouns are colored red 🟥 and marked with (F)
- Masculine nouns are colored blue 🟦 and marked with (M)
- Neutral nouns are colored green 🟩 and marked with (N)
- Plural nouns are colored orange 🟧 and marked with (PL)
- Nouns meeting more than one of the above criteria are black ⬛ and marked with all forms

Annotations are displayed once a user has typed a noun and pressed space or by pressing the `Scribe key` while a noun is selected.

<!--
<p align="center">
    <a href="https://github.com/scribe-org/Scribe-iOS/blob/main/Resources/Demos/noun_gender_demo.gif"><img src ="Resources/Demos/noun_gender_demo.gif" width="300" /></a>
</p>
-->

### System Keyboard Functionality

The goal is that Scribe keyboards have all the functionality of system keyboards.

<details><summary><strong>Current and WIP features</strong></summary>
<p>

- iPhone and iPad support
- Dynamic layouts for cross-device performance
- Portrait and landscape modes
- Auto-capitalization
- The double space period shortcut
- Typing `'` returns to the alphabetic keyboard
- Dark mode compatibility
- Hold-to-select characters

<!--
<p align="center">
    <a href="https://github.com/scribe-org/Scribe-iOS/blob/main/Resources/Demos/ios_keyboard_features_demo.gif"><img src ="Resources/Demos/ios_keyboard_features_demo.gif" width="300" /></a>
</p>
-->

</p>
</details>

# To-Do [`↩`](#contents) <a id="to-do"></a>

Please see the [contribution guidelines](https://github.com/scribe-org/Scribe-iOS/blob/main/.github/CONTRIBUTING.md) if you are interested in contributing to this project. Work that is in progress or could be implemented includes:

## Functionality

- Code cleaning

- Finalizing the Spanish keyboard

- Baseline fixes to translations.json files

- Improving appearance and adding settings features to the Scribe app

- Releasing Scribe-iOS MVP

- Adding autocorrect functionality [(see issue)]()

- Adding autocomplete functionality [(see issue)]()

- Reorganizing the Scribe-iOS directory structure so that the code is easier to maintain [(see issue)]()

- Fix issue with `selectKeyboard` button not being able to be long-pressed after another key press [(see issue)]()

- Fixing hold-to-select character implementation so it's one function (and maybe that the user needs to continue to hold) [(see issue)]()

- Adding support for more languages to Scribe-iOS [(see issues)](https://github.com/scribe-org/Scribe-iOS/issues)

- Creating testing files and a ci process for Scribe-iOS [(see issue)]()

- Localizing Scribe-iOS across various languages and regions [(see issues)](https://github.com/scribe-org/Scribe-iOS/issues)

- Moving grammar files to a new repository in [scribe-org](https://github.com/scribe-org) and accessing them remotely to allow Android and extension access [(see issue)]()

  - This would likely best be implemented via a Python package that allows users to access data within JSON files stored in the package

  - The creation of a repository with grammar rules for Scribe languages would be a valuable resource for Scribe and the open-source community

- Converting Scribe keyboards into downloadable packs within the app [(see issue)]()

  - This would help keep the app size to a minimum

- Planning and implementing baseline documentation for Scribe [(see issue)]()

- Discussing further grammatical information that can be displayed to the user in the preview bar that could help with language learning [(see issue)]()

- Adding undo button functionality for iPads and iPhones [(see issue)]()

- Allowing certain features to be changed in the system settings and/or in the Scribe app [(see issue)]()

## Appearance

- Create a version of the `Scribe key` that is appropriately rendered across devices [(see issue)]()

- Fix transition from portrait to landscape so that height is re-rendered [(see issue)]()

  - This is likely caused by a missing parent-child relationship for `keyboardView`

- Create a proper bezier path implementation of hold-to-select characters including keys popping up when being pressed and then removing key pressed coloration [(see issue)]()

- Edits to KeyboardViewController and Keyboard.xib files to make Scribe keyboard elements dynamically sized [(see issue)]()

- Edits to Keyboard.xib files to provide language specific UI elements based on grammatical needs [(see issue)]()

- Fixes to the dark mode implementation [(see issue)]()

- Adding key shading to keyboards [(see issue)]()

- Make the space bar read the name of the keyboard when it's switched to [(see issue)]()

- Make the cursor within the preview bar blink when the field is active [(see issue)]()

- Adding a feature where the Scribe UI can be hidden with an element to show the UI again [(see issue)]()

  - Long holding keys for alternate characters would need to be edited to make sure that the alternates would still be fully within the keyboard view

## Data

Aside from translation JSONs, Scribe does not accept direct edits to the grammar JSON files as they are sourced from [Wikidata](https://www.wikidata.org/). Edits can be discussed and the queries themselves will be changed and ran before an update. If there is a problem with one of the files, then the fix should be made on [Wikidata](https://www.wikidata.org/) and not on Scribe. Known data issues include:

- Expanding the availability of translations in [Wikidata lexicographical data](https://www.wikidata.org/wiki/Wikidata:Lexicographical_data) and reworking the `Translate` feature to access them [(see issue)]()

  - Scribe will not accept edits to any JSON files when this task is finished

- Many German verbs do not have auxiliary verbs meaning that their full perfect conjugations cannot be displayed [(see issue)]()

- Adding missing verb conjugations to [Wikidata](https://www.wikidata.org/) [(see issue)]()

  - Missing values are marked as `""` in verbs.json files

- Standardizing the conjugation properties for Spanish verbs [(see issue)]()

# Powered By

<div align="center">
  <br>
  <a href="https://www.wikimedia.org/"><img height="150" src="https://github.com/scribe-org/Scribe-iOS/blob/main/Resources/gh_images/wikimedia_foundation_logo.png" alt="Wikimedia"></a>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  <a href="https://www.wikidata.org/"><img height="150" src="https://github.com/scribe-org/Scribe-iOS/blob/main/Resources/gh_images/wikidata_logo.png" alt="Wikidata"></a>
  <br>
</div>
