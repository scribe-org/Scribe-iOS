"""
Update Data
-----------

Updates data for Scribe by running all or desired WDQS queries and formatting scripts.

Parameters
----------
    languages : list of strings (default=None)
        A subset of Scribe's languages that the user wants to update.

    word_types : list of strings (default=None)
        A subset of nouns, verbs, and prepositions that currently can be updated with this fie.

Usage
-----
    python update_data.py '[languages_in_quotes]' '[word_types_in_quotes]'
"""


import ast
import json
import os
import sys

import pandas as pd
from requests.exceptions import HTTPError
from tqdm.auto import tqdm
from wikidataintegrator import wdi_core
from wikidataintegrator.wdi_config import config as wdi_config

# Prevents WikidataIntegrator from infinitely trying queries.
wdi_config["BACKOFF_MAX_TRIES"] = 1

with open("./_update_files/total_data.json") as f:
    current_data = json.load(f)

current_languages = list(current_data.keys())
updateable_word_types = ["nouns", "verbs", "prepositions"]

# Check whether arguments have been passed to only update a subset of the data.
languages = None
word_types = None
if len(sys.argv) == 2:
    arg = sys.argv[1]
    if isinstance(arg, str):
        raise ValueError(
            f"""The argument type of '{arg}' passed to update_data.py is invalid.
            Only lists are allowed, and can be passed via:
            python update_data.py '[args_in_quotes]'
            """
        )

    try:
        arg = ast.literal_eval(arg)
    except:
        raise ValueError(
            f"""The argument type of '{arg}' passed to update_data.py is invalid.
            Only lists are allowed, and can be passed via:
            python update_data.py '[args_in_quotes]'
            """
        )

    if not isinstance(arg, list):
        raise ValueError(
            f"""The argument type of '{arg}' passed to update_data.py is invalid.
            Only lists are allowed, and can be passed via:
            python update_data.py '[args_in_quotes]'
            """
        )

    if set(arg).issubset(current_languages):
        languages = arg
    elif set(arg).issubset(updateable_word_types):
        word_types = arg
    else:
        raise ValueError(
            f"""An invalid argument '{arg}' was specified.
                For languages, please choose from those found as keys in total_data.json.
                For grammatical types, please choose from nouns, verbs or prepositions.
                """
        )
elif len(sys.argv) == 3:
    languages = sys.argv[1]
    word_types = sys.argv[2]

# Derive Data directory elements for potential queries.
data_dir_elements = []

for path, _, files in os.walk("."):
    data_dir_elements.extend(os.path.join(path, name) for name in files)
data_dir_files = [f for f in os.listdir(".") if os.path.isfile(os.path.join(".", f))]

data_dir_dirs = list(
    {
        f.split("./")[1].split("/")[0]
        for f in data_dir_elements
        if f.split("./")[1] not in data_dir_files
    }
)

# Subset current_languages and updateable_word_types if arguments have been passed.
languages_update = []
if languages is None:
    languages_update = current_languages

elif (
    not isinstance(ast.literal_eval(languages), str)
    and isinstance(ast.literal_eval(languages), list)
    and set(ast.literal_eval(languages)).issubset(current_languages)
):
    languages_update = ast.literal_eval(languages)
else:
    raise ValueError(
        f"""Invalid languages '{languages}' were specified.
            Please choose from those found as keys in total_data.json.
            Pass arguments via: python update_data.py '[languages_in_quotes]'
            """
    )
word_types_update = []
if word_types is None:
    word_types_update = updateable_word_types

elif (
    not isinstance(ast.literal_eval(word_types), str)
    and isinstance(ast.literal_eval(word_types), list)
    and set(ast.literal_eval(word_types)).issubset(updateable_word_types)
):
    word_types_update = ast.literal_eval(word_types)
else:
    raise ValueError(
        f"""Invalid grammatical types '{word_types}' were specified.
            Please choose from nouns, verbs or prepositions.
            Pass arguments via: python update_data.py '[word_types_in_quotes]'
            """
    )
# Check to see if the language has all zeroes for its data, meaning it's been added.
new_language_list = []
for lang in languages_update:
    # Prepositions not needed for all languages.
    check_current_data = [current_data[lang][k] for k in current_data[lang].keys()]
    if len(set(check_current_data)) == 1 and check_current_data[0] == 0:
        new_language_list.append(lang)

# Derive queries to be ran.
possible_queries = []
for d in data_dir_dirs:
    possible_queries.extend(
        f"{d}/{target_type}"
        for target_type in word_types_update
        if f"./{d}/{target_type}"
        in [e[: len(f"./{d}/{target_type}")] for e in data_dir_elements]
    )

queries_to_run_lists = [
    [q for q in possible_queries if q[: len(lang)] in languages_update]
    for lang in languages_update
]

