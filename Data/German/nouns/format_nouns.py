"""
Format Nouns
------------

Formats the nouns queried from Wikidata using queryNouns.sparql.
"""

import json

with open("nounsQueried.json") as f:
    nouns_list = json.load(f)


def map_genders(wikidata_gender):
    """
    Maps those genders from Wikidata to succinct versions.
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
        if noun_vals["singular"] not in nouns_formatted:
            # Get plural and gender.
            if "plural" in noun_vals.keys() and "gender" in noun_vals.keys():
                nouns_formatted[noun_vals["singular"]] = {
                    "plural": noun_vals["plural"],
                    "form": map_genders(noun_vals["gender"]),
                }

                # Assign plural as a new entry after checking if it's its own plural.
                if noun_vals["plural"] not in nouns_formatted:
                    if noun_vals["singular"] != noun_vals["plural"]:
                        nouns_formatted[noun_vals["plural"]] = {
                            "plural": "isPlural",
                            "form": "PL",
                        }

                    else:
                        nouns_formatted[noun_vals["plural"]] = {
                            "plural": noun_vals["plural"],
                            "form": "PL",
                        }
                else:
                    # Mark plural as a possible form if it isn't already.
                    if (
                        "PL" not in nouns_formatted[noun_vals["plural"]]["form"]
                        and nouns_formatted[noun_vals["plural"]]["form"] != "noForm"
                    ):
                        nouns_formatted[noun_vals["plural"]]["form"] = (
                            nouns_formatted[noun_vals["plural"]]["form"] + "/PL"
                        )

                    elif nouns_formatted[noun_vals["plural"]]["form"] == "noForm":
                        nouns_formatted[noun_vals["plural"]]["form"] = "PL"

                    # Assign itself as a plural if possible (maybe wasn't for prior versions).
                    if noun_vals["singular"] == noun_vals["plural"]:
                        nouns_formatted[noun_vals["plural"]]["plural"] = noun_vals[
                            "plural"
                        ]

            # Get plural and assign it as a noun.
            elif "plural" in noun_vals.keys() and "gender" not in noun_vals.keys():
                nouns_formatted[noun_vals["singular"]] = {
                    "plural": noun_vals["plural"],
                    "form": "noForm",
                }

                # Assign plural as a new entry after checking if it's its own plural.
                if noun_vals["plural"] not in nouns_formatted:
                    if noun_vals["singular"] != noun_vals["plural"]:
                        nouns_formatted[noun_vals["plural"]] = {
                            "plural": "isPlural",
                            "form": "PL",
                        }

                    else:
                        nouns_formatted[noun_vals["plural"]] = {
                            "plural": noun_vals["plural"],
                            "form": "PL",
                        }
                else:
                    # Mark plural as a possible form if it isn't already.
                    if (
                        "PL" not in nouns_formatted[noun_vals["plural"]]["form"]
                        and nouns_formatted[noun_vals["plural"]]["form"] != "noForm"
                    ):
                        nouns_formatted[noun_vals["plural"]]["form"] = (
                            nouns_formatted[noun_vals["plural"]]["form"] + "/PL"
                        )

                    elif nouns_formatted[noun_vals["plural"]]["form"] == "noForm":
                        nouns_formatted[noun_vals["plural"]]["form"] = "PL"

                    # Assign itself as a plural if possible (maybe wasn't for prior versions).
                    if noun_vals["singular"] == noun_vals["plural"]:
                        nouns_formatted[noun_vals["plural"]]["plural"] = noun_vals[
                            "plural"
                        ]

            elif "plural" not in noun_vals.keys() and "gender" in noun_vals.keys():
                nouns_formatted[noun_vals["singular"]] = {
                    "plural": "noPlural",
                    "form": map_genders(noun_vals["gender"]),
                }

    elif "plural" in noun_vals.keys():
        if noun_vals["plural"] not in nouns_formatted:
            nouns_formatted[noun_vals["plural"]] = {
                "plural": "isPlural",
                "form": "PL",
            }
        else:
            # Mark plural as a possible form if it isn't already.
            if (
                "PL" not in nouns_formatted[noun_vals["plural"]]["form"]
                and nouns_formatted[noun_vals["plural"]]["form"] != "noForm"
            ):
                nouns_formatted[noun_vals["plural"]]["form"] = (
                    nouns_formatted[noun_vals["plural"]]["form"] + "/PL"
                )

            elif nouns_formatted[noun_vals["plural"]]["form"] == "noForm":
                nouns_formatted[noun_vals["plural"]]["form"] = "PL"


with open(
    "../../../../Keyboards/LanguageKeyboards/German/Data/nouns.json",
    "w",
    encoding="utf-8",
) as f:
    json.dump(nouns_formatted, f, ensure_ascii=False, indent=2)

print(f"Wrote file nouns.json with {len(nouns_formatted)} nouns.")
