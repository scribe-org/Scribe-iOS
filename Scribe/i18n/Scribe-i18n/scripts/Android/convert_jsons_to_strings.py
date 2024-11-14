"""
Converts from Scribe-i18n localization JSON files to string.xml files.

Usage:
    python3 Scribe-i18n/scripts/android/convert_jsons_to_strings.py
"""

import os
import json


def replace_special_characters(string):
    """
    Replaces special characters with those needed for XML file formatting.
    """
    string = string.replace("'", "\\'")
    string = string.replace("&", "&amp;")
    string = string.replace("<", "&lt;")
    string = string.replace(">", "&gt;")
    string = string.replace("\n", "\\n")

    return string


directory = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

# Define the path to the "jsons" folder.
jsons_folder = os.path.join(directory, "jsons")

if not os.path.exists(jsons_folder):
    print(f"Error: The folder '{jsons_folder}' does not exist. Please ensure the path is correct.")
    exit(1)

json_dir_list = os.listdir(jsons_folder)
languages = sorted(
    [file.replace(".json", "") for file in json_dir_list if file.endswith(".json")]
)
values_directory = os.path.join(directory, "values")
os.makedirs(values_directory, exist_ok=True)

# Pre-load all JSON files into a dictionary.
lang_data = {}
for lang in languages:
    with open(os.path.join(jsons_folder, f"{lang}.json"), "r") as lang_file:
        lang_data[lang] = json.load(lang_file)

# Write each language to its corresponding string.xml file.
for lang, translations in lang_data.items():
    # Define the directory for the current language.
    lang_dir = os.path.join(values_directory, lang)
    os.makedirs(lang_dir, exist_ok=True)

    # Create and write to the string.xml file.
    xml_path = os.path.join(lang_dir, "string.xml")
    with open(xml_path, "w") as xml_file:
        xml_file.write('<?xml version="1.0" encoding="utf-8"?>\n')
        xml_file.write("<resources>\n")

        # Write the string for each key in the language file.
        for key, value in translations.items():
            sanitized_value = replace_special_characters(value)
            xml_file.write(f'    <string name="{key}">{sanitized_value}</string>\n')

        xml_file.write("</resources>\n")

print("Scribe-i18n localization JSON files successfully converted to the strings file.")
