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
    Maps those genders from Wikidata to succinct versions
    """
    if wikidata_gender == "masculine":
        return "M"
    if wikidata_gender == "feminine":
        return "F"


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
            nouns_formatted[noun_vals["singular"]]["plural"] = noun_vals["plural"]
            nouns_formatted[noun_vals["singular"]]["form"] = (
                nouns_formatted[noun_vals["singular"]]["form"] + "/PL"
            )

with open("../../nouns.json", "w", encoding="utf-8") as f:
    json.dump(nouns_formatted, f, ensure_ascii=False, indent=2)

print(f"Wrote file nouns.json with {len(nouns_formatted)} nouns.")
