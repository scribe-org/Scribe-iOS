"""
Format Nouns
------------

Formats the nouns queried from Wikidata using queryNouns.sparql.
"""

import collections
import json
import sys

file_path = sys.argv[0]
if "Portuguese/nouns/" not in file_path:
    with open("nounsQueried.json") as f:
        nouns_list = json.load(f)
else:  # is being called by update_data.py
    with open("./Portuguese/nouns/nounsQueried.json") as f:
        nouns_list = json.load(f)


def map_genders(wikidata_gender):
    """
    Maps those genders from Wikidata to succinct versions.
    """
    if wikidata_gender in ["masculine", "Q499327"]:
        return "M"
    elif wikidata_gender in ["feminine", "Q1775415"]:
        return "F"
    else:
        return ""  # nouns could have a gender that is not valid as an attribute


def order_annotations(annotation):
    """
    Standardizes the annotations that are presented to users where more than one is applicable.

    Parameters
    ----------
        annotation : str
            The annotation to be returned to the user in the command bar.
    """
    single_annotations = ["F", "M", "PL"]
    if annotation in single_annotations:
        return annotation

    annotation_split = sorted([a for a in set(annotation.split("/")) if a != ""])

    return "/".join(annotation_split)


nouns_formatted = {}

for noun_vals in nouns_list:
    if "singular" in noun_vals.keys():
        if noun_vals["singular"] not in nouns_formatted:
            nouns_formatted[noun_vals["singular"]] = {"plural": "", "form": ""}

            if "gender" in noun_vals.keys():
                nouns_formatted[noun_vals["singular"]]["form"] = map_genders(
                    noun_vals["gender"]
                )

            if "plural" in noun_vals.keys():
                nouns_formatted[noun_vals["singular"]]["plural"] = noun_vals["plural"]

                if noun_vals["plural"] not in nouns_formatted:
                    nouns_formatted[noun_vals["plural"]] = {
                        "plural": "isPlural",
                        "form": "PL",
                    }

                # Plural is same as singular.
                else:
                    nouns_formatted[noun_vals["singular"]]["plural"] = noun_vals[
                        "plural"
                    ]
                    nouns_formatted[noun_vals["singular"]]["form"] = (
                        nouns_formatted[noun_vals["singular"]]["form"] + "/PL"
                    )

        else:
            if "gender" in noun_vals.keys():
                if (
                    nouns_formatted[noun_vals["singular"]]["form"]
                    != noun_vals["gender"]
                ):
                    nouns_formatted[noun_vals["singular"]]["form"] += "/" + map_genders(
                        noun_vals["gender"]
                    )

                elif nouns_formatted[noun_vals["singular"]]["gender"] == "":
                    nouns_formatted[noun_vals["singular"]]["gender"] = map_genders(
                        noun_vals["gender"]
                    )

    # Plural only noun.
    elif "plural" in noun_vals.keys():
        if noun_vals["plural"] not in nouns_formatted:
            nouns_formatted[noun_vals["plural"]] = {"plural": "isPlural", "form": "PL"}

        # Plural is same as singular.
        else:
            if "singular" in noun_vals.keys():
                nouns_formatted[noun_vals["singular"]]["plural"] = noun_vals["plural"]
                nouns_formatted[noun_vals["singular"]]["form"] = (
                    nouns_formatted[noun_vals["singular"]]["form"] + "/PL"
                )

for k in nouns_formatted.keys():
    nouns_formatted[k]["form"] = order_annotations(nouns_formatted[k]["form"])

nouns_formatted = collections.OrderedDict(sorted(nouns_formatted.items()))

if "Portuguese/nouns/" not in file_path:
    with open(
        "../../../Keyboards/LanguageKeyboards/Portuguese/Data/nouns.json",
        "w",
        encoding="utf-8",
    ) as f:
        json.dump(nouns_formatted, f, ensure_ascii=False, indent=2)
else:  # is being called by update_data.py
    with open(
        "../Keyboards/LanguageKeyboards/Portuguese/Data/nouns.json",
        "w",
        encoding="utf-8",
    ) as f:
        json.dump(nouns_formatted, f, ensure_ascii=False, indent=2)

print(f"Wrote file nouns.json with {len(nouns_formatted)} nouns.")
