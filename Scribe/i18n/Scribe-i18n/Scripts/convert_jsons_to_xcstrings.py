"""
Converts from Scribe-i18n localization JSON files to the Localizable.xcstrings file.


Usage:
    python3 Scribe-i18n/Scripts/convert_jsons_to_xcstrings.py
"""

import json
import os

directory = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
files = os.listdir(directory)
languages = sorted(
    [file.replace(".json", "") for file in files if file.endswith(".json")]
)
path = os.path.join(directory, "en-US.json")
file = open(path, "r").read()
file = json.loads(file)

data = "{\n" '  "sourceLanguage" : "en",\n' '  "strings" : {\n'
for pos, key in enumerate(file, start=1):
    data += (
        f'    "{key}" : {{\n' f'      "comment" : "",\n' f'      "localizations" : {{\n'
    )

    for lang in languages:
        lang_json = json.loads(
            open(os.path.join(directory, f"{lang}.json"), "r").read()
        )

        if key in lang_json:
            translation = lang_json[key].replace('"', '\\"').replace("\n", "\\n")
        else:
            translation = ""

        if lang == "en-US":
            lang = "en"
        if translation != "":
            data += (
                f'        "{lang}" : {{\n'
                f'          "stringUnit" : {{\n'
                f'            "state" : "",\n'
                f'            "value" : "{translation}"\n'
                f"          }}\n"
                f"        }},\n"
            )

    data = data[:-2]
    data += "\n      }\n" "    },\n" if pos < len(file) else "      }\n" "    }\n"

data += "  },\n" '  "version" : "1.0"\n' "}"
open(os.path.join(directory, "Localizable.xcstrings"), "w").write(data)

print(
    "Scribe-i18n localization JSON files successfully converted to the Localizable.xcstrings file."
)
