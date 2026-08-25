# Conjugate-iOS Changelog

> [!NOTE]
> This repository contains the code for two different applications: Scribe-iOS and Conjugate-iOS (Scribe-Conjugate for iOS). This is the changelog for Conjugate-iOS. See [CHANGELOG.md](/CHANGELOG.md) for the Scribe-iOS changelog.

See the [releases for this repository](https://github.com/scribe-org/Scribe-iOS/releases) for an up to date list of versions and their release dates. Versions that are marked as released may not yet be on the App Store and other stores if it's within the submission review period.

Conjugate-iOS tries to follow [semantic versioning](https://semver.org/), a MAJOR.MINOR.PATCH version where increments are made of the:

- MAJOR version when we make incompatible API changes
- MINOR version when we add functionality in a backwards compatible manner
- PATCH version when we make backwards compatible bug fixes

Emojis for the following are chosen based on [gitmoji](https://gitmoji.dev/).

## [Upcoming] Conjugate-iOS 1.0.0

### MVP release of Scribe Conjugate on iOS

### 🚀 Deployment

- Releasing for iPhone and iPad.

### ✨ New Features

- A verb Conjugation tab was added to the application.
- Users can search for verbs across languages.
- A reactive conjugation selection UI was developed to easily copy desired conjugations.
- Users are able to filter verb conjugations by tense.
- Recently conjugated verbs are displayed to the user in the Conjugation tab.
- The Settings tab for the Scribe keyboard application was migrated to allow base settings for the app interface.
- The About tab for the Scribe keyboard application was migrated to provide information on the application and community.
- The application and community's relationship to the Wikimedia movement is explained in app.

### 🗃️ Data

- SQLite databases have been set up for all data needed for the conjugate UI.
- Calls are made to the [Scribe-Server API](https://scribe-server.toolforge.org/) hosted on Toolforge to download language data and insert it into SQLite tables.
- The data download UI was created to download data for any keyboards that have been installed.
- Network indicators for data request have been added to the application and are shown via toasts.

### 🎨 Design

- Dark mode compatibility through a responsive color scheme.
- The application menu follows modern iOS styling.

### 🌐 Localization

- The application has been localized into many languages using [Weblate](https://weblate.org/en/) and the [Scribe-i18n](https://github.com/scribe-org/Scribe-i18n) project as a central Git submodule of localizations.

### ✅ Tests

- Tests

### 📝 Documentation

- Functions in the application have been documented.

### ⚖️ Legal

- All code has been developed under the GNU General Public License (GPL-3.0).
- A privacy policy was provided to make clear that policies around user data and their security.
- Third party licensed code used in the development of the project were detailed.
