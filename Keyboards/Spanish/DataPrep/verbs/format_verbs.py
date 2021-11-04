"""
Format Verbs
------------

Formats the verbs queried from Wikidata using queryVerbs.sparql.
"""


import json

with open("verbsQueried.json") as f:
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
    "preteriteFPS",
    "preteriteSPS",
    "preteriteTPS",
    "preteriteFPP",
    "preteriteSPP",
    "preteriteTPP",
    "pastPerfectFPS",
    "pastPerfectSPS",
    "pastPerfectTPS",
    "pastPerfectFPP",
    "pastPerfectSPP",
    "pastPerfectTPP",
]

for verb_vals in verbs_list:
    verbs_formatted[verb_vals["infinitive"]] = {}

    for conj in [c for c in all_keys if c != "infinitive"]:
        if conj in verb_vals.keys():
            verbs_formatted[verb_vals["infinitive"]][conj] = verb_vals[conj]
        else:
            verbs_formatted[verb_vals["infinitive"]][conj] = ""

with open("../../verbs.json", "w", encoding="utf-8") as f:
    json.dump(verbs_formatted, f, ensure_ascii=False, indent=2)

print(f"Wrote file verbs.json with {len(verbs_formatted)} verbs.")
