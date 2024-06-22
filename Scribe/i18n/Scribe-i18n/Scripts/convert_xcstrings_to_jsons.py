"""
Converts from the Scribe-i18n Localizable.xcstrings file to localization JSON files.

Usage:
    python3 Scribe-i18n/Scripts/convert_xcstrings_to_jsons.py
"""

import json
import os

directory = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
file = open(os.path.join(directory, "Localizable.xcstrings"), "r").read()
files = os.listdir(directory)

languages = [file.replace(".json", "") for file in files if file.endswith(".json")]

for lang in languages:
    dest = open(f"{directory}/{lang}.json", "w")
    if lang == "en-US":
        lang = "en"

    json_file = json.loads(file)
    strings = json_file["strings"]

    data = "{\n"
    for pos, key in enumerate(strings, start=1):
        translation = ""
        if (
            lang in json_file["strings"][key]["localizations"]
            and json_file["strings"][key]["localizations"][lang]["stringUnit"]["value"]
            != ""
            and json_file["strings"][key]["localizations"][lang]["stringUnit"]["value"]
            != key
        ):
            translation = (
                json_file["strings"][key]["localizations"][lang]["stringUnit"]["value"]
                .replace('"', '\\"')
                .replace("\n", "\\n")
            )

        data += f'  "{key}" : "{translation}"'
        data += ",\n" if pos < len(json_file["strings"]) else "\n"

    data += "}\n"

    dest.write(data)

print(
    "Scribe-i18n Localizable.xcstrings file successfully converted to the localization JSON files."
)