queries_to_run = list({q for sub in queries_to_run_lists for q in sub})

data_added_dict = {}

for q in tqdm(queries_to_run, desc="Data updated", unit="dirs",):
    lang = q.split("/")[0]
    target_type = q.split("/")[1]
    query_name = "query" + target_type.title() + ".sparql"
    query_path = f"./{q}/{query_name}"

    with open(query_path) as file:
        query_lines = file.readlines()

    # First format the lines into a multi-line string and then pass this to wikidataintegrator.
    print(f"Querying {lang} {target_type}")
    query = None
    try:
        query = wdi_core.WDFunctionsEngine.execute_sparql_query("".join(query_lines))
    except HTTPError as err:
        print(f"HTTPError with {query_path}: {err}")

    if query is None:
        print(f"Nothing returned by the WDQS server for {query_path}")

    else:
        query_results = query["results"]["bindings"]

        # Format and save the resulting JSON.
        results_formatted = []
        for r in query_results:  # query_results is also a list
            r_dict = {k: r[k]["value"] for k in r.keys()}

            results_formatted.append(r_dict)

        with open(
            f"./{lang}/{target_type}/{target_type}Queried.json", "w", encoding="utf-8",
        ) as f:
            json.dump(results_formatted, f, ensure_ascii=False, indent=2)

        # Call the corresponding formatting file and update data changes.
        os.system(f"python ./{lang}/{target_type}/format_{target_type}.py")

        with open(
            f"./../Keyboards/LanguageKeyboards/{lang}/Data/{target_type}.json"
        ) as f:
            new_keyboard_data = json.load(f)

        if lang not in data_added_dict.keys():
            data_added_dict[lang] = {}
        data_added_dict[lang][target_type] = (
            len(new_keyboard_data) - current_data[lang][target_type]
        )

        current_data[lang][target_type] = len(new_keyboard_data)

# Update total_data.json.
with open("./_update_files/total_data.json", "w", encoding="utf-8",) as f:
    json.dump(current_data, f, ensure_ascii=False, indent=2)


def num_add_commas(num):
    """
    Adds commas to a numeric string for readability.

    Parameters
    ----------
        num : int
            An int to have commas added to.

    Retruns
    -------
        str_with_commas : str
            The original number with commas to make it more readable.
    """
    num_str = str(num)

    str_list = list(num_str)
    str_list = str_list[::-1]

    str_list_with_commas = [
        f"{s}," if i % 3 == 0 and i != 0 else s for i, s in enumerate(str_list)
    ]

    str_list_with_commas = str_list_with_commas[::-1]

    return "".join(str_list_with_commas)


# Update data_table.txt
current_data_df = pd.DataFrame(
    index=sorted(list(current_data.keys())),
    columns=["nouns", "verbs", "translations", "adjectives", "prepositions"],
)
for lang in list(current_data_df.index):
    for wt in list(current_data_df.columns):
        if wt in current_data[lang].keys():
            current_data_df.loc[lang, wt] = num_add_commas(current_data[lang][wt])
        elif wt == "translations":
            current_data_df.loc[lang, wt] = num_add_commas(67652)

current_data_df.index.name = "Languages"
current_data_df.columns = [c.capitalize() for c in current_data_df.columns]
with open("./_update_files/data_table.txt", "w+") as f:
    table_string = str(current_data_df.to_markdown()).replace(" nan ", "   - ")
    # Right justify the data and left justify the language indexes.
    table_string = (
        table_string.replace("-|-", ":|-")
        .replace("-|:", ":|-")
        .replace(":|-", "-|-", 1)
    )
    f.writelines(table_string)

# Update data_updates.txt.
data_added_string = ""
language_keys = sorted(list(data_added_dict.keys()))

# Check if all data added values are 0 and remove if so.
for l in language_keys:
    if all(v <= 0 for v in data_added_dict[l].values()):
        language_keys.remove(l)

for l in language_keys:
    if l == language_keys[0]:
        data_added_string += f"- {l} (New):" if l in new_language_list else f"- {l}:"
    else:
        data_added_string += (
            f"\n- {l} (New):" if l in new_language_list else f"\n- {l}:"
        )

    for wt in word_types_update:
        if wt in data_added_dict[l].keys():
            if data_added_dict[l][wt] <= 0:
                pass
            elif data_added_dict[l][wt] == 1:  # remove the s for label
                data_added_string += f" {data_added_dict[l][wt]} {wt[:-1]},"
            else:
                data_added_string += f" {data_added_dict[l][wt]} {wt},"

    data_added_string = data_added_string[:-1]  # remove the last comma

with open("./_update_files/data_updates.txt", "w+") as f:
    f.writelines(data_added_string)
