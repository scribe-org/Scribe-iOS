"""
Format Prepositions
-------------------

Formats the prepositions queried from Wikidata using queryPrepositions.sparql.
"""

import collections
import json

with open("prepositionsQueried.json") as f:
    prepositions_list = json.load(f)


def convert_cases(case):
    """
    Converts cases as found on Wikidata to more succinct versions.
    """
    case = case.split(" case")[0]
    if case == "accusative":
        return "Akk"
    if case == "dative":
        return "Dat"
    if case == "genitive":
        return "Gen"


prepositions_formatted = {}

for prep_vals in prepositions_list:
    if "preposition" in prep_vals.keys():
        if "case" in prep_vals.keys():
            if prep_vals["preposition"] not in prepositions_formatted:
                prepositions_formatted[prep_vals["preposition"]] = convert_cases(
                    prep_vals["case"]
                )

            else:
                prepositions_formatted[prep_vals["preposition"]] += "/" + convert_cases(
                    prep_vals["case"]
                )

        elif "case" not in prep_vals.keys():
            prepositions_formatted[prep_vals["preposition"]] = ""

prepositions_formatted = collections.OrderedDict(sorted(prepositions_formatted.items()))

with open(
    "../../../Keyboards/LanguageKeyboards/German/Data/prepositions.json",
    "w",
    encoding="utf-8",
) as f:
    json.dump(prepositions_formatted, f, ensure_ascii=False, indent=2)

print(f"Wrote file prepositions.json with {len(prepositions_formatted)} prepositions.")
