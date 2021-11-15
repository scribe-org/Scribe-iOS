"""
Format Translations
-------------------

Formats the translations queried from Wikidata using queryTranslations.sparql.

Note: first go into translationsQueried.json and do a find and replace of:
<"verb", "word": "> with <"verb", "word": "to > to differentiate verbs.
"""

import json

from tqdm.auto import tqdm
from transformers import MarianMTModel, MarianTokenizer

with open("translationsQueried.json") as f:
    translations_list = json.load(f)

words = [translation_vals["word"] for translation_vals in translations_list]
words = list(set(words))

translations_formatted = {}

MODEL_NAME = "Helsinki-NLP/opus-mt-en-roa"
tokenizer = MarianTokenizer.from_pretrained(MODEL_NAME)
model = MarianMTModel.from_pretrained(MODEL_NAME)

for w in tqdm(words, desc="Words translated", unit="word",):
    translated = model.generate(
        **tokenizer(">>esp<< " + w, return_tensors="pt", padding=True)
    )
    translations_formatted[w] = tokenizer.decode(
        translated[0], skip_special_tokens=True
    )

with open(
    "../../../../Keyboards/LanguageKeyboards/Spanish/Data/translations.json",
    "w",
    encoding="utf-8",
) as f:
    json.dump(translations_formatted, f, ensure_ascii=False, indent=2)

print(f"Wrote file translations.json with {len(translations_formatted)} translations.")
