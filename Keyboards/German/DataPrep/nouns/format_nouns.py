"""
Nouns Format
------------

Formats the nouns queried from Wikidata using nounsQueried.sparql
"""

import json

with open("nounsQueried.json") as f:
    nouns_list = json.load(f)


def map_genders(wikidata_gender):
    """
    Maps those genders from Wikidata to succinct versions
    """
    if wikidata_gender == "masculine":
        return "M"
    if wikidata_gender == "feminine":
        return "F"
    if wikidata_gender == "neuter":
        return "N"


nouns_formatted = {}

for noun_vals in nouns_list:
    if "singular" in noun_vals.keys():
        if "plural" in noun_vals.keys() and "gender" in noun_vals.keys():
            if (
                noun_vals["singular"] in nouns_formatted
                and nouns_formatted[noun_vals["singular"]]["form"] != "noForm"
            ):
                # WIP: finding a solution for words with more than one plural.
                # Add the form only if it's not yet present.
                if (
                    map_genders(noun_vals["gender"])
                    not in nouns_formatted[noun_vals["singular"]]["form"]
                ):
                    nouns_formatted[noun_vals["singular"]] = {
                        "plural": noun_vals["plural"],
                        "form": nouns_formatted[noun_vals["singular"]]["form"]
                        + "/"
                        + map_genders(noun_vals["gender"]),
                    }
            else:
                nouns_formatted[noun_vals["singular"]] = {
                    "plural": noun_vals["plural"],
                    "form": map_genders(noun_vals["gender"]),
                }

                if (
                    noun_vals["plural"] in nouns_formatted
                    and "PL" not in nouns_formatted[noun_vals["singular"]]["form"]
                ):
                    nouns_formatted[noun_vals["plural"]] = {
                        "plural": noun_vals["plural"],
                        "form": nouns_formatted[noun_vals["singular"]]["form"]
                        + "/"
                        + "PL",
                    }

        elif "plural" in noun_vals.keys():
            nouns_formatted[noun_vals["singular"]] = {
                "plural": noun_vals["plural"],
                "form": "noForm",
            }

            nouns_formatted[noun_vals["singular"]["plural"]] = {
                "plural": "isPlural",
                "form": "PL",
            }

        elif "gender" in noun_vals.keys():
            nouns_formatted[noun_vals["singular"]] = {
                "plural": "noPlural",
                "form": map_genders(noun_vals["gender"]),
            }

    elif "plural" in noun_vals.keys():
        nouns_formatted[noun_vals["plural"]] = {
            "plural": "isPlural",
            "form": "PL",
        }

with open("../../nouns.json", "w", encoding="utf-8") as f:
    json.dump(nouns_formatted, f, ensure_ascii=False, indent=2)

print(f"Wrote file nouns.json with {len(nouns_formatted)} nouns.")
