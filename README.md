<div align="center">
  <a href="https://github.com/scribe-org/Scribe-iOS"><img src="https://raw.githubusercontent.com/scribe-org/Organization/main/logo/ScribeGitHubOrgBanner.png" width=1024 alt="Scribe Logo"></a>
</div>

<!---
[![ci](https://img.shields.io/github/workflow/status/scribe-org/Scribe-iOS/CI?logo=github)](https://github.com/scribe-org/Scribe-iOS/actions?query=workflow%3ACI)
--->

[![platforms](https://img.shields.io/static/v1?message=iOS%20│%20iPadOS&logo=apple&color=999999&logoColor=white&label=%20)](https://apps.apple.com/app/scribe-language-keyboards/id1596613886)
[![version](https://img.shields.io/github/v/release/scribe-org/Scribe-iOS?color=%2300550&sort=semver&label=%20)](https://github.com/scribe-org/Scribe-iOS/releases/)
[![issues](https://img.shields.io/github/issues/scribe-org/Scribe-iOS?label=%20&logo=github)](https://github.com/scribe-org/Scribe-iOS/issues)
[![language](https://img.shields.io/badge/Swift%205-F0513C.svg?logo=swift&logoColor=ffffff)](https://github.com/scribe-org/Scribe-iOS/blob/main/CONTRIBUTING.md)
[![license](https://img.shields.io/github/license/scribe-org/Scribe-iOS.svg?label=%20)](https://github.com/scribe-org/Scribe-iOS/blob/main/LICENSE.txt)
[![coc](https://img.shields.io/badge/Contributor%20Covenant-ff69b4.svg)](https://github.com/scribe-org/Scribe-iOS/blob/main/.github/CODE_OF_CONDUCT.md)
[![mastodon](https://img.shields.io/badge/Mastodon-6364FF.svg?logo=mastodon&logoColor=ffffff)](https://wikis.world/@scribe)
[![twitter](https://img.shields.io/badge/Twitter-1DA1F2.svg?logo=twitter&logoColor=ffffff)](https://twitter.com/scribe_org)
[![matrix](https://img.shields.io/badge/Matrix-000000.svg?logo=matrix&logoColor=ffffff)](https://matrix.to/#/#scribe_community:matrix.org)

<a href='https://apps.apple.com/app/scribe-language-keyboards/id1596613886'><img alt='Available on the App Store' src='https://raw.githubusercontent.com/scribe-org/Scribe-iOS/main/.github/resources/images/app_store_badge.png' height='60px'/></a>

<details><summary>🌐 Language</summary>
<p>

- [Open a localization issue](https://github.com/scribe-org/Scribe-iOS/issues/new?assignees=&labels=localization&template=localization.yml) to add a new readme to the [README](https://github.com/scribe-org/Scribe-iOS/tree/main/README) directory

</p>
</details>

## iOS app with keyboards for language learners

**Scribe-iOS** is a pack of iOS and iPadOS keyboards for language learners. Features include translation **`(beta)`**, verb conjugation and word annotation that give users the tools needed to communicate with confidence.

Scribe is fully open-source and does not collect usage data or ask for system access. Feature data is sourced from [Wikidata](https://www.wikidata.org/) and stored in-app, meaning Scribe is a highly responsive experience that does not require an internet connection.

> **Note**: The [contributing](#contributing) section has information for those interested, with the articles and presentations in [featured by](#featured-by) also being good resources for learning more about Scribe.

Also available on [Android](https://github.com/scribe-org/Scribe-Android) (WIP), [Desktop](https://github.com/scribe-org/Scribe-Desktop) (planned) and for the data processes see [Scribe-Data](https://github.com/scribe-org/Scribe-Data).

<a id="contents"></a>

# **Contents**

- [Preview Videos](#preview-videos)
- [Contributing](#contributing)
- [Setup](#setup)
- [Supported Languages](#supported-languages)
- [Keyboard Features](#keyboard-features)
- [Language Practice](#language-practice)
- [Featured By](#featured-by)

<a id="preview-videos"></a>

# Preview Videos [`⇧`](#contents)

The following are the preview videos for the [App Store](https://apps.apple.com/app/scribe-language-keyboards/id1596613886):

#### iPhone 6.7" version

https://user-images.githubusercontent.com/24387426/231612322-7afca555-a3c5-4f1c-81a7-a64df86ff797.mp4

#### See also

<details><summary><strong>iPad Pro 4th gen version</strong></summary>
<p>

https://user-images.githubusercontent.com/24387426/231612346-af8b3f62-adf1-4f24-a6ff-91bfb6232c35.mp4

</p>
</details>

<a id="contributing"></a>

# Contributing [`⇧`](#contents)

<a href="https://matrix.to/#/#scribe_community:matrix.org"><img src="https://raw.githubusercontent.com/scribe-org/Organization/main/resources/images/logos/MatrixLogoGrey.png" height="50" alt="Public Matrix Chat" align="right"></a>

Scribe uses [Matrix](https://matrix.org/) for communications. You're more than welcome to [join us in our public chat rooms](https://matrix.to/#/#scribe_community:matrix.org) to share ideas, ask questions or just say hi :)

Please also see the [contribution guidelines](https://github.com/scribe-org/Scribe-iOS/blob/main/CONTRIBUTING.md) if you are interested in contributing to Scribe-iOS. Work that is in progress or could be implemented is tracked in the [issues](https://github.com/scribe-org/Scribe-iOS/issues) and [projects](https://github.com/scribe-org/Scribe-iOS/projects).

> **Note**: Just because an issue is assigned on GitHub doesn't mean that the team isn't interested in your contribution! Feel free to write [in the issues](https://github.com/scribe-org/Scribe-iOS/issues) and we can potentially reassign it to you.

Those interested can further check the [`-next release-`](https://github.com/scribe-org/Scribe-iOS/labels/-next%20release-) and [`-priority-`](https://github.com/scribe-org/Scribe-iOS/labels/-priority-) labels in the [issues](https://github.com/scribe-org/Scribe-iOS/issues) for those that are most important, as well as those marked [`good first issue`](https://github.com/scribe-org/Scribe-iOS/issues?q=is%3Aissue+is%3Aopen+label%3A%22good+first+issue%22) that are tailored for first time contributors.

After your first few pull requests organization members would be happy to discuss granting you further rights as a contributor, with a maintainer role then being possible after continued interest in the project. Scribe seeks to be an inclusive and supportive organization. We'd love to have you on the team!

### Development environment [`⇧`](#contents)

Scribe-iOS is developed using the [Swift](https://developer.apple.com/swift/) coding language. Those new to Swift or wanting to develop their skills are more than welcome to contribute! The first step on your Swift journey would be to read through the [Swift documentation](https://docs.swift.org/swift-book/index.html). The general steps to setting up a development environment are:

1. Download [Xcode](https://apps.apple.com/us/app/xcode/id497799835?mt=12)
2. [Fork](http://help.github.com/fork-a-repo/) a copy of the [Scribe-iOS](https://github.com/scribe-org/Scribe-iOS) repository
   - Alternatively you can [clone](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository) the repository
3. Open the Scribe-iOS directory in Xcode
4. In order to run Scribe on an emulator:

   - Read the [documentation from Apple](https://developer.apple.com/documentation/xcode/running-your-app-in-the-simulator-or-on-a-device) if need be
   - In the top bar select Scribe as the scheme
   - Select a device to run the app on
   - Press the run button marked `Start the active scheme`

From there code edits that are made will be reflected in the app each time the active scheme is restarted.

> **Warning**: Note on Debugging
>
> Because Scribe is a keyboard extension, the Xcode debugger doesn't work as expected when debugging a regular app. Please see the [note on debugging](./CONTRIBUTING.md#note-on-debugging) in [CONTRIBUTING.md](./CONTRIBUTING.md) to learn how to get it working properly.

### Ways to Help [`⇧`](#contents)

- [Reporting bugs](https://github.com/scribe-org/Scribe-iOS/issues/new?assignees=&labels=bug&template=bug_report.yml) as they're found 🐞
- Working on [new features](https://github.com/scribe-org/Scribe-iOS/issues?q=is%3Aissue+is%3Aopen+label%3Afeature) ✨
- [Localization](https://github.com/scribe-org/Scribe-iOS/issues?q=is%3Aissue+is%3Aopen+label%3Alocalization) for the app and App Store 🌐
- [Documentation](https://github.com/scribe-org/Scribe-iOS/issues?q=is%3Aissue+is%3Aopen+label%3Adocumentation) for onboarding and project cohesion 📝
- Adding language data to [Scribe-Data](https://github.com/scribe-org/Scribe-Data/issues) via [Wikidata](https://www.wikidata.org/)! 🗃️
- [Sharing Scribe-iOS](https://github.com/scribe-org/Scribe-iOS/issues/181) with others! 🚀

### Road Map [`⇧`](#contents)

The Scribe road map can be followed in the organization's [project board](https://github.com/orgs/scribe-org/projects/1) where we list the most important issues along with their priority, status and an indication of which sub projects they're included in (if applicable).

### Data Edits [`⇧`](#contents)

Scribe does not accept direct edits to the grammar JSON files as they are sourced from [Wikidata](https://www.wikidata.org/). Edits can be discussed and the [Scribe-Data](https://github.com/scribe-org/Scribe-Data) queries will be changed and ran before an update. If there is a problem with one of the files, then the fix should be made on [Wikidata](https://www.wikidata.org/) and not on Scribe. Feel free to let us know that edits have been made by [opening a data issue](https://github.com/scribe-org/Scribe-iOS/issues/new?assignees=&labels=data&template=data_wikidata.yml) or contacting us in the [issues for Scribe-Data](https://github.com/scribe-org/Scribe-Data/issues) and we'll be happy to integrate them!

### Designs [`⇧`](#contents)

<a href="https://www.figma.com/file/c8945w2iyoPYVhsqW7vRn6/scribe_public_designs?node-id=405%3A464"><img src="https://raw.githubusercontent.com/scribe-org/Organization/main/resources/images/logos/FigmaLogo.png" height="50" alt="Public Figma Designs" align="right"></a>

The [designs for Scribe](https://www.figma.com/file/c8945w2iyoPYVhsqW7vRn6/scribe_public_designs?node-id=405%3A464) are made using [Figma](https://www.figma.com). The App Store videos, images and text can be found in the [AppStore](https://github.com/scribe-org/Scribe-iOS/blob/main/AppStore) directory. Those with interest in contributing can [open a design issue](https://github.com/scribe-org/Scribe-iOS/issues/new?assignees=&labels=design&template=design_improvement.yml) to make suggestions! Design related issues are marked with the [`design`](https://github.com/scribe-org/Scribe-iOS/issues?q=is%3Aopen+is%3Aissue+label%3Adesign) label.

<a id="setup"></a>

# Setup [`⇧`](#contents)

Users access Scribe language keyboards through the following:

- Download **Scribe - Language Keyboards** from the [App Store](https://apps.apple.com/app/scribe-language-keyboards/id1596613886)
- <details><summary>Open Settings, and navigate to General -> Keyboard -> Keyboards</summary><kbd><img src="https://user-images.githubusercontent.com/82060372/198514330-f24d9818-3917-4898-8898-6730cdb5ac67.jpeg" height="300"></kbd><kbd><img src="https://user-images.githubusercontent.com/82060372/198514334-29e25e2d-a0fa-4a0e-bb83-cfbb6321975d.jpeg" height="300"></kbd><kbd><img src="https://user-images.githubusercontent.com/82060372/198514337-782354bf-6629-4296-95a7-dcfc94bab59d.jpeg" height="300"></kbd></details>
- <details><summary>Tap add New Keyboard and select Scribe</summary><kbd><img src="https://user-images.githubusercontent.com/82060372/198164351-44d16a60-9a44-450e-9b55-6a6d7ee0265d.jpeg" height="300"></kbd></details>
- <details><summary>Choose from the available language keyboards</summary><kbd><img src="https://user-images.githubusercontent.com/82060372/198461014-a3ecbfaf-43b8-4773-8992-3e5707043fb8.jpeg" height="300"></kbd></details>
- <details><summary>When typing press 🌐 to select keyboards</summary><kbd><img src="https://user-images.githubusercontent.com/82060372/198164365-ed14cc87-a2c7-4353-9264-26819483b3b2.jpeg" height="300"></kbd></details>

For more information on features and use cases, see [Keyboard Features](#keyboard-features) below!

<a id="supported-languages"></a>

# Supported Languages [`⇧`](#contents)

Scribe's goal is functional, feature-rich keyboards for all languages. Check [scribe_data/extract_transform](https://github.com/scribe-org/Scribe-Data/tree/main/src/scribe_data/extract_transform) for queries for currently supported languages and those that have substantial data on [Wikidata](https://www.wikidata.org/). Also see the [`new keyboard`](https://github.com/scribe-org/Scribe-iOS/issues?q=is%3Aissue+is%3Aopen+label%3A%22new+keyboard%22) label in the [Issues](https://github.com/scribe-org/Scribe-iOS/issues) for keyboards that are currently in progress or being discussed, and [suggest a new keyboard](https://github.com/scribe-org/Scribe-iOS/issues/new?assignees=&labels=new+keyboard&template=new_keyboard.yml&title=Add+%3Clanguage%3E+keyboard) if you don't see it being worked on already!

The following table shows the supported languages and the amount of data available for each on [Wikidata](https://www.wikidata.org/) and via [Unicode CLDR](https://github.com/unicode-org/cldr) for emojis:

| Languages  |   Nouns | Verbs | Translations\* | Prepositions† | Emoji Keywords |
| :--------- | ------: | ----: | -------------: | ------------: | -------------: |
| French     |  17,072 | 6,572 |         67,652 |             - |          2,488 |
| German     | 102,833 | 3,593 |         67,652 |           210 |          2,898 |
| Italian    |   8,671 |    73 |         67,652 |             - |          2,457 |
| Portuguese |   5,437 |   536 |         67,652 |             - |          2,327 |
| Russian    | 194,448 |    12 |         67,652 |            15 |          3,827 |
| Spanish    |  39,105 | 4,930 |         67,652 |             - |          3,134 |
| Swedish    |  45,259 | 4,501 |         67,652 |             - |          2,913 |

`*` Given the current **`beta`** status where words are machine translated.

`†` Only for languages for which preposition annotation is needed.

Updates to the above data can be done using [scribe_data/load/update_data.py](https://github.com/scribe-org/Scribe-Data/tree/main/src/scribe_data/load/update_data.py).

<a id="keyboard-features"></a>

# Keyboard Features [`⇧`](#contents)

Keyboard features are accessed via the `Scribe key` at the top left of any Scribe keyboard. Pressing this key gives the user three new selectable options: `Translate`, `Conjugate` and `Plural` in the keyboard's language. These keys allow for words to be queried and inserted into the text field followed by a space.

**Current features include:**

### Translation [`⇧`](#contents)

The **`beta`** `Translate` feature can translate single words or phrases from English into the language of the current keyboard when the `return` key is pressed. The goal is that `Translate` will eventually provide options for entered words where a user can use grammatical categories and synonyms to select the best option [(see issue)](https://github.com/scribe-org/Scribe-iOS/issues/49). Then the feature will expand to allow translations from system and chosen languages. More advanced methods will be planned once this feature is out of **`beta`**.

As of now translations are not widely available on [Wikidata](https://www.wikidata.org/) [(see issue)](https://github.com/scribe-org/Scribe-iOS/issues/40). The current functionality is thus based on [🤗 Transformers](https://github.com/huggingface/transformers) machine translations of words queried from [Wikidata](https://www.wikidata.org/). The ultimate goal is for the translations and synonyms to all be directly queried.

### Verb Conjugation [`⇧`](#contents)

With the `Conjugate` feature, a user is presented with the grammar charts for an entered verb instead of the keyboard. Pressing an example in the charts inserts the chosen conjugation into the text field.

### Noun Plurals [`⇧`](#contents)

The `Plural` feature allows a user to enter a noun and then insert its plural into the text field when the `return` key is pressed.

### Word Annotation [`⇧`](#contents)

Scribe further annotates words in the command bar to help users understand the context of what they're typing. Annotations are displayed once a user has typed a given word and pressed space, after commands, by pressing the `Scribe key` while it is selected as well as under autocompletions and autosuggestions. The hope is that annotation will help a user remember grammar rules even when not using Scribe.

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

### Pronoun Selection [`⇧`](#contents)

Annotations for preposition cases can also be pressed to provide a conjugation display where the user can select the proper pronoun for the given case. The conjugation view will also provide appropriate interfaces to subset the available pronouns based on the desired subject and object combinations to help the user make the correct choice.

### Base Functionality [`⇧`](#contents)

The goal is for Scribe to have all the functionality of system keyboards. See the [issues](https://github.com/scribe-org/Scribe-iOS/issues/) if interested in helping.

<details><summary><strong>Current base features include:</strong></summary>
<p>

- iPhone and iPad support
- Dynamic layouts for cross-device performance
- Portrait and landscape modes
- Dark mode compatibility
- Autocompletion based on [Wikidata](https://www.wikidata.org/) sourced words
- Autosuggestion based on [Wikipedia](https://www.wikipedia.org/) derived relationships
- Emoji autocompletions and autosuggestions based on [Unicode CLDR](https://github.com/unicode-org/cldr) sourced emojis
- Autocorrect (WIP - see [Autocorrect](https://github.com/scribe-org/Scribe-iOS/issues/2) issue)
- Auto-capitalization following `.`, `?` and `!`
- The double space period shortcut
- Typing symbols and numbers followed by a space returns keyboard to letters
- Hold-to-select characters for letters and symbols
- Key pop up views for letters and symbols

</p>
</details>

<a id="language-practice"></a>

# Language Practice [`⇧`](#contents)

A future feature of Scribe is language practice within the app itself. Scribe presents users with information that is directly relevant to their current struggles with a second language. This information can be saved in-app and used to create personalized lessons such as flashcards to reinforce the information that Scribe has provided.

<a id="featured-by"></a>

# Featured By [`⇧`](#contents)

<details open><summary><strong>Articles and Presentations on Scribe</strong></summary>
<p>

<strong>2023</strong>

- June: [Scribe iOS development blog post on Nested UITableViews & Apple's built-in ViewControllers in app menu](https://saurabhjamadagni.hashnode.dev/nested-uitableviews-apples-built-in-viewcontrollers) for [GSoC '23](https://www.mediawiki.org/wiki/Google_Summer_of_Code/2023#Accepted_projects:~:text=links%3A%20Phabricator%20issue-,3.%20Adding%20a%20Menu%20and%20Keyboards%20to%20Scribe%2DiOS,-%5Bedit%5D)
- March: [Presentation slides](https://docs.google.com/presentation/d/1W4ZkGi9UDDiTxM_silEij0gTE8YEubluHxe78xoqEP0/edit?usp=sharing) for a talk at [Berlin Hack and Tell](https://berlinhackandtell.rocks/) ([Hack of the month winner 🏆](https://berlinhackandtell.rocks/2023-03-28-no87-moore-hacks))

<strong>2022</strong>

- August: [Presentation slides](https://docs.google.com/presentation/d/12WNSt5xgNIAmSxPfvjno9-sBMGlvxG_xSaAxmHQDRNQ/edit?usp=sharing) for a session at the [2022 Wikimania Hackathon](https://wikimania.wikimedia.org/wiki/2022:Hackathon)
- July: [Presentation slides](https://docs.google.com/presentation/d/10Ai0-b8XUj5u9Hw4UgBtB7ufiPhvfFrb1vEUEyXYr5w/edit?usp=sharing) for a talk at [CocoaHeads Berlin](https://www.meetup.com/cocoaheads-berlin/)
- July: [Video on Scribe](https://www.youtube.com/watch?v=4GpFN0gGmy4&list=PL66MRMNlLyR7p9wsYVfuqJOjKZpbuwp8U&index=6) for [Wikimedia Celtic Knot 2022](https://meta.wikimedia.org/wiki/Celtic_Knot_Conference_2022)
- June: [Presentation slides](https://docs.google.com/presentation/d/1K2lj8PPgdx12I-xuhm--CBLrGm-Cz50NJmbp96zpGrk/edit?usp=sharing) for a talk with the [LD4 Wikidata Affinity Group](https://www.wikidata.org/wiki/Wikidata:WikiProject_LD4_Wikidata_Affinity_Group)
- June: [Scribe](https://github.com/scribe-org) featured for new developers on [MediaWiki](https://www.mediawiki.org/wiki/New_Developers)
- May: [Presentation slides](https://docs.google.com/presentation/d/1Cu3VwQ3lJUp5W84YDe0AFYS-6zfBxKsm0MI-OMl_IzY/edit?usp=sharing) for [Wikimedia Hackathon 2022](https://www.mediawiki.org/wiki/Wikimedia_Hackathon_2022)
- March: [Blog post](https://tech-news.wikimedia.de/en/2022/03/18/lexicographical-data-for-language-learners-the-wikidata-based-app-scribe/) on [Scribe-iOS](https://github.com/scribe-org/Scribe-iOS) for [Wikimedia Tech News](https://tech-news.wikimedia.de/en/homepage/) ([DE](https://tech-news.wikimedia.de/2022/03/18/sprachenlernen-mit-lexikografische-daten-die-wikidata-basierte-app-scribe/) / [Tweet](https://twitter.com/wikidata/status/1507335538596106257?s=20&t=YGRGamftI-5B_VwQ_bFRhA))
- March: [Presentation slides](https://docs.google.com/presentation/d/16ld_rCbwJCiAdRrfhF-Fq9Wm_ciHCbk_HCzGQs6TB1Q/edit?usp=sharing) for [Wikidata Data Reuse Days 2022](https://diff.wikimedia.org/event/wikidata-data-reuse-days-2022/)

</p>
</details>

<div align="center">
  <br>
    <a href="https://tech-news.wikimedia.de/en/2022/03/18/lexicographical-data-for-language-learners-the-wikidata-based-app-scribe/"><img height="120"src="https://raw.githubusercontent.com/scribe-org/Organization/main/resources/images/logos/WikimediaDeutschlandLogo.png" alt="Wikimedia Deutschland logo linking to an article on Scribe in the tech news blog."></a>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <a href="https://www.mediawiki.org/wiki/New_Developers"><img height="120" src="https://raw.githubusercontent.com/scribe-org/Organization/main/resources/images/logos/MediawikiLogo.png" alt="MediaWiki logo linking to the new developers page."></a>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <a href="https://summerofcode.withgoogle.com/"><img height="120" src="https://raw.githubusercontent.com/scribe-org/Organization/main/resources/images/logos/GSoCLogo.png" alt="Google Summer of Code logo linking to its website."></a>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  <br>
</div>

# Powered By

### Contributors

Many thanks to all the [Scribe-iOS contributors](https://github.com/scribe-org/Scribe-iOS/graphs/contributors)! 🚀

<a href="https://github.com/scribe-org/Scribe-iOS/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=scribe-org/Scribe-iOS" />
</a>

### Code

<details><summary><strong>List of referenced code</strong></summary>
<p>

- [CustomKeyboard](https://github.com/EthanSK/CustomKeyboard) by [EthanSK](https://github.com/EthanSK) ([License](https://github.com/EthanSK/CustomKeyboard/blob/master/LICENSE))

</p>
</details>

### Wikimedia Communities

<div align="center">
  <br>
  <a href="https://www.wikidata.org/"><img height="175" src="https://raw.githubusercontent.com/scribe-org/Organization/main/resources/images/logos/WikidataLogo.png" alt="Wikidata logo"></a>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  <a href="https://www.wikipedia.org/"><img height="190" src="https://raw.githubusercontent.com/scribe-org/Organization/main/resources/images/logos/WikipediaLogo.png" alt="Wikipedia logo"></a>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  <br>
</div>
