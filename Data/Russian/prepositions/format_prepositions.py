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
    elif case == "dative":
        return "Dat"
    elif case == "genitive":
        return "Gen"
    elif case == "instrumental":
        return "Ins"
    elif case == "prepositional":
        return "Pre"
    elif case == "locative":
        return "Loc"
    elif case == "nominative":
        return "Nom"
    else:
        return ""


def order_annotations(annotation):
    """
    Standardizes the annotations that are presented to users where more than one is applicable.

    Parameters
    ----------
        annotation : str
            The annotation to be returned to the user in the preview bar.
    """
    single_annotations = ["Akk", "Dat", "Gen", "Ins", "Pre", "Loc", "Nom"]
    if annotation in single_annotations:
        return annotation

    annotation_split = sorted(annotation.split("/"))

    return "/".join(annotation_split)


prepositions_formatted = {}

for prep_vals in prepositions_list:
    if "preposition" in prep_vals.keys() and "case" in prep_vals.keys():
        if prep_vals["preposition"] not in prepositions_formatted:
            prepositions_formatted[prep_vals["preposition"]] = convert_cases(
                prep_vals["case"]
            )

        else:
            prepositions_formatted[prep_vals["preposition"]] += "/" + convert_cases(
                prep_vals["case"]
            )

for k in prepositions_formatted:
    prepositions_formatted[k] = order_annotations(prepositions_formatted[k])

prepositions_formatted = collections.OrderedDict(sorted(prepositions_formatted.items()))

with open(
    "../../../Keyboards/LanguageKeyboards/Russian/Data/prepositions.json",
    "w",
    encoding="utf-8",
) as f:
    json.dump(prepositions_formatted, f, ensure_ascii=False, indent=2)

print(f"Wrote file prepositions.json with {len(prepositions_formatted)} prepositions.")
