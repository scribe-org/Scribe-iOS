"""
Format Verbs
------------

Formats the verbs queried from Wikidata using queryVerbs.sparql.
"""

import collections
import json
import sys

file_path = sys.argv[0]
if "Portuguese/verbs/" not in file_path:
    with open("verbsQueried.json") as f:
        verbs_list = json.load(f)
else:  # is being called by update_data.py
    with open("./Portuguese/verbs/verbsQueried.json") as f:
        verbs_list = json.load(f)

verbs_formatted = {}

all_keys = [
    "infinitive",
    "indicativePresentFPS",
    "indicativePresentSPS",
    "indicativePresentTPS",
    "indicativePresentFPP",
    "indicativePresentSPP",
    "indicativePresentTPP",
    "pastPerfectFPS",
    "pastPerfectSPS",
    "pastPerfectTPS",
    "pastPerfectFPP",
    "pastPerfectSPP",
    "pastPerfectTPP",
    "pastImperfectFPS",
    "pastImperfectSPS",
    "pastImperfectTPS",
    "pastImperfectFPP",
    "pastImperfectSPP",
    "pastImperfectTPP",
    "futureSimpleFPS",
    "futureSimpleSPS",
    "futureSimpleTPS",
    "futureSimpleFPP",
    "futureSimpleSPP",
    "futureSimpleTPP",
]

for verb_vals in verbs_list:
    verbs_formatted[verb_vals["infinitive"]] = {}

    for conj in [c for c in all_keys if c != "infinitive"]:
        if conj in verb_vals.keys():
            verbs_formatted[verb_vals["infinitive"]][conj] = verb_vals[conj]
        else:
            verbs_formatted[verb_vals["infinitive"]][conj] = ""

verbs_formatted = collections.OrderedDict(sorted(verbs_formatted.items()))

if "Portuguese/verbs/" not in file_path:
    with open(
        "../../../Keyboards/LanguageKeyboards/Portuguese/Data/verbs.json",
        "w",
        encoding="utf-8",
    ) as f:
        json.dump(verbs_formatted, f, ensure_ascii=False, indent=2)
else:  # is being called by update_data.py
    with open(
        "../Keyboards/LanguageKeyboards/Portuguese/Data/verbs.json",
        "w",
        encoding="utf-8",
    ) as f:
        json.dump(verbs_formatted, f, ensure_ascii=False, indent=2)

print(f"Wrote file verbs.json with {len(verbs_formatted)} verbs.")
