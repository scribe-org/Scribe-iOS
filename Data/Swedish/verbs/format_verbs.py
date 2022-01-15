"""
Format Verbs
------------

Formats the verbs queried from Wikidata using queryVerbs.sparql.
"""

import collections
import json
import sys

file_path = sys.argv[0]
if "Swedish/verbs/" not in file_path:
    with open("verbsQueried.json") as f:
        verbs_list = json.load(f)
else:  # is being called by update_data.py
    with open("./Swedish/verbs/verbsQueried.json") as f:
        verbs_list = json.load(f)

verbs_formatted = {}

# Currently there is a large problem with Swedish verbs not have needed features
# See: https://www.wikidata.org/wiki/Lexeme:L38389
# Any verbs occuring more than once will for now be deleted
verbs_not_included = []

all_keys = [
    "activeInfinitive",
    "imperative",
    "activeSupine",
    "activePresent",
    "activePreterite",
    "passiveInfinitive",
    "passiveSupine",
    "passivePresent",
    "passivePreterite",
]

for verb_vals in verbs_list:
    if (
        verb_vals["activeInfinitive"] not in verbs_formatted.keys()
        and verb_vals["activeInfinitive"] not in verbs_not_included
    ):
        verbs_formatted[verb_vals["activeInfinitive"]] = {
            conj: verb_vals[conj] if conj in verb_vals.keys() else ""
            for conj in [c for c in all_keys if c != "activeInfinitive"]
        }

    elif verb_vals["activeInfinitive"] in verbs_formatted:
        verbs_not_included.append(verb_vals["activeInfinitive"])
        del verbs_formatted[verb_vals["activeInfinitive"]]

verbs_formatted = collections.OrderedDict(sorted(verbs_formatted.items()))

if "Swedish/verbs/" not in file_path:
    with open(
        "../../../Keyboards/LanguageKeyboards/Swedish/Data/verbs.json",
        "w",
        encoding="utf-8",
    ) as f:
        json.dump(verbs_formatted, f, ensure_ascii=False, indent=2)
else:  # is being called by update_data.py
    with open(
        "../Keyboards/LanguageKeyboards/Swedish/Data/verbs.json", "w", encoding="utf-8",
    ) as f:
        json.dump(verbs_formatted, f, ensure_ascii=False, indent=2)

print(f"Wrote file verbs.json with {len(verbs_formatted)} verbs.")
