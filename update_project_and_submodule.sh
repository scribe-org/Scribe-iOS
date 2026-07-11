# Run this script to pull the most recent changes to the project including Scribe-i18n keys.
# macOS: ./update_project_and_submodule.sh
# Linux: ./update_project_and_submodule.sh
# Windows: Run the command below.
git pull origin main
git submodule update --init --recursive
