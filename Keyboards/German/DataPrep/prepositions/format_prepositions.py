"""
Format Prepositions
-------------------

Formats the prepositions queried from Wikidata using queryPrepositions.sparql.
"""


import json

with open("prepositionsQueried.json") as f:
    prepositions_list = json.load(f)


def convert_cases(case):
    if case == "accusative":
        return "Akkusativ"
    if case == "dative":
        return "Dativ"
    if case == "genitive":
        return "Genitiv"


prepositions_formatted = {}

for prep_vals in prepositions_list:
    if "preposition" in prep_vals.keys():
        if "case" in prep_vals.keys():
            if prep_vals["preposition"] not in prepositions_formatted:
                prepositions_formatted[prep_vals["preposition"]] = convert_cases(
                    prep_vals["case"].split(" case")[0]
                )

            else:
                prepositions_formatted[prep_vals["preposition"]] += "/" + convert_cases(
                    prep_vals["case"].split(" case")[0]
                )

        elif "case" not in prep_vals.keys():
            prepositions_formatted[prep_vals["preposition"]] = ""

with open("../../prepositions.json", "w", encoding="utf-8") as f:
    json.dump(prepositions_formatted, f, ensure_ascii=False, indent=2)

print(f"Wrote file prepositions.json with {len(prepositions_formatted)} prepositions.")
