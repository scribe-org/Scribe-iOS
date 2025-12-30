# Contributing to Scribe-iOS

Thank you for your interest in contributing!

Please take a moment to review this document in order to make the contribution process easy and effective for everyone involved.

Following these guidelines helps to communicate that you respect the time of the developers managing and developing this open-source project. In return, and in accordance with this project's [code of conduct](https://github.com/scribe-org/Scribe-iOS/blob/main/.github/CODE_OF_CONDUCT.md), other contributors will reciprocate that respect in addressing your issue or assessing changes and features.

If you have questions or would like to communicate with the team, please [join us in our public Matrix chat rooms](https://matrix.to/#/#scribe_community:matrix.org). We'd be happy to hear from you!

<a id="contents"></a>

# **Contents**

- [First steps as a contributor](#first-steps)
- [Learning the tech stack](#learning-the-tech)
- [Development environment](#dev-env)
  - [Note on debugging](#note-on-debugging)
- [Testing](#testing)
- [Issues and projects](#issues-projects)
- [Bug reports](#bug-reports)
- [Feature requests](#feature-requests)
- [Pull requests](#pull-requests)
- [Data edits](#data-edits)
- [Localization](#localization)
- [Documentation](#documentation)
- [Design](#design)

<a id="first-steps"></a>

## First steps as a contributor [`⇧`](#contents)

Thank you for your interest in contributing to Scribe-iOS! We look forward to welcoming you to the community and working with you to build an tools for language learners to communicate effectively :) The following are some suggested steps for people interested in joining our community:

- Please join the [public Matrix chat](https://matrix.to/#/#scribe_community:matrix.org) to connect with the community
  - [Matrix](https://matrix.org/) is a network for secure, decentralized communication
  - We'd suggest that you use the [Element](https://element.io/) client and [Element X](https://element.io/app) for a mobile app
  - The [General](https://matrix.to/#/!yQJjLmluvlkWttNhKo:matrix.org?via=matrix.org) and [iOS](https://matrix.to/#/#ScribeiOS:matrix.org) channels would be great places to start!
  - Feel free to introduce yourself and tell us what your interests are if you're comfortable :)
- Read through this contributing guide for all the information you need to contribute
- Look into issues marked [`good first issue`](https://github.com/scribe-org/Scribe-iOS/issues?q=is%3Aopen+is%3Aissue+label%3A%22good+first+issue%22) and the [Projects board](https://github.com/orgs/scribe-org/projects/1) to get a better understanding of what you can work on
- Check out our [public designs on Figma](https://www.figma.com/file/c8945w2iyoPYVhsqW7vRn6/scribe_public_designs?type=design&node-id=405-464&mode=design&t=E3ccS9Z8MDVSizQ4-0) to understand Scribes's goals and direction
- Consider joining our [bi-weekly developer sync](https://etherpad.wikimedia.org/p/scribe-dev-sync)!

> [!NOTE]
> Those new to Swift or wanting to work on their Swift skills are more than welcome to contribute! The team would be happy to help you on your development journey :)

<a id="learning-the-tech"></a>

## Learning the tech stack [`⇧`](#contents)

Scribe is very open to contributions from people in the early stages of their coding journey! The following is a select list of documentation pages to help you understand the technologies we use.

<details><summary>Docs for those new to programming</summary>
<p>

- [Mozilla Developer Network Learning Area](https://developer.mozilla.org/en-US/docs/Learn)
  - Doing MDN sections for HTML, CSS and JavaScript is the best ways to get into web development!
- [Open Source Guides](https://opensource.guide/)
  - Guides from GitHub about open-source software including how to start and much more!

</p>
</details>

<details><summary>Swift learning docs</summary>
<p>

- [Swift getting started guide](https://www.swift.org/getting-started/)
- [The Swift Programming Language guide](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/)
- [Swift Videos from Apple](https://developer.apple.com/videos/swift)
- [Swift Standard Library](https://developer.apple.com/documentation/swift/swift-standard-library)

</p>
</details>

<a id="dev-env"></a>

# Development environment [`⇧`](#contents)

Scribe-iOS is developed using the [Swift](https://developer.apple.com/swift/) coding language. Those new to Swift or wanting to develop their skills are more than welcome to contribute! The first step on your Swift journey would be to read through the [Swift documentation](https://docs.swift.org/swift-book/index.html). The general steps to setting up a development environment are:

1. Download [Xcode](https://apps.apple.com/us/app/xcode/id497799835?mt=12)

2. [Fork](https://docs.github.com/en/get-started/quickstart/fork-a-repo) the [Scribe-iOS repo](https://github.com/scribe-org/Scribe-iOS), clone your fork, and configure the remotes:

> [!NOTE]
>
> <details><summary>Consider using SSH</summary>
>
> <p>
>
> Alternatively to using HTTPS as in the instructions below, consider SSH to interact with GitHub from the terminal. SSH allows you to connect without a user-pass authentication flow.
>
> To run git commands with SSH, remember then to substitute the HTTPS URL, `https://github.com/...`, with the SSH one, `git@github.com:...`.
>
> - e.g. Cloning (with submodules) now becomes `git clone --recurse-submodules git@github.com:<your-username>/Scribe-iOS.git`
>
> GitHub also has their documentation on how to [Generate a new SSH key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) 🔑
>
> </p>
> </details>

> [!NOTE]
> Cloning this repository with `--recurse-submodules` also clones a copy of [Scribe-i18n](https://github.com/scribe-org/Scribe-i18n) where the texts for Scribe projects are localized. When pulling changes from `main`, you should also run the following command: `git submodule update --init --recursive`.

```bash
# Clone your fork of the repo into the current directory (including submodules).
git clone --recurse-submodules https://github.com/<your-username>/Scribe-iOS.git
# Navigate to the newly cloned directory.
cd Scribe-iOS
# Assign the original repo to a remote called "upstream".
git remote add upstream https://github.com/scribe-org/Scribe-iOS.git
```

- Now, if you run `git remote -v` you should see two remote repositories named:
  - `origin` (forked repository)
  - `upstream` (Scribe-iOS repository)

3. (Optional) Install [pre-commit](https://pre-commit.com/) and its hooks to check for and correct common errors in commits:

```bash
pip install pre-commit
pre-commit install
# pre-commit run --all-files
```

4. Open the Scribe-iOS directory in Xcode

5. In order to run Scribe on an emulator:

   - Read the [documentation from Apple](https://developer.apple.com/documentation/xcode/running-your-app-in-the-simulator-or-on-a-device) if need be
   - In the top bar select Scribe as the scheme
   - If you're debugging you'll need to select the keyboard you're testing as the scheme (see the [note on debugging](#note-on-debugging) below)
   - Select a device to run the app on
   - Press the run button marked `Start the active scheme`
   - From here code edits that are made will be reflected in the app each time the active scheme is restarted

6. Build the developer documentation by selecting `Product` > `Build Documentation` (^⇧⌘D)

> [!NOTE]
> Feel free to contact the team in the [iOS room on Matrix](https://matrix.to/#/#ScribeiOS:matrix.org) if you're having problems getting your environment setup!

<a id="note-on-debugging"></a>

### Note on debugging

The Xcode debugger often doesn't work as expected for Scribe as the keyboards themselves are extensions. To get breakpoints and the debugger to work as you'd expect them to:

- Go up to the top bar where your schemes are (this is a bit to the right of the run button) and change it from Scribe to the language of the keyboard you'd like to debug [(see a screenshot of this)](https://raw.githubusercontent.com/scribe-org/Scribe-iOS/main/.github/resources/images/select_scheme_for_debugging.png)
- Choose a device as normal
- Hit the run button (or ⌘-R) to start the active scheme
- When you get a window telling you to "choose an app to run", don't choose Scribe as you might expect, but instead scroll down and select Xcode Previews
- Occasionally you'll be met with just a black screen on startup, in which case you can press Home (or ⇧-⌘-H) and then go directly to Scribe or an app for keyboard testing

<a id="testing"></a>

## Testing [`⇧`](#contents)

Writing unit tests is essential to guarantee the dependability and sustainability of the Scribe-iOS codebase. Unit tests confirm that individual components of the application work as intended by detecting errors at an early stage, thus making the debugging process easier and boosting assurance for upcoming modifications. An unchanging testing method helps new team members grasp project norms and anticipated actions.

In addition to the [pre-commit](https://pre-commit.com/) hooks that are set up during the [development environment section](#dev-env), Scribe-iOS includes a testing suite that should be ran before all pull requests and subsequent commits.

Please run the following in the project root:

```bash
# If you don't have swiftlint installed:
# brew install swiftlint

# Lint the project:
swiftlint --strict
```

If you see that there are linting errors above, then please run the following command to hopefully fix them automatically:

```bash
swiftlint --fix
```

For testing and code coverage, please run the following command:

```bash
# Clear prior builds if needed:
# rm -rf Build

xcodebuild -scheme Scribe -derivedDataPath Build/ -destination 'platform=iOS Simulator,name=iPhone 16,OS=latest' clean build test -enableCodeCoverage YES CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO
```

Generate the coverage report JSON with the following:

```bash
xcrun xccov view --report $(find ./Build/Logs/Test -name '*.xcresult') --json > code_coverage.json
```

And finally view the coverage report in the terminal:

```bash
python3 Tests/process_coverage_report.py code_coverage.json

# You can also pass an integer or double to check against a threshold:
# python3 Tests/process_coverage_report.py code_coverage.json NUMERIC_THRESHOLD
```

> [!NOTE]
> See [Tests/process_coverage_report.py](./Tests/process_coverage_report.py) for details.

<a id="issues-projects"></a>

# Issues and projects [`⇧`](#contents)

The [issue tracker for Scribe-iOS](https://github.com/scribe-org/Scribe-iOS/issues) is the preferred channel for [bug reports](#bug-reports), [features requests](#feature-requests) and [submitting pull requests](#pull-requests). Scribe also organizes related issues into [projects](https://github.com/scribe-org/Scribe-iOS/projects).

> [!NOTE]\
> Just because an issue is assigned on GitHub doesn't mean the team isn't open to your contribution! Feel free to write [in the issues](https://github.com/scribe-org/Scribe-iOS/issues) and we can potentially reassign it to you.

Be sure to check the [`-next release-`](https://github.com/scribe-org/Scribe-iOS/labels/-next%20release-) and [`-priority-`](https://github.com/scribe-org/Scribe-iOS/labels/-priority-) labels in the [issues](https://github.com/scribe-org/Scribe-iOS/issues) for those that are most important, as well as those marked [`good first issue`](https://github.com/scribe-org/Scribe-iOS/issues?q=is%3Aissue+is%3Aopen+label%3A%22good+first+issue%22) that are tailored for first-time contributors.

<a id="bug-reports"></a>

# Bug reports [`⇧`](#contents)

A bug is a _demonstrable problem_ that is caused by the code in the repository. Good bug reports are extremely helpful - thank you!

Guidelines for bug reports:

1. **Use the GitHub issue search** to check if the issue has already been reported.

2. **Check if the issue has been fixed** by trying to reproduce it using the latest `main` or development branch in the repository.

3. **Isolate the problem** to make sure that the code in the repository is _definitely_ responsible for the issue.

**Great Bug Reports** tend to have:

- A quick summary
- Steps to reproduce
- What you expected would happen
- What actually happens
- Notes (why this might be happening, things tried that didn't work, etc)

To make the above steps easier, the Scribe team asks that contributors report bugs using the [bug report template](https://github.com/scribe-org/Scribe-iOS/issues/new?assignees=&labels=feature&template=bug_report.yml), with these issues further being marked with the [`Bug`](https://github.com/scribe-org/Scribe-iOS/issues?q=is%3Aissue%20state%3Aopen%20type%3ABug) type.

Again, thank you for your time in reporting issues!

<a id="feature-requests"></a>

# Feature requests [`⇧`](#contents)

Feature requests are more than welcome! Please take a moment to find out whether your idea fits with the scope and aims of the project. When making a suggestion, provide as much detail and context as possible, and further make clear the degree to which you would like to contribute in its development. Feature requests are marked with the [`Feature`](https://github.com/scribe-org/Scribe-iOS/issues?q=is%3Aissue%20state%3Aopen%20type%3AFeature) type, and can be made using the [feature request](https://github.com/scribe-org/Scribe-iOS/issues/new?assignees=&labels=feature&template=feature_request.yml) template.

<a id="pull-requests"></a>

# Pull requests [`⇧`](#contents)

Good pull requests - patches, improvements and new features - are the foundation of our community making Scribe-iOS. They should remain focused in scope and avoid containing unrelated commits. Note that all contributions to this project will be made under [the specified license](https://github.com/scribe-org/Scribe-iOS/blob/main/LICENSE.txt) and should follow the coding indentation and style standards ([contact us](https://matrix.to/#/#scribe_community:matrix.org) if unsure).

**Please ask first** before embarking on any significant pull request (implementing features, refactoring code, etc), otherwise you risk spending a lot of time working on something that the developers might not want to merge into the project. With that being said, major additions are very appreciated!

When making a contribution, adhering to the [GitHub flow](https://guides.github.com/introduction/flow/index.html) process is the best way to get your work merged:

1. If you cloned a while ago, get the latest changes from upstream:

   ```bash
   git checkout <dev-branch>
   git pull upstream <dev-branch>
   ```

2. Create a new topic branch (off the main project development branch) to contain your feature, change, or fix:

   ```bash
   git checkout -b <topic-branch-name>
   ```

3. Commit your changes in logical chunks, and please try to adhere to [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/).

> [!NOTE]
> The following are tools and methods to help you write good commit messages ✨
>
> - [commitlint](https://commitlint.io/) helps write [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/)
> - Git's [interactive rebase](https://docs.github.com/en/github/getting-started-with-github/about-git-rebase) cleans up commits

4. Locally merge (or rebase) the upstream development branch into your topic branch:

   ```bash
   git pull --rebase upstream <dev-branch>
   ```

5. Push your topic branch up to your fork:

   ```bash
   git push origin <topic-branch-name>
   ```

6. [Open a Pull Request](https://help.github.com/articles/using-pull-requests/) with a clear title and description.

Thank you in advance for your contributions!

<a id="data-edits"></a>

# Data edits [`⇧`](#contents)

> [!NOTE]\
> Please see the [Wikidata and Scribe Guide](https://github.com/scribe-org/Organization/blob/main/WIKIDATAGUIDE.md) for an overview of [Wikidata](https://www.wikidata.org/) and how Scribe uses it.

Scribe does not accept direct edits to the grammar files as they are sourced from [Wikidata](https://www.wikidata.org/). Edits can be discussed and the [Scribe-Data](https://github.com/scribe-org/Scribe-Data) queries will be changed. If there is a problem with one of the files, then the fix should be made on [Wikidata](https://www.wikidata.org/) and not on Scribe. Feel free to let us know that edits have been made by [opening a data issue](https://github.com/scribe-org/Conjugate-iOS/issues/new?assignees=&labels=data&template=data_wikidata.yml) or contacting us in the [issues for Scribe-Data](https://github.com/scribe-org/Scribe-Data/issues) and we'll be happy to integrate them!

<a id="localization"></a>

# Localization [`⇧`](#contents)

<a href="https://hosted.weblate.org/projects/scribe/scribe-i18n">
  <img src="https://raw.githubusercontent.com/scribe-org/Organization/main/resources/images/logos/WeblateLogo.png" width="125" alt="Visit Weblate project" align="right">
</a>

Being an app that focusses on language learning, localization plays a big part in what Scribe will eventually be. Those interested are more than welcome to join the team at [scribe-org/Scribe-i18n](https://github.com/scribe-org/Scribe-i18n) where we work on localizing all Scribe applications via [Weblate](https://weblate.org/).

Please run the [update_i18n_keys.sh](https://github.com/scribe-org/Scribe-iOS/blob/main/update_i18n_keys.sh) script to load in the most recent version of the [Scribe-i18n](https://github.com/scribe-org/Scribe-i18n) app texts into Scribe-iOS.

### Progress

<a href="https://hosted.weblate.org/projects/scribe/scribe-i18n">
    <img src="https://hosted.weblate.org/widget/scribe/scribe-i18n/multi-auto.svg" alt="Translation status" />
</a>

<a id="documentation"></a>

# Documentation [`⇧`](#contents)

Documentation is an invaluable way to contribute to coding projects as it allows others to more easily understand the project structure and contribute. Issues related to documentation are marked with the [`documentation`](https://github.com/scribe-org/Scribe-iOS/labels/documentation) label.

<a id="design"></a>

# Design [`⇧`](#contents)

<a href="https://www.figma.com/file/c8945w2iyoPYVhsqW7vRn6/scribe_public_designs?node-id=405%3A464">
  <img src="https://raw.githubusercontent.com/scribe-org/Organization/main/resources/images/logos/FigmaLogo.png" width="100" alt="Public Figma Designs" align="right">
</a>

Designs for Scribe are done in the [public design file in Figma](https://www.figma.com/file/c8945w2iyoPYVhsqW7vRn6/scribe_public_designs?node-id=405%3A464). Those interested in helping with Scribe's design are also welcome to share their ideas using the [design improvement](https://github.com/scribe-org/Scribe-iOS/issues/new?assignees=&labels=design&template=design_improvement.yml) template that makes an issue marked with the [`design`](https://github.com/scribe-org/Scribe-iOS/issues?q=is%3Aopen+is%3Aissue+label%3Adesign) label.

All branding elements such as logos, icons, colors and fonts should follow those that are set out in [scribe-org/Organization](https://github.com/scribe-org/Organization). As the project is fully open source, these elements are also open for discussion. Efforts in making Scribe products professional with a distinct and cohesive identity are much appreciated!
