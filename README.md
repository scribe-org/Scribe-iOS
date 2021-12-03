<div align="center">
  <a href="https://github.com/scribe-org/Scribe-iOS"><img src="https://github.com/scribe-org/Scribe-iOS/blob/main/Resources/Scribe/Scribe-iOS_logo_transparent.png" width=624 height=164></a>
</div>

---

[![version](https://img.shields.io/github/v/release/scribe-org/Scribe-iOS?color=%2300550&sort=semver)](https://github.com/scribe-org/Scribe-iOS/releases/)
[![iOS 13.0+](https://img.shields.io/badge/iOS-13.0%2B-blue.svg)](https://apps.apple.com/app/scribe-language-keyboards/id1596613886)
[![license](https://img.shields.io/github/license/scribe-org/Scribe-iOS.svg)](https://github.com/scribe-org/Scribe-iOS/blob/main/LICENSE.txt)
[![coc](https://img.shields.io/badge/coc-Contributor%20Covenant-ff69b4.svg)](https://github.com/scribe-org/Scribe-iOS/blob/main/.github/CODE_OF_CONDUCT.md)

[![Available on the App Store](http://cl.ly/WouG/Download_on_the_App_Store_Badge_US-UK_135x40.svg)](https://apps.apple.com/app/scribe-language-keyboards/id1596613886)

### Scribe language keyboards for iOS

**Scribe-iOS** is a pack of iOS and iPadOS keyboards for language learners. Features include translation **`(beta)`**, verb conjugation and word annotation that give users the tools needed to communicate with confidence.

Scribe is fully open-source and does not collect usage data or ask for system access. Feature data is sourced from [Wikidata](https://www.wikidata.org/) and stored in-app, meaning Scribe is a highly responsive experience that does not require an internet connection.

# **Contents**<a id="contents"></a>

- [Preview Videos](#preview-videos)
- [Setup](#setup)
- [Features](#features)
  - [Translation](#translation)
  - [Verb Conjugation](#verb-conjugation)
  - [Noun Plurals](#noun-plurals)
  - [Word Annotation](#word-annotation)
  - [Keyboard Functionality](#keyboard-functionality)
- [Supported Languages](#supported-languages)
- [To-Do](#to-do)

# Preview Videos [`⇧`](#contents) <a id="preview-videos"></a>

The following are combined preview videos for the [App Store](https://apps.apple.com/app/scribe-language-keyboards/id1596613886). Choose which one to open based on your current device:

<details><summary><strong>Mobile: iPhone 6.5" version</strong></summary>
<p>

https://user-images.githubusercontent.com/24387426/143763293-439fe6c8-e417-4f76-9a32-cedecc057490.mov

</p>
</details>

<details><summary><strong>Desktop: iPad Pro 4th gen version</strong></summary>
<p>

https://user-images.githubusercontent.com/24387426/143763680-16931dda-0d5e-4029-b1a9-f293bc1f1bba.mp4

</p>
</details>

The App Store videos, images and text can be found in [Resources/AppStore](https://github.com/scribe-org/Scribe-iOS/blob/main/Resources/AppStore/). Contributions to improve them are welcome, but please [open an issue](https://github.com/scribe-org/Scribe-iOS/issues/new) to check before.

# Setup [`⇧`](#contents) <a id="setup"></a>

Users access Scribe language keyboards through the following:

- Download Scribe from the [App Store](https://apps.apple.com/app/scribe-language-keyboards/id1596613886)
- Settings -> General -> Keyboard -> Keyboards -> Add New Keyboard
- Select Scribe and choose from the available language keyboards
- When typing press `🌐` to select keyboards

# Features [`⇧`](#contents) <a id="features"></a>

Scribe keyboard features are accessed via the `Scribe key` at the top left of any Scribe keyboard. Pressing this key gives the user three new selectable options: `Translate`, `Conjugate` and `Plural`. These keys allow for words to be queried and inserted into the text field followed by a space.

Current features include:

### Translation [`⇧`](#contents) <a id="translation"></a>

The **`beta`** `Translate` feature can translate single words or phrases from English into the language of the current keyboard when the `return` key is pressed.

Those interested in improving this feature can see the [Translation project](https://github.com/scribe-org/Scribe-iOS/projects/1). The goal is that `Translate` will provide options for entered words where a user can use grammatical categories and synonyms to select the best option [(see issue)](https://github.com/scribe-org/Scribe-iOS/issues/49). Then the feature will expand to allow translations from system and chosen languages. More advanced methods will be planned once this feature is out of **`beta`**.

As of now translations ([P5972](https://www.wikidata.org/wiki/Property:P5972), [Q7553](https://www.wikidata.org/wiki/Q7553)) are not widely available on [Wikidata](https://www.wikidata.org/) [(see issue)](https://github.com/scribe-org/Scribe-iOS/issues/40). The current functionality is thus based on [🤗 Transformers](https://github.com/huggingface/transformers) machine translations of words queried from [Wikidata](https://www.wikidata.org/). The ultimate goal is for the translations and synonyms to all be directly queried.

### Verb Conjugation [`⇧`](#contents) <a id="verb-conjugation"></a>

With the `Conjugate` feature, a user is presented with the grammar charts for an entered verb instead of the keyboard. Pressing an example in the charts inserts the chosen conjugation into the text field.

### Noun Plurals [`⇧`](#contents) <a id="noun-plurals"></a>

The `Plural` feature allows a user to enter a noun and then insert its plural when the `return` key is pressed.

### Word Annotation [`⇧`](#contents) <a id="word-annotation"></a>

Scribe further annotates words in the preview bar to help users understand the context of what they're typing. Annotations are displayed once a user has typed a given word and pressed space or by pressing the `Scribe key` while it is selected. The hope is that annotation will help a user remember grammar rules even when not using Scribe.

#### Nouns

Scribe annotates nouns in the preview bar according to the following conventions:

- Feminine: colored red 🟥 and marked with (F)
- Masculine: colored blue 🟦 and marked with (M)
- Neutral: colored green 🟩 and marked with (N)
- Plural: colored orange 🟧 and marked with (PL)
<!-- - Common: colored purple 🟪 and marked with (C) -->
- More than one: marked with all their forms

#### Prepositions

Scribe also annotates the grammatical cases (accusative, dative, etc) of prepositions in the preview bar if there is a relation in the given language.

### Keyboard Functionality [`⇧`](#contents) <a id="keyboard-functionality"></a>

The goal is for Scribe to have all the functionality of system keyboards. See the [Base Keyboard Features project](https://github.com/scribe-org/Scribe-iOS/projects/6) if interested in helping.

<details><summary><strong>Current and WIP features</strong></summary>
<p>

- iPhone and iPad support
- Dynamic layouts for cross-device performance
- Portrait and landscape modes
- Dark mode compatibility
- Auto-capitalization following `.`, `?` and `!`
- The double space period shortcut
- Typing `'` returns to the alphabetic keyboard
- Typing `,`, `?` or `!` and then `space` returns to the alphabetic keyboards
- Hold-to-select characters [(WIP - see project)](https://github.com/scribe-org/Scribe-iOS/projects/2)

</p>
</details>

# Supported Languages [`⇧`](#contents) <a id="supported-languages"></a>

The Scribe team has interest in creating keyboards for all languages of interest. The following table shows the supported languages and the amount of data available for each on [Wikidata](https://www.wikidata.org/). Based on the available data, the next languages that the Scribe team could focus on are Russian ([queries](https://github.com/scribe-org/Scribe-iOS/blob/main/Data/Russian/), [issue](https://github.com/scribe-org/Scribe-iOS/issues/6)), Portuguese ([queries](https://github.com/scribe-org/Scribe-iOS/blob/main/Data/Portuguese/), [issue](https://github.com/scribe-org/Scribe-iOS/issues/67)), French ([queries](https://github.com/scribe-org/Scribe-iOS/blob/main/Data/French/), [issue](https://github.com/scribe-org/Scribe-iOS/issues/68)) and English ([queries](https://github.com/scribe-org/Scribe-iOS/blob/main/Data/English/), [issue](https://github.com/scribe-org/Scribe-iOS/issues/7)).

| Language   | Nouns | Verbs | Translations\* | Prepositions† |
| :--------- | ----: | ----: | -------------: | ------------: |
| French     |   WIP |   WIP |            WIP |            NA |
| German     |  27K+ |   3K+ |           65K+ |           190 |
| Portuguese |   WIP |   WIP |            WIP |            NA |
| Russian    |   WIP |   WIP |            WIP |           WIP |
| Spanish    |   8K+ |    65 |           65K+ |            NA |

`*` Given the current **`beta`** status where words are machine translated.

`†` Only for languages for which preposition annotation is needed.

# To-Do [`⇧`](#contents) <a id="to-do"></a>

Work that is in progress or could be implemented is tracked in the [Issues](https://github.com/scribe-org/Scribe-iOS/issues) and [Projects](https://github.com/scribe-org/Scribe-iOS/projects). Please see the [contribution guidelines](https://github.com/scribe-org/Scribe-iOS/blob/main/.github/CONTRIBUTING.md) if you are interested in contributing to Scribe-iOS. Also note the use of the `--priority--` label that indicates which issues are most important.

Scribe does not accept direct edits to the grammar JSON files as they are sourced from [Wikidata](https://www.wikidata.org/). Edits can be discussed and the queries themselves will be changed and ran before an update. If there is a problem with one of the files, then the fix should be made on [Wikidata](https://www.wikidata.org/) and not on Scribe.

# Powered By

<div align="center">
  <br>
  <a href="https://www.wikidata.org/"><img height="150" src="https://github.com/scribe-org/Scribe-iOS/blob/main/Resources/GitHub/Images/wikidata_logo.png" alt="Wikidata"></a>
  <br>
</div>
