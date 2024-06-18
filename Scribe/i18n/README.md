<div align="center">
  <a href="https://github.com/scribe-org/Scribe-i18n"><img src="https://raw.githubusercontent.com/scribe-org/Organization/main/logo/ScribeGitHubOrgBanner.png" width=1024 alt="Scribe Logo"></a>
</div>

[![weblate](https://img.shields.io/badge/Weblate-144D3F.svg?logo=weblate&logoColor=ffffff)](https://hosted.weblate.org/projects/scribe/scribe-i18n)
[![issues](https://img.shields.io/github/issues/scribe-org/Scribe-i18n?label=%20&logo=github)](https://github.com/scribe-org/Scribe-i18n/issues)
[![license](https://img.shields.io/github/license/scribe-org/Scribe-i18n.svg?label=%20)](https://github.com/scribe-org/Scribe-i18n/blob/main/LICENSE.txt)
[![coc](https://img.shields.io/badge/Contributor%20Covenant-ff69b4.svg)](https://github.com/scribe-org/Scribe-i18n/blob/main/.github/CODE_OF_CONDUCT.md)
[![mastodon](https://img.shields.io/badge/Mastodon-6364FF.svg?logo=mastodon&logoColor=ffffff)](https://wikis.world/@scribe)
[![matrix](https://img.shields.io/badge/Matrix-000000.svg?logo=matrix&logoColor=ffffff)](https://matrix.to/#/#scribe_community:matrix.org)

## Application text localization files for Scribe apps

**Scribe-i18n** is the home of the localization files that are included in each Scribe application. Scribe uses [Weblate](https://weblate.org/en/) for localization! Head over to [weblate.org/projects/scribe/scribe-i18n](https://hosted.weblate.org/projects/scribe/scribe-i18n) to localize the applications. Changes in this directory will be merged into other Scribe applications via this repo being a [Git subtree](https://docs.github.com/en/get-started/using-git/about-git-subtree-merges).

> [!NOTE]\
> The [contributing](#contributing) section has information for those interested.

Scribe apps are available on [iOS](https://github.com/scribe-org/Scribe-iOS), [Android](https://github.com/scribe-org/Scribe-Android) (planned) and [Desktop](https://github.com/scribe-org/Scribe-Desktop) (planned). For the data formatting processes see [Scribe-Data](https://github.com/scribe-org/Scribe-Data) and for our data download API see [Scribe-Server](https://github.com/scribe-org/Scribe-Data).

Check out Scribe's [architecture diagrams](https://github.com/scribe-org/Organization/blob/main/ARCHITECTURE.md) for an overview of the organization including our applications, services and processes. It depicts the projects that [Scribe](https://github.com/scribe-org) is developing as well as the relationships between them and the external systems with which they interact.

<a id="contents"></a>

# **Contents**

- [Localization Coverage](#localization-coverage)
- [Contributing](#contributing)
- [Community](#community)

<a id="localization-coverage"></a>

# Localization Coverage [`⇧`](#contents)

<a href="https://hosted.weblate.org/projects/scribe/scribe-i18n">
    <img src="https://hosted.weblate.org/widget/scribe/scribe-i18n/multi-auto.svg" alt="Translation status" />
</a>

<a id="contributing"></a>

# Contributing [`⇧`](#contents)

Thank you for your interest in contributing to Scribe-i18n! We look forward to welcoming you to the community and working with you to build an tools for language learners to communicate effectively :) The following are some suggested steps for people interested in joining our community.

Following these guidelines helps to communicate that you respect the time of the developers managing and developing this open-source project. In return, and in accordance with this project's [code of conduct](https://github.com/scribe-org/Scribe-i18n/blob/main/.github/CODE_OF_CONDUCT.md), other contributors will reciprocate that respect in addressing your issue or assessing changes and features.

<a href="https://matrix.to/#/#scribe_community:matrix.org"><img src="https://raw.githubusercontent.com/scribe-org/Organization/main/resources/images/logos/MatrixLogoGrey.png" height="50" alt="Public Matrix Chat" align="right"></a>

If you have questions or would like to communicate with the team, please [join us in our public Matrix chat rooms](https://matrix.to/#/#scribe_community:matrix.org). Scribe would suggest that you use the [Element](https://element.io/) client. We'd be happy to hear from you!

### Issues [`⇧`](#contents)

The [issue tracker for Scribe-i18n](https://github.com/scribe-org/Scribe-i18n/issues) is the preferred channel to let the team know if there are problems with localizations or to ask to work on new ones. Those interested in helping can check the [`-next release-`](https://github.com/scribe-org/Scribe-i18n/labels/-next%20release-) and [`-priority-`](https://github.com/scribe-org/Scribe-i18n/labels/-priority-) labels in the [issues](https://github.com/scribe-org/Scribe-i18n/issues) for those that are most important, as well as those marked [`good first issue`](https://github.com/scribe-org/Scribe-i18n/issues?q=is%3Aissue+is%3Aopen+label%3A%22good+first+issue%22) that are tailored for first time contributors. Generally issues in this repository will be marked with the [`localization`](https://github.com/scribe-org/Scribe-i18n/issues?q=is%3Aopen+is%3Aissue+label%3Alocalization) label.

### Localizing via Weblate [`⇧`](#contents)

<a href="https://hosted.weblate.org/projects/scribe/scribe-i18n"><img src="https://raw.githubusercontent.com/scribe-org/Organization/main/resources/images/logos/WeblateLogo.png" height="100" alt="Visit Weblate project" align="right"></a>

[Weblate](https://weblate.org/en/) localization is as easy as making an account and jumping into the Scribe-i18n project!

1. First [register at Weblate](https://hosted.weblate.org/accounts/register/) (you can also authenticate with GitHub or other accounts)

   - We suggest that you do link your GitHub account so you get credit for the localization commits!

2. Navigate to the Scribe-i18n project at [weblate.org/projects/scribe/scribe-i18n](https://hosted.weblate.org/projects/scribe/scribe-i18n)

3. Click on a language you want to start translating

4. You can browse the available strings or start translating directly

   - When translating a word, be sure to check the glossary context if you're not sure what the string's use is

   - You can also make use of Automatic suggestions to see machine translations if you need help

5. Hit `Save and continue` when you're ready to move to the next string

6. Maintainers will open up pull requests from [Weblate](https://weblate.org/en/) to this repo

7. Scribe-i18n directories that are [Git subtrees](https://docs.github.com/en/get-started/using-git/about-git-subtree-merges) in other Scribe application repos are then synched

### Adding source strings [`⇧`](#contents)

The base language for all Scribe applications is US English. If you'd like to edit the [en-US.json](https://github.com/scribe-org/Scribe-i18n/blob/main/Scribe-i18n/en-US.json) file, please [fork](https://docs.github.com/en/get-started/quickstart/fork-a-repo) the repo, clone your fork, and configure the remotes:

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
> - e.g. Cloning now becomes `git clone git@github.com:<your-username>/Scribe-i18n.git`
>
> GitHub also has their documentation on how to [Generate a new SSH key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) 🔑
>
> </p>
> </details>

```bash
# Clone your fork of the repo into the current directory.
git clone https://github.com/<your-username>/Scribe-i18n.git
# Navigate to the newly cloned directory.
cd Scribe-i18n
# Assign the original repo to a remote called "upstream".
git remote add upstream https://github.com/scribe-org/Scribe-i18n.git
```

- Now, if you run `git remote -v` you should see two remote repositories named:
  - `origin` (forked repository)
  - `upstream` (Scribe-i18n repository)

If all looks good, then you're ready to start adding localizable key-string pairs via pull requests!

### Pull Requests [`⇧`](#contents)

Good pull requests are the foundation of our community making Scribe-i18n. They should remain focused in scope and avoid containing unrelated commits. Note that all contributions to this project will be made under [the specified license](https://github.com/scribe-org/Scribe-i18n/blob/main/LICENSE.txt).

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

<a id="community"></a>

# Community [`⇧`](#contents)

### Joining in [`⇧`](#contents)

After your first few pull requests organization members would be happy to discuss granting you further rights as a contributor, with a maintainer role then being possible after continued interest in the project. Scribe seeks to be an inclusive and supportive organization. We'd love to have you on the team!

### Road Map [`⇧`](#contents)

The Scribe road map can be followed in the organization's [project board](https://github.com/orgs/scribe-org/projects/1) where we list the most important issues along with their priority, status and an indication of which sub projects they're included in (if applicable).

> [!NOTE]\
> Consider joining our [bi-weekly developer syncs](https://etherpad.wikimedia.org/p/scribe-dev-sync)!

# Powered By [`⇧`](#contents)

### Contributors

Many thanks to all the [Scribe-i18n contributors](https://github.com/scribe-org/Scribe-i18n/graphs/contributors)! 🚀

<a href="https://github.com/scribe-org/Scribe-i18n/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=scribe-org/Scribe-i18n" />
</a>
