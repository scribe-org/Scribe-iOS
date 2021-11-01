"""
Format Translations
-------------------

Formats the translations queried from Wikidata using queryTranslations.sparql.
"""

import json

with open("translationsQueried.json") as f:
    translations_list = json.load(f)

translations_formatted = {}

for translation_vals in translations_list:
    translations_formatted = {translation_vals}

with open("../../translations.json", "w", encoding="utf-8") as f:
    json.dump(translations_formatted, f, ensure_ascii=False, indent=2)

print(f"Wrote file translations.json with {len(translations_formatted)} nouns.")
