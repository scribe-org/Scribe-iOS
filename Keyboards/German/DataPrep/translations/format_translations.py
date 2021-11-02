"""
Format Translations
-------------------

Formats the translations queried from Wikidata using queryTranslations.sparql.

Note: first go into translationsQueried.json and do a find and replace of:
<"verb", "word": "> with <"verb", "word": "to > to differentiate verbs.
"""


import json

with open("translationsQueried.json") as f:
    translations_list = json.load(f)

words = [translation_vals["word"] for translation_vals in translations_list]
words = list(set(words))

# We want all the words to be separate corpuses.
words_to_translate = [[w] for w in words]

translations_formatted = {word: {"translation": ""} for word in words}

with open("../../translations.json", "w", encoding="utf-8") as f:
    json.dump(translations_formatted, f, ensure_ascii=False, indent=2)

print(f"Wrote file translations.json with {len(translations_formatted)} translations.")
