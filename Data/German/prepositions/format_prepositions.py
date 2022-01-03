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


def order_annotations(annotation):
    """
    Standardizes the annotations that are presented to users where more than one is applicable.

    Parameters
    ----------
        annotation : str
            The annotation to be returned to the user in the preview bar.
    """
    single_annotations = ["Akk", "Dat", "Gen"]
    if annotation in single_annotations:
        return annotation

    annotation_split = sorted(annotation.split("/"))

    return "/".join(annotation_split)


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

        elif (
            "case" not in prep_vals.keys() and prep_vals["preposition"] != "a"
        ):  # à is the correct preposition
            prepositions_formatted[prep_vals["preposition"]] = ""

for k in prepositions_formatted:
    prepositions_formatted[k] = order_annotations(prepositions_formatted[k])

prepositions_formatted = collections.OrderedDict(sorted(prepositions_formatted.items()))

with open(
    "../../../Keyboards/LanguageKeyboards/German/Data/prepositions.json",
    "w",
    encoding="utf-8",
) as f:
    json.dump(prepositions_formatted, f, ensure_ascii=False, indent=2)

print(f"Wrote file prepositions.json with {len(prepositions_formatted)} prepositions.")
