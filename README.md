<div align="center">
  <a href="https://github.com/scribe-org/Scribe-iOS"><img src="https://raw.githubusercontent.com/scribe-org/Organization/main/logo/ScribeGitHubOrgBanner.png" width=1024 alt="Scribe Logo"></a>
</div>

<!---
[![ci](https://img.shields.io/github/workflow/status/scribe-org/Scribe-iOS/CI?logo=github)](https://github.com/scribe-org/Scribe-iOS/actions?query=workflow%3ACI)
--->

[![platforms](https://img.shields.io/static/v1?message=iOS%20│%20iPadOS&logo=apple&labelColor=5c5c5c&color=999999&logoColor=white&label=%20)](https://apps.apple.com/app/scribe-language-keyboards/id1596613886)
[![version](https://img.shields.io/github/v/release/scribe-org/Scribe-iOS?color=%2300550&sort=semver)](https://github.com/scribe-org/Scribe-iOS/releases/)
[![issues](https://img.shields.io/github/issues/scribe-org/Scribe-iOS)](https://github.com/scribe-org/Scribe-iOS/issues)
[![language](https://img.shields.io/badge/Swift-5-F0513C.svg?logo=swift&logoColor=ffffff)](https://github.com/scribe-org/Scribe-iOS/blob/main/CONTRIBUTING.md)
[![license](https://img.shields.io/github/license/scribe-org/Scribe-iOS.svg)](https://github.com/scribe-org/Scribe-iOS/blob/main/LICENSE.txt)
[![coc](https://img.shields.io/badge/coc-Contributor%20Covenant-ff69b4.svg)](https://github.com/scribe-org/Scribe-iOS/blob/main/.github/CODE_OF_CONDUCT.md)
[![twitter](https://img.shields.io/badge/Tweet-1DA1F2.svg?logo=twitter&logoColor=ffffff)](https://twitter.com/intent/tweet?text=Check%20out%20@scribe_org%20for%20typing%20in%20your%20second%20language!%20%23languagelearning%20https://github.com/scribe-org/Scribe-iOS)
[![reddit](https://img.shields.io/badge/Post-FF6314.svg?logo=reddit&logoColor=ffffff)](http://www.reddit.com/submit?url=https://github.com/scribe-org/Scribe-iOS&title=Scribe%20iOS%20keyboards%20for%20language%20learners)

<a href='https://apps.apple.com/app/scribe-language-keyboards/id1596613886'><img alt='Available on the App Store' src='https://raw.githubusercontent.com/scribe-org/Scribe-iOS/main/.github/resources/images/app_store_badge.png' height='60px'/></a>

## iOS app with keyboards for language learners

**Scribe-iOS** is a pack of iOS and iPadOS keyboards for language learners. Features include translation **`(beta)`**, verb conjugation and word annotation that give users the tools needed to communicate with confidence.

Scribe is fully open-source and does not collect usage data or ask for system access. Feature data is sourced from [Wikidata](https://www.wikidata.org/) and stored in-app, meaning Scribe is a highly responsive experience that does not require an internet connection.

The [contributing](#contributing) section has information for those interested, with the articles and presentations in [featured by](#featured-by) also being good resources for learning more about Scribe.

Also available on [Android](https://github.com/scribe-org/Scribe-Android) (WIP), [Desktop](https://github.com/scribe-org/Scribe-Desktop) (planned) and for the data processes see [Scribe-Data](https://github.com/scribe-org/Scribe-Data).

<a id="contents"></a>

# **Contents**

- [Preview Videos](#preview-videos)
- [Contributing](#contributing)
- [Setup](#setup)
- [Supported Languages](#supported-languages)
- [Keyboard Features](#keyboard-features)
  - [Translation](#translation)
  - [Verb Conjugation](#verb-conjugation)
  - [Noun Plurals](#noun-plurals)
  - [Word Annotation](#word-annotation)
  - [Pronoun Selection](#pronoun-selection)
  - [Base Functionality](#base-functionality)
- [Language Practice](#language-practice)
- [Featured By](#featured-by)

<a id="preview-videos"></a>

# Preview Videos [`⇧`](#contents)

The following are the preview videos for the [App Store](https://apps.apple.com/app/scribe-language-keyboards/id1596613886):

#### iPhone 6.5" version

https://user-images.githubusercontent.com/24387426/194840842-f1668216-94a5-4f3d-8aac-a536db54b0d8.mp4

#### See also

<details><summary><strong>iPad Pro 4th gen version</strong></summary>
<p>

https://user-images.githubusercontent.com/24387426/194840915-c9a9ea88-4718-4bdf-904d-8fc13b08af5a.mp4

</p>
</details>

<a id="contributing"></a>

# Contributing [`⇧`](#contents)

Work that is in progress or could be implemented is tracked in the [issues](https://github.com/scribe-org/Scribe-iOS/issues) and [projects](https://github.com/scribe-org/Scribe-iOS/projects). Please also see the [contribution guidelines](https://github.com/scribe-org/Scribe-iOS/blob/main/CONTRIBUTING.md) if you are interested in contributing to Scribe-iOS. Those interested can further check the [`-next release-`](https://github.com/scribe-org/Scribe-iOS/labels/-next%20release-) and [`-priority-`](https://github.com/scribe-org/Scribe-iOS/labels/-priority-) labels in the [issues](https://github.com/scribe-org/Scribe-iOS/issues) for those that are most important, as well as those marked [`good first issue`](https://github.com/scribe-org/Scribe-iOS/issues?q=is%3Aissue+is%3Aopen+label%3A%22good+first+issue%22) that are tailored for first time contributors.

After your first few pull requests the team would be happy to discuss granting you further rights as a contributor, with a maintainer role then being possible after continued interest in the project. Scribe seeks to be an inclusive and supportive organization. We'd love to have you as a member!

### ⚠️ Note on Debugging ⚠️

Because Scribe is a keyboard extension, the Xcode debugger doesn't work as expected when debugging a regular app. Please see the [note on debugging](./CONTRIBUTING.md#note-on-debugging) in [CONTRIBUTING.md](./CONTRIBUTING.md) to learn how to get it working properly.

### Ways to Help

- [Reporting bugs](https://github.com/scribe-org/Scribe-iOS/issues/new?assignees=&labels=bug&template=bug_report.yml) as they're found 🐞
- Working on [new features](https://github.com/scribe-org/Scribe-iOS/issues?q=is%3Aissue+is%3Aopen+label%3Afeature) ✨
- [Localization](https://github.com/scribe-org/Scribe-iOS/issues?q=is%3Aissue+is%3Aopen+label%3Alocalization) for the app and App Store 🌐
- [Documentation](https://github.com/scribe-org/Scribe-iOS/issues?q=is%3Aissue+is%3Aopen+label%3Adocumentation) for onboarding and project cohesion 📝
- Adding language data to [Scribe-Data](https://github.com/scribe-org/Scribe-Data/issues) via [Wikidata](https://www.wikidata.org/)! 🗃️
- [Sharing Scribe-iOS](https://github.com/scribe-org/Scribe-iOS/issues/181) with others! 🚀

### Road Map

<details><summary><strong>Click here to see the current Scribe road map 🗺️</strong></summary>
<p>

The following outlines the plan for Scribe's development, which includes steps across applications and data solutions.

- Scribe-iOS v2.2.0
  - Rework the data solution to use SQLite
  - Main issue: [Scribe-iOS #96](https://github.com/scribe-org/Scribe-iOS/issues/96)
- Scribe-iOS v2.3.0
  - Rework Scribe-iOS app interface and add menu
  - Main issue: [Scribe-iOS #16](https://github.com/scribe-org/Scribe-iOS/issues/16)
- Scribe-iOS v3.0.0 and Scribe-Data v3.0.0
  - Expand translation data and add English keyboard
  - Main issues: [Scribe-iOS #7](https://github.com/scribe-org/Scribe-iOS/issues/7) and [Scribe-Data #23](https://github.com/scribe-org/Scribe-Data/issues/23)
- Scribe-Android v1.0.0
  - Release an MVP for [Scribe-Android](https://github.com/scribe-org/Scribe-Android)
- Scribe-iOS v4.0.0 and Scribe-Data v4.0.0
  - Downloadable language packs for Scribe keyboards
  - Main issue: [Scribe-iOS #89](https://github.com/scribe-org/Scribe-iOS/issues/89)
- Scribe-iOS v5.0.0
  - Machine learning based autosuggest and autocorrect
  - Main issue: [Scribe-iOS #2](https://github.com/scribe-org/Scribe-iOS/issues/2)

</p>
</details>

### Data Edits

Scribe does not accept direct edits to the grammar JSON files as they are sourced from [Wikidata](https://www.wikidata.org/). Edits can be discussed and the [Scribe-Data](https://github.com/scribe-org/Scribe-Data) queries will be changed and ran before an update. If there is a problem with one of the files, then the fix should be made on [Wikidata](https://www.wikidata.org/) and not on Scribe. Feel free to let us know that edits have been made by [opening a data issue](https://github.com/scribe-org/Scribe-iOS/issues/new?assignees=&labels=data&template=data_wikidata.yml) or contacting us in the [issues for Scribe-Data](https://github.com/scribe-org/Scribe-Data/issues) and we'll be happy to integrate them!

### Designs

<a href="https://www.figma.com/file/c8945w2iyoPYVhsqW7vRn6/scribe_public_designs?node-id=405%3A464"><img src="https://raw.githubusercontent.com/scribe-org/Organization/main/resources/images/figma_logo.png" height="50" alt="Public Figma Designs" align="right"></a>

The [designs for Scribe](https://www.figma.com/file/c8945w2iyoPYVhsqW7vRn6/scribe_public_designs?node-id=405%3A464) are made using [Figma](https://www.figma.com). The App Store videos, images and text can be found in the [AppStore](https://github.com/scribe-org/Scribe-iOS/blob/main/AppStore) directory. Those with interest in contributing can [open a design issue](https://github.com/scribe-org/Scribe-iOS/issues/new?assignees=&labels=design&template=design_improvement.yml) to make suggestions! Design related issues are marked with the [`design`](https://github.com/scribe-org/Scribe-iOS/issues?q=is%3Aopen+is%3Aissue+label%3Adesign) label.

<a id="setup"></a>

# Setup [`⇧`](#contents)

Users access Scribe language keyboards through the following:

- Download Scribe from the [App Store](https://apps.apple.com/app/scribe-language-keyboards/id1596613886)
- Settings -> General -> Keyboard -> Keyboards -> Add New Keyboard
- Select Scribe and choose from the available language keyboards
- When typing press `🌐` to select keyboards

<a id="supported-languages"></a>

# Supported Languages [`⇧`](#contents)

Scribe's goal is functional, feature-rich keyboards for all languages. Check [scribe_data/extract_transform](https://github.com/scribe-org/Scribe-Data/tree/main/src/scribe_data/extract_transform) for queries for currently supported languages and those that have substantial data on [Wikidata](https://www.wikidata.org/). Also see the [`new keyboard`](https://github.com/scribe-org/Scribe-iOS/issues?q=is%3Aissue+is%3Aopen+label%3A%22new+keyboard%22) label in the [Issues](https://github.com/scribe-org/Scribe-iOS/issues) for keyboards that are currently in progress or being discussed, and [suggest a new keyboard](https://github.com/scribe-org/Scribe-iOS/issues/new?assignees=&labels=new+keyboard&template=new_keyboard.yml&title=Add+%3Clanguage%3E+keyboard) if you don't see it being worked on already!

The following table shows the supported languages and the amount of data available for each on [Wikidata](https://www.wikidata.org/):

| Languages  |   Nouns | Verbs | Translations\* | Prepositions† |
| :--------- | ------: | ----: | -------------: | ------------: |
| French     |  16,815 | 5,450 |         67,652 |             - |
| German     |  29,272 | 3,557 |         67,652 |           187 |
| Italian    |   8,646 |    73 |         67,652 |             - |
| Portuguese |   5,191 |   495 |         67,652 |             - |
| Russian    | 194,419 |    11 |         67,652 |            13 |
| Spanish    |  27,128 | 4,036 |         67,652 |             - |
| Swedish    |  42,807 | 4,394 |         67,652 |             - |

`*` Given the current **`beta`** status where words are machine translated.

`†` Only for languages for which preposition annotation is needed.

Updates to the above data can be done using [scribe_data/load/update_data.py](https://github.com/scribe-org/Scribe-Data/tree/main/src/scribe_data/load/update_data.py).

<a id="keyboard-features"></a>

# Keyboard Features [`⇧`](#contents)

Keyboard features are accessed via the `Scribe key` at the top left of any Scribe keyboard. Pressing this key gives the user three new selectable options: `Translate`, `Conjugate` and `Plural` in the keyboard's language. These keys allow for words to be queried and inserted into the text field followed by a space.

**Current features include:**

<a id="translation"></a>

### • Translation [`⇧`](#contents)

The **`beta`** `Translate` feature can translate single words or phrases from English into the language of the current keyboard when the `return` key is pressed.

Those interested in improving this feature can see the [Translation project](https://github.com/scribe-org/Scribe-iOS/projects/1). The goal is that `Translate` will provide options for entered words where a user can use grammatical categories and synonyms to select the best option [(see issue)](https://github.com/scribe-org/Scribe-iOS/issues/49). Then the feature will expand to allow translations from system and chosen languages. More advanced methods will be planned once this feature is out of **`beta`**.

As of now translations are not widely available on [Wikidata](https://www.wikidata.org/) [(see issue)](https://github.com/scribe-org/Scribe-iOS/issues/40). The current functionality is thus based on [🤗 Transformers](https://github.com/huggingface/transformers) machine translations of words queried from [Wikidata](https://www.wikidata.org/). The ultimate goal is for the translations and synonyms to all be directly queried.

<a id="verb-conjugation"></a>

### • Verb Conjugation [`⇧`](#contents)

With the `Conjugate` feature, a user is presented with the grammar charts for an entered verb instead of the keyboard. Pressing an example in the charts inserts the chosen conjugation into the text field.

<a id="noun-plurals"></a>

### • Noun Plurals [`⇧`](#contents)

The `Plural` feature allows a user to enter a noun and then insert its plural into the text field when the `return` key is pressed.

<a id="word-annotation"></a>

### • Word Annotation [`⇧`](#contents)

Scribe further annotates words in the command bar to help users understand the context of what they're typing. Annotations are displayed once a user has typed a given word and pressed space, after commands or by pressing the `Scribe key` while it is selected. The hope is that annotation will help a user remember grammar rules even when not using Scribe.

#### Nouns

Scribe annotates nouns in the command bar according to the following conventions:

- Feminine: colored red 🟥 and marked with (F)
- Masculine: colored blue 🟦 and marked with (M)
- Common: colored purple 🟪 and marked with (C)
- Neutral: colored green 🟩 and marked with (N)
- Plural: colored orange 🟧 and marked with (PL)
- More than one: marked with all their forms

The above form abbreviations are translated into their equivalents in the keyboard's language.

#### Prepositions

Scribe also annotates the grammatical cases (accusative, dative, etc) of prepositions in the command bar if there is a relation in the given language.

<a id="pronoun-selection"></a>

### • Pronoun Selection [`⇧`](#contents)

Annotations for preposition cases can also be pressed to provide a conjugation display where the user can select the proper pronoun for the given case. The conjugation view will also provide appropriate interfaces to subset the available pronouns based on the desired subject and object combinations to help the user make the correct choice.

<a id="base-functionality"></a>

### • Base Functionality [`⇧`](#contents)

The goal is for Scribe to have all the functionality of system keyboards. See the [Base Keyboard Features project](https://github.com/scribe-org/Scribe-iOS/projects/6) if interested in helping.

<details><summary><strong>Current features</strong></summary>
<p>

- iPhone and iPad support
- Dynamic layouts for cross-device performance
- Portrait and landscape modes
- Dark mode compatibility
- Autocompletion based on [Wikidata](https://www.wikidata.org/) sourced words
- Autosuggestion based on [Wikipedia](https://www.wikipedia.org/) derived relationships
- Autocorrection (WIP - see [Autocorrect](https://github.com/scribe-org/Scribe-iOS/issues/2) issue)
- Auto-capitalization following `.`, `?` and `!`
- The double space period shortcut
- Typing symbols and numbers followed by a space returns keyboard to letters
- Hold-to-select characters for letters and symbols
- Key pop up views for letters and symbols

</p>
</details>

<a id="language-practice"></a>

# Language Practice [`⇧`](#contents)

A future feature of Scribe is language practice within the app itself. Scribe presents users with information that is directly relevant to their current struggles with a second language. This information can be saved in-app and used to create personalized lessons such as flashcards to reinforce the information that Scribe has provided. Work on this feature will be completed in the [language practice project](https://github.com/scribe-org/Scribe-iOS/projects/7).

<a id="featured-by"></a>

# Featured By [`⇧`](#contents)

<details><summary><strong>Articles and Presentations on Scribe</strong></summary>
<p>

<strong>2022</strong>

- [Presentation slides](https://docs.google.com/presentation/d/12WNSt5xgNIAmSxPfvjno9-sBMGlvxG_xSaAxmHQDRNQ/edit?usp=sharing) for a session at the [2022 Wikimania Hackathon](https://wikimania.wikimedia.org/wiki/Hackathon)
- [Presentation slides](https://docs.google.com/presentation/d/10Ai0-b8XUj5u9Hw4UgBtB7ufiPhvfFrb1vEUEyXYr5w/edit?usp=sharing) for a talk with [CocoaHeads Berlin](https://www.meetup.com/cocoaheads-berlin/)
- [Video on Scribe](https://www.youtube.com/watch?v=4GpFN0gGmy4&list=PL66MRMNlLyR7p9wsYVfuqJOjKZpbuwp8U&index=6) for [Wikimedia Celtic Knot 2022](https://meta.wikimedia.org/wiki/Celtic_Knot_Conference_2022)
- [Presentation slides](https://docs.google.com/presentation/d/1K2lj8PPgdx12I-xuhm--CBLrGm-Cz50NJmbp96zpGrk/edit?usp=sharing) for a talk with the [LD4 Wikidata Affinity Group](https://www.wikidata.org/wiki/Wikidata:WikiProject_LD4_Wikidata_Affinity_Group)
- [Scribe](https://github.com/scribe-org) featured for new developers on [MediaWiki](https://www.mediawiki.org/wiki/New_Developers)
- [Presentation slides](https://docs.google.com/presentation/d/1Cu3VwQ3lJUp5W84YDe0AFYS-6zfBxKsm0MI-OMl_IzY/edit?usp=sharing) for [Wikimedia Hackathon 2022](https://www.mediawiki.org/wiki/Wikimedia_Hackathon_2022)
- [Blog post](https://tech-news.wikimedia.de/en/2022/03/18/lexicographical-data-for-language-learners-the-wikidata-based-app-scribe/) on [Scribe-iOS](https://github.com/scribe-org/Scribe-iOS) for [Wikimedia Tech News](https://tech-news.wikimedia.de/en/homepage/) ([DE](https://tech-news.wikimedia.de/2022/03/18/sprachenlernen-mit-lexikografische-daten-die-wikidata-basierte-app-scribe/) / [Tweet](https://twitter.com/wikidata/status/1507335538596106257?s=20&t=YGRGamftI-5B_VwQ_bFRhA))
- [Presentation slides](https://docs.google.com/presentation/d/16ld_rCbwJCiAdRrfhF-Fq9Wm_ciHCbk_HCzGQs6TB1Q/edit?usp=sharing) for [Wikidata Data Reuse Days 2022](https://diff.wikimedia.org/event/wikidata-data-reuse-days-2022/)

</p>
</details>

<div align="center">
  <br>
    <a href="https://tech-news.wikimedia.de/en/2022/03/18/lexicographical-data-for-language-learners-the-wikidata-based-app-scribe/"><img height="120"src="https://raw.githubusercontent.com/scribe-org/Organization/main/resources/images/wikimedia_deutschland_logo.png" alt="Wikimedia Tech News"></a>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <a href="https://www.mediawiki.org/wiki/New_Developers"><img height="120" src="https://raw.githubusercontent.com/scribe-org/Organization/main/resources/images/mediawiki_logo.png" alt="MediaWiki"></a>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  <br>
</div>

# Powered By

### Contributors

Many thanks to all the Scribe-iOS contributors! 🚀

<a href="https://github.com/scribe-org/Scribe-iOS/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=scribe-org/Scribe-iOS" />
</a>

### Code

<details><summary><strong>List of referenced codes</strong></summary>
<p>

- [CustomKeyboard](https://github.com/EthanSK/CustomKeyboard) by [EthanSK](https://github.com/EthanSK) ([License](https://github.com/EthanSK/CustomKeyboard/blob/master/LICENSE))

</p>
</details>

### Wikimedia Communities

<div align="center">
  <br>
  <a href="https://www.wikidata.org/"><img height="175" src="https://raw.githubusercontent.com/scribe-org/Organization/main/resources/images/wikidata_logo.png" alt="Wikidata logo"></a>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  <a href="https://www.wikipedia.org/"><img height="190" src="https://raw.githubusercontent.com/scribe-org/Organization/main/resources/images/wikipedia_logo.png" alt="Wikipedia logo"></a>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  <br>
</div>
