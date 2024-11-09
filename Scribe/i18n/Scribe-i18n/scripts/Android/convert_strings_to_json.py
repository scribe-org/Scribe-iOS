"""
Converts from string.xml files to Scribe-i18n localization JSON files.

Usage:
    python3 Scribe-i18n/scripts/android/convert_strings_to_json.py
"""

import os
import json
import re


def unescape_special_characters(string):
    """
    Replaces escaped special characters with those needed for JSON file formatting.
    """
    string = string.replace("&gt;", ">")
    string = string.replace("&lt;", "<")
    string = string.replace("&amp;", "&")
    string = string.replace("\\'", "'")
    string = string.replace("\\n", "\n")

    return string


directory = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

# Define the path to the "jsons" folder.
jsons_folder = os.path.join(directory, "jsons")

if not os.path.exists(jsons_folder):
    print(f"Error: The folder '{jsons_folder}' does not exist. Please ensure the path is correct.")
    exit(1)

dir_list = os.listdir(jsons_folder)
languages = sorted(
    [file.replace(".json", "") for file in dir_list if file.endswith(".json")]
)
regex = re.compile(r'<string name="(.*?)">(.*?)</string>', re.DOTALL)

values_directory = os.path.join(directory, "values")
if not os.path.exists(values_directory):
    print(f"Error: The folder '{values_directory}' does not exist. Please ensure the path is correct.")
    exit(1)

for lang in languages:
    path = os.path.join(values_directory, lang)
    try:
        with open(f"{path}/string.xml", "r") as file:
            content = file.read()

    except FileNotFoundError:
        print(f"Error: {path}/string.xml file not found.")
        exit(1)

    except Exception as e:
        print(f"Error: An unexpected error occurred while writing to ' {path}/string.xml: {e}")
        exit(1)

    matches = regex.findall(content)
    result = dict(matches)
    result = {key: unescape_special_characters(value) for key, value in result.items()}
    try:
        with open(
            os.path.join(jsons_folder, f"{lang}.json"),
            "w",
            encoding="utf-8",
        ) as file:
            json.dump(result, file, indent=2, ensure_ascii=False)
            file.write("\n")

    except FileNotFoundError:
        print(f"Error: The folder '{jsons_folder}' does not exist or cannot be accessed for writing.")
        exit(1)

    except Exception as e:
        print(f"Error: An unexpected error occurred while writing to '{jsons_folder}/{lang}.json: {e}")
        exit(1)

print(
    "Scribe-i18n localization strings files successfully converted to the JSON files."
)
