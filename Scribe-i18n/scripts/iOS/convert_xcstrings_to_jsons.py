# SPDX-License-Identifier: GPL-3.0-or-later
"""
Converts from the Scribe-i18n Localizable.xcstrings file to localization JSON files.

Usage:
    python3 Scribe-i18n/scripts/ios/convert_xcstrings_to_jsons.py
"""


import json
import os

directory = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

# Ensure the "jsons" folder exists inside the directory.
jsons_folder = os.path.join(directory, "jsons")
if not os.path.exists(jsons_folder):
    os.makedirs(jsons_folder)

# Read the Localizable.xcstrings file.
try:
    with open(os.path.join(directory, "Localizable.xcstrings"), "r") as f:
        file = f.read()

except FileNotFoundError:
    print("Error: Localizable.xcstrings file not found.")
    exit(1)

dir_list = os.listdir(jsons_folder)
languages = [file.replace(".json", "") for file in dir_list if file.endswith(".json")]

for lang in languages:
    lang = "en" if lang == "en-US" else lang

    # Attempt to load the JSON data.
    try:
        json_file = json.loads(file)

    except json.JSONDecodeError:
        print("Error: The Localizable.xcstrings file is not valid JSON.")
        exit(1)

    strings = json_file["strings"]

    data = {}
    for pos, key in enumerate(strings, start=1):
        translation = ""
        if (
            lang in json_file["strings"][key]["localizations"]
            and json_file["strings"][key]["localizations"][lang]["stringUnit"]["value"]
            != ""
            and json_file["strings"][key]["localizations"][lang]["stringUnit"]["value"]
            != key
        ):
            translation = json_file["strings"][key]["localizations"][lang][
                "stringUnit"
            ]["value"]

        data[key] = translation

    lang = "en-US" if lang == "en" else lang

    with open(f"{jsons_folder}/{lang}.json", "w") as dest:
        json.dump(data, dest, indent=2, ensure_ascii=False)
        dest.write("\n")

print(
    "Scribe-i18n Localizable.xcstrings file successfully converted to the localization JSON files."
)
