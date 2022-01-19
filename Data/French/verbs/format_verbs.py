"""
Format Verbs
------------

Formats the verbs queried from Wikidata using queryVerbs.sparql.
"""

import collections
import json
import sys

file_path = sys.argv[0]
if "French/verbs/" not in file_path:
    with open("verbsQueried.json") as f:
        verbs_list = json.load(f)
else:  # is being called by update_data.py
    with open("./French/verbs/verbsQueried.json") as f:
        verbs_list = json.load(f)

verbs_formatted = {}

all_keys = [
    "infinitive",
    "presFPS",
    "presSPS",
    "presTPS",
    "presFPP",
    "presSPP",
    "presTPP",
    "pretFPS",
    "pretSPS",
    "pretTPS",
    "pretFPP",
    "pretSPP",
    "pretTPP",
    "impFPS",
    "impSPS",
    "impTPS",
    "impFPP",
    "impSPP",
    "impTPP",
]

for verb_vals in verbs_list:
    verbs_formatted[verb_vals["infinitive"]] = {}

    for conj in [c for c in all_keys if c != "infinitive"]:
        if conj in verb_vals.keys():
            verbs_formatted[verb_vals["infinitive"]][conj] = verb_vals[conj]
        else:
            verbs_formatted[verb_vals["infinitive"]][conj] = ""

verbs_formatted = collections.OrderedDict(sorted(verbs_formatted.items()))

if "French/verbs/" not in file_path:
    with open(
        "../../../Keyboards/LanguageKeyboards/French/Data/verbs.json",
        "w",
        encoding="utf-8",
    ) as f:
        json.dump(verbs_formatted, f, ensure_ascii=False, indent=2)
else:  # is being called by update_data.py
    with open(
        "../Keyboards/LanguageKeyboards/French/Data/verbs.json", "w", encoding="utf-8",
    ) as f:
        json.dump(verbs_formatted, f, ensure_ascii=False, indent=2)

print(f"Wrote file verbs.json with {len(verbs_formatted)} verbs.")
