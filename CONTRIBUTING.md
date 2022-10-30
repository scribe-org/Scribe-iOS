# Contributing to Scribe-iOS

Thank you for your interest in contributing!

Please take a moment to review this document in order to make the contribution process easy and effective for everyone involved.

Following these guidelines helps to communicate that you respect the time of the developers managing and developing this open-source project. In return, and in accordance with this project's [code of conduct](https://github.com/scribe-org/Scribe-iOS/blob/main/.github/CODE_OF_CONDUCT.md), other contributors will reciprocate that respect in addressing your issue or assessing changes and features.

<a id="contents"></a>

# **Contents**

- [Development environment](#dev-env)
  - [Note on debugging](#note-on-debugging)
- [Issues and projects](#issues-projects)
- [Bug reports](#bug-reports)
- [Feature requests](#feature-requests)
- [Pull requests](#pull-requests)
- [Data edits](#data-edits)
- [Localization](#localization)
- [Documentation](#documentation)
- [Design](#design)

<a id="dev-env"></a>

# Development environment [`⇧`](#contents)

Scribe-iOS is developed using the [Swift](https://developer.apple.com/swift/) coding language. Those new to Swift or wanting to develop their skills are more than welcome to contribute! The first step on your Swift journey would be to read through the [Swift documentation](https://docs.swift.org/swift-book/index.html). The general steps to setting up a development environment are:

1. Download [Xcode](https://apps.apple.com/us/app/xcode/id497799835?mt=12)
2. [Fork](http://help.github.com/fork-a-repo/) a copy of the [Scribe-iOS](https://github.com/scribe-org/Scribe-iOS) repository
   - Alternatively you can [clone](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository) the repository
3. Open the Scribe-iOS directory in Xcode
4. In order to run Scribe on an emulator:

   - Read the [documentation from Apple](https://developer.apple.com/documentation/xcode/running-your-app-in-the-simulator-or-on-a-device) if need be
   - In the top bar select Scribe as the scheme
     - If you're debugging you'll need to select the keyboard you're testing as the scheme (see the [note on debugging](#note-on-debugging) below)
   - Select a device to run the app on
   - Press the run button marked "Start the active scheme"

From there code edits that are made will be reflected in the app each time the active scheme is restarted.

Again, those new to Swift or wanting to work on their Swift skills are more than welcome to contribute! Scribe itself was developed as a way to learn Swift and iOS coding. The team would be happy to help you on your development journey :)

<a id="note-on-debugging"></a>

### Note on debugging

The Xcode debugger often doesn't work as expected for Scribe as the keyboards themselves are extensions. To get breakpoints and the debugger to work as you'd expect them to:

- Go up to the top bar where your schemes are (this is a bit to the right of the run button) and change it from Scribe to the language of the keyboard you'd like to debug [(see a screenshot of this)](https://raw.githubusercontent.com/scribe-org/Scribe-iOS/main/.github/resources/images/select_scheme_for_debugging.png)
- Choose a device as normal
- Hit the run button (or ⌘-R) to start the active scheme
- When you get a window telling you to "choose an app to run", don't choose Scribe as you might expect, but instead scroll down and select Xcode Previews
- Occasionally you'll be met with just a black screen on startup, in which case you can press Home (or ⇧-⌘-H) and then go directly to Scribe or an app for keyboard testing

<a id="issues-projects"></a>

# Issues and projects [`⇧`](#contents)

The [issue tracker for Scribe-iOS](https://github.com/scribe-org/Scribe-iOS/issues) is the preferred channel for [bug reports](#bug-reports), [features requests](#feature-requests) and [submitting pull requests](#pull-requests). Scribe also organizes related issues into [projects](https://github.com/scribe-org/Scribe-iOS/projects).

Be sure to check the [`-next release-`](https://github.com/scribe-org/Scribe-iOS/labels/-next%20release-) and [`-priority-`](https://github.com/scribe-org/Scribe-iOS/labels/-priority-) labels in the [issues](https://github.com/scribe-org/Scribe-iOS/issues) for those that are most important, as well as those marked [`good first issue`](https://github.com/scribe-org/Scribe-iOS/issues?q=is%3Aissue+is%3Aopen+label%3A%22good+first+issue%22) that are tailored for first time contributors.

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

To make the above steps easier, the Scribe team asks that contributors report bugs using the [bug report](https://github.com/scribe-org/Scribe-iOS/issues/new?assignees=&labels=feature&template=bug_report.yml) template, with these issues further being marked with the [`bug`](https://github.com/scribe-org/Scribe-iOS/issues?q=is%3Aopen+is%3Aissue+label%3Abug) label.

Again, thank you for your time in reporting issues!

<a id="feature-requests"></a>

# Feature requests [`⇧`](#contents)

Feature requests are more than welcome! Please take a moment to find out whether your idea fits with the scope and aims of the project. When making a suggestion, provide as much detail and context as possible, and further make clear the degree to which you would like to contribute in its development. Feature requests are marked with the [`feature`](https://github.com/scribe-org/Scribe-iOS/issues?q=is%3Aopen+is%3Aissue+label%3Afeature) label, and can be made using the [feature request](https://github.com/scribe-org/Scribe-iOS/issues/new?assignees=&labels=feature&template=feature_request.yml) template.

<a id="pull-requests"></a>

# Pull requests [`⇧`](#contents)

Good pull requests - patches, improvements and new features - are a fantastic help. They should remain focused in scope and avoid containing unrelated commits. Note that all contributions to this project will be made under [the specified license](https://github.com/scribe-org/Scribe-iOS/blob/main/LICENSE.txt) and should follow the coding indentation and style standards (contact us if unsure).

**Please ask first** before embarking on any significant pull request (implementing features, refactoring code, etc), otherwise you risk spending a lot of time working on something that the developers might not want to merge into the project. With that being said, major additions are very appreciated!

When making a contribution, adhering to the [GitHub flow](https://guides.github.com/introduction/flow/index.html) process is the best way to get your work merged:

1. [Fork](http://help.github.com/fork-a-repo/) the repo, clone your fork, and configure the remotes:

   ```bash
   # Clone your fork of the repo into the current directory
   git clone https://github.com/<your-username>/<repo-name>
   # Navigate to the newly cloned directory
   cd <repo-name>
   # Assign the original repo to a remote called "upstream"
   git remote add upstream https://github.com/<upsteam-owner>/<repo-name>
   ```

2. If you cloned a while ago, get the latest changes from upstream:

   ```bash
   git checkout <dev-branch>
   git pull upstream <dev-branch>
   ```

3. Create a new topic branch (off the main project development branch) to contain your feature, change, or fix:

   ```bash
   git checkout -b <topic-branch-name>
   ```

4. Commit your changes in logical chunks, and please try to adhere to [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/). Use Git's [interactive rebase](https://docs.github.com/en/github/getting-started-with-github/about-git-rebase) feature to tidy up your commits before making them public.

5. Locally merge (or rebase) the upstream development branch into your topic branch:

   ```bash
   git pull --rebase upstream <dev-branch>
   ```

6. Push your topic branch up to your fork:

   ```bash
   git push origin <topic-branch-name>
   ```

7. [Open a Pull Request](https://help.github.com/articles/using-pull-requests/) with a clear title and description.

Thank you in advance for your contributions!

<a id="data-edits"></a>

# Data edits [`⇧`](#contents)

Scribe does not accept direct edits to the grammar JSON files as they are sourced from [Wikidata](https://www.wikidata.org/). Edits can be discussed and the [Scribe-Data](https://github.com/scribe-org/Scribe-Data) queries will be changed and ran before an update. If there is a problem with one of the files, then the fix should be made on [Wikidata](https://www.wikidata.org/) and not on Scribe. Feel free to let us know that edits have been made by [opening a data issue](https://github.com/scribe-org/Scribe-iOS/issues/new?assignees=&labels=data&template=data_wikidata.yml) or contacting us in the [issues for Scribe-Data](https://github.com/scribe-org/Scribe-Data/issues) and we'll be happy to integrate them!

<a id="localization"></a>

# Localization [`⇧`](#contents)

Being an app that focusses on language learning, localization plays a big part in what Scribe will eventually be. Those interested in contributing to localization for the app are welcome to check related issues using the [`localization`](https://github.com/scribe-org/Scribe-iOS/issues?q=is%3Aopen+is%3Aissue+label%3Alocalization) label, and are further welcome to open their own issues using the [localization](https://github.com/scribe-org/Scribe-iOS/issues/new?assignees=&labels=design&template=localization.yml) template!

<a id="documentation"></a>

# Documentation [`⇧`](#contents)

Documentation is an invaluable way to contribute to coding projects as it allows others to more easily understand the project structure and contribute. Issues related to documentation are marked with the [`documentation`](https://github.com/scribe-org/Scribe-iOS/labels/documentation) label.

<a id="design"></a>

# Design [`⇧`](#contents)

<a href="https://www.figma.com/file/c8945w2iyoPYVhsqW7vRn6/scribe_public_designs?node-id=405%3A464"><img src="https://raw.githubusercontent.com/scribe-org/Organization/main/resources/images/figma_logo.png" height="50" alt="Public Figma Designs" align="right"></a>

Designs for Scribe are done in the [public design file in Figma](https://www.figma.com/file/c8945w2iyoPYVhsqW7vRn6/scribe_public_designs?node-id=405%3A464). Those interested in helping with Scribe's design are also welcome to share their ideas using the [design improvement](https://github.com/scribe-org/Scribe-iOS/issues/new?assignees=&labels=design&template=design_improvement.yml) template that makes an issue marked with the [`design`](https://github.com/scribe-org/Scribe-iOS/issues?q=is%3Aopen+is%3Aissue+label%3Adesign) label.

All branding elements such as logos, icons, colors and fonts should follow those that are set out in [scribe-org/Organization](https://github.com/scribe-org/Organization). As the project is fully open source, these elements are also open for discussion. Efforts in making Scribe products professional with a distinct and cohesive identity are much appreciated!
