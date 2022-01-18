"""
Update Data
-----------

Updates all data for Scribe by running all WDQS queries and formatting scripts.
"""

import json
import os
import sys

import pandas as pd
import tabulate
from requests.exceptions import HTTPError
from tqdm.auto import tqdm
from wikidataintegrator import wdi_core
from wikidataintegrator.wdi_config import config as wdi_config

wdi_config["BACKOFF_MAX_TRIES"] = 1

with open("total_data.json") as f:
    current_data = json.load(f)

current_languages = list(current_data.keys())
word_types = ["nouns", "verbs", "prepositions"]

# Check to see if the language has all zeroes for its data, meaning it's been added.
new_language_list = []
for lang in current_languages:
    current_data = list({current_data[lang][w] for w in word_types})
    if len(current_data) == 1 and current_data[0] == 0:
        new_language_list.append(lang)

language = None
word_type = None
if len(sys.argv) == 2:
    arg = sys.argv[1]
    if arg in current_languages:
        language = arg
    elif arg in word_types:
        word_type = arg
    else:
        InterruptedError(
            """"
        An invalid argument was specified.
        For languages, please choose from those found as keys in total_data.json.
        For grammatical types, please choose from nouns, verbs or prepositions.
        """
        )

elif len(sys.argv) == 3:
    language = sys.argv[1]
    word_type = sys.argv[2]

# Derive Data directory elements for potential queries.
data_dir_elements = []

for path, _, files in os.walk("."):
    for name in files:
        data_dir_elements.append(os.path.join(path, name))

data_dir_files = [f for f in os.listdir(".") if os.path.isfile(os.path.join(".", f))]

data_dir_dirs = list(
    {
        f.split("./")[1].split("/")[0]
        for f in data_dir_elements
        if f.split("./")[1] not in data_dir_files
    }
)

# Subset current_languages and word_types if arguments have been passed.
languages_update = []
if language is not None:
    if language in current_languages:
        languages_update = [l for l in current_languages if l == language]
    else:
        InterruptedError(
            """"
        An invalid language was specified.
        Please choose from those found as keys in total_data.json.
        """
        )
else:
    languages_update = current_languages

word_types_update = []
if word_type is not None:
    if word_type in word_types:
        word_types_update = [w for w in word_types if w == word_type]
    else:
        InterruptedError(
            """"
        An invalid grammatical type was specified.
        Please choose from nouns, verbs or prepositions.
        """
        )
else:
    word_types_update = word_types

possible_queries = []
for d in data_dir_dirs:
    for target_type in word_types_update:
        if "./" + d + "/" + target_type in [
            e[: len("./" + d + "/" + target_type)] for e in data_dir_elements
        ]:
            possible_queries.append(d + "/" + target_type)

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
    query_path = "./" + q + "/" + query_name

    with open(query_path) as file:
        query_lines = file.readlines()

    # First format the lines into a multi-line string and then pass this to wikidataintegrator.
    print(f"Querying {lang} {target_type}")
    query = None
    try:
        query = wdi_core.WDFunctionsEngine.execute_sparql_query("".join(query_lines))
    except HTTPError as err:
        print(f"HTTPError with {query_name}: {err}")

    if query is None:
        print(f"Nothing returned by the WDQS server for {query_name}")

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
    with open("./total_data.json", "w", encoding="utf-8",) as f:
        json.dump(current_data, f, ensure_ascii=False, indent=2)

    # Update data_table.txt
    current_data_df = pd.DataFrame()
    current_data_df.index = sorted(list(current_data.keys()))
    current_data_df.columns = word_types
    for lang in list(current_data_df.index):
        for wt in list(current_data_df.columns):
            current_data_df.loc[lang, wt] = current_data[lang][wt]

    with open("data_table.txt", "w+") as f:
        f.writelines(
            tabulate.tabulate(
                tabular_data=current_data_df.values,
                headers=current_data_df.columns,
                tablefmt="pipe",
            )
        )

    # Update data_updates.txt.
    data_added_string = ""
    language_keys = sorted(list(data_added_dict.keys()))
    for l in language_keys:
        if l == language_keys[0]:
            if l in new_language_list:
                data_added_string += f"- {l} (New): "
            else:
                data_added_string += f"- {l}: "
        else:
            if l in new_language_list:
                data_added_string += f"\n- {l} (New): "
            else:
                data_added_string += f"\n- {l}: "

        for w in word_types_update:
            if data_added_dict[l][w] == 0:
                pass
            elif data_added_dict[l][w] == 1:  # remove the s for label
                data_added_string += f"{data_added_dict[l][w]} {w[:-1]},"
            else:
                data_added_string += f"{data_added_dict[l][w]} {w},"
        data_added_string = data_added_string[:-1]  # remove the last comma

    with open("data_updates.txt", "w+") as f:
        f.writelines(data_added_string)
