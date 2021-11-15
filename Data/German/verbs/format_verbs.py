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
    "pastParticiple",
    "auxiliaryVerb",
    "indicativePresentFPS",
    "indicativePresentSPS",
    "indicativePresentTPS",
    "indicativePresentFPP",
    "indicativePresentSPP",
    "indicativePresentTPP",
    "indicativePreteriteFPS",
    "indicativePreteriteSPS",
    "indicativePreteriteTPS",
    "indicativePreteriteFPP",
    "indicativePreteriteSPP",
    "indicativePreteriteTPP",
    "indicativePerfectFPS",
    "indicativePerfectSPS",
    "indicativePerfectTPS",
    "indicativePerfectFPP",
    "indicativePerfectSPP",
    "indicativePerfectTPP",
]


def assign_past_participle(verb, tense):
    """
    Assigns the past participle after the auxiliary verb or by itself.
    """
    if verbs_formatted[verb["infinitive"]][tense] not in ["", verb["pastParticiple"]]:
        verbs_formatted[verb["infinitive"]][tense] += " " + verb["pastParticiple"]
    else:
        verbs_formatted[verb["infinitive"]][tense] = verb["pastParticiple"]


for verb_vals in verbs_list:
    if (
        "infinitive" in verb_vals.keys()
        and verb_vals["infinitive"] not in verbs_formatted.keys()
    ):
        non_infinitive_conjugations = {
            k: v for k, v in verb_vals.items() if k != "infinitive"
        }
        verbs_formatted[verb_vals["infinitive"]] = non_infinitive_conjugations

        for k in all_keys:
            if k not in verbs_formatted[verb_vals["infinitive"]].keys():
                verbs_formatted[verb_vals["infinitive"]][k] = ""

        if "auxiliaryVerb" in verb_vals.keys():
            # Sein
            if verb_vals["auxiliaryVerb"] == "L1761":
                verbs_formatted[verb_vals["infinitive"]]["auxiliaryVerb"] = "sein"

                verbs_formatted[verb_vals["infinitive"]][
                    "indicativePerfectFPS"
                ] += "bin"
                verbs_formatted[verb_vals["infinitive"]][
                    "indicativePerfectSPS"
                ] += "bist"
                verbs_formatted[verb_vals["infinitive"]][
                    "indicativePerfectTPS"
                ] += "ist"
                verbs_formatted[verb_vals["infinitive"]][
                    "indicativePerfectFPP"
                ] += "sind"
                verbs_formatted[verb_vals["infinitive"]][
                    "indicativePerfectSPP"
                ] += "seid"
                verbs_formatted[verb_vals["infinitive"]][
                    "indicativePerfectTPP"
                ] += "sind"

            # Haben
            elif verb_vals["auxiliaryVerb"] == "L4179":
                verbs_formatted[verb_vals["infinitive"]]["auxiliaryVerb"] = "haben"

                verbs_formatted[verb_vals["infinitive"]][
                    "indicativePerfectFPS"
                ] += "habe"
                verbs_formatted[verb_vals["infinitive"]][
                    "indicativePerfectSPS"
                ] += "hast"
                verbs_formatted[verb_vals["infinitive"]][
                    "indicativePerfectTPS"
                ] += "hat"
                verbs_formatted[verb_vals["infinitive"]][
                    "indicativePerfectFPP"
                ] += "haben"
                verbs_formatted[verb_vals["infinitive"]][
                    "indicativePerfectSPP"
                ] += "habt"
                verbs_formatted[verb_vals["infinitive"]][
                    "indicativePerfectTPP"
                ] += "haben"

    # The verb has two entries and thus has forms with both sein and haben.
    elif (
        "auxiliaryVerb" in verb_vals.keys()
        and verbs_formatted[verb_vals["infinitive"]]["auxiliaryVerb"]
        != verb_vals["auxiliaryVerb"]
    ):
        verbs_formatted[verb_vals["infinitive"]]["auxiliaryVerb"] = "sein/haben"

        verbs_formatted[verb_vals["infinitive"]]["indicativePerfectFPS"] = "bin/habe"
        verbs_formatted[verb_vals["infinitive"]]["indicativePerfectSPS"] = "bist/hast"
        verbs_formatted[verb_vals["infinitive"]]["indicativePerfectTPS"] = "ist/hat"
        verbs_formatted[verb_vals["infinitive"]]["indicativePerfectFPP"] = "sind/haben"
        verbs_formatted[verb_vals["infinitive"]]["indicativePerfectSPP"] = "seid/habt"
        verbs_formatted[verb_vals["infinitive"]]["indicativePerfectTPP"] = "sind/haben"

    if "pastParticiple" in verb_vals.keys():
        assign_past_participle(verb=verb_vals, tense="indicativePerfectFPS")
        assign_past_participle(verb=verb_vals, tense="indicativePerfectSPS")
        assign_past_participle(verb=verb_vals, tense="indicativePerfectTPS")
        assign_past_participle(verb=verb_vals, tense="indicativePerfectFPP")
        assign_past_participle(verb=verb_vals, tense="indicativePerfectSPP")
        assign_past_participle(verb=verb_vals, tense="indicativePerfectTPP")

with open(
    "../../../../Keyboards/LanguageKeyboards/German/Data/verbs.json",
    "w",
    encoding="utf-8",
) as f:
    json.dump(verbs_formatted, f, ensure_ascii=False, indent=2)

print(f"Wrote file verbs.json with {len(verbs_formatted)} verbs.")
