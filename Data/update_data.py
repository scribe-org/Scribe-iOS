"""
Update Data
-----------

Updates all data for Scribe by running all WDQS queries and formatting scripts.
"""

import json
import os
import sys
from subprocess import call

from tqdm.auto import tqdm
from wikidataintegrator import wdi_core

with open("total_data.json") as f:
    current_data = json.load(f)

current_languages = list(current_data.keys())
word_types = ["nouns", "verbs", "prepositions"]

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
if language is not None:
    if language in current_languages:
        current_languages = [l for l in current_languages if l == language]
    else:
        InterruptedError(
            """"
        An invalid language was specified.
        Please choose from those found as keys in total_data.json.
        """
        )

if word_type is not None:
    if word_type in word_types:
        word_types = [w for w in word_types if w == word_type]
    else:
        InterruptedError(
            """"
        An invalid grammatical type was specified.
        Please choose from nouns, verbs or prepositions.
        """
        )

possible_queries = []
for d in data_dir_dirs:
    for wt in word_types:
        if "./" + d + "/" + wt in [
            e[: len("./" + d + "/" + wt)] for e in data_dir_elements
        ]:
            possible_queries.append(d + "/" + wt)

queries_to_run_lists = [
    [q for q in possible_queries if q[: len(lang)] in current_languages]
    for lang in current_languages
]

queries_to_run = list({q for sub in queries_to_run_lists for q in sub})

data_added_dict = {}

for q in tqdm(queries_to_run, desc="Data updated", unit="dirs",):
    target_type = q.split("/")[1]
    query_name = "query" + target_type.title() + ".sparql"
    query_path = "./" + q + "/" + query_name

    with open(query_path) as file:
        query_lines = file.readlines()

    # First format the lines into a multi-line string and then pass this to wikidataintegrator.
    print(f"Querying {q.split('/')[0]} {q.split('/')[1]}")
    query = wdi_core.WDFunctionsEngine.execute_sparql_query(
        """{}""".format("".join(query_lines))
    )

    query_results = query["results"]["bindings"]

    # Format and save the resulting JSON.
    results_formatted = []
    for r in query_results:  # query_results is also a list
        r_dict = {k: r[k]["value"] for k in r.keys()}

        results_formatted.append(r_dict)

    with open(
        f"./{q.split('/')[0]}/{q.split('/')[1]}/{q.split('/')[1]}Queried.json",
        "w",
        encoding="utf-8",
    ) as f:
        json.dump(results_formatted, f, ensure_ascii=False, indent=2)

    # Call the corresponding formatting file and update data changes.
    call(
        ["python", f"./{q.split('/')[0]}/{q.split('/')[1]}/format_{q.split('/')[1]}"],
        shell=True,
    )

    with open(
        f"./../Keyboards/LanguageKeyboards/{q.split('/')[0]}/{q.split('/')[1]}.json"
    ) as f:
        new_keyboard_data = json.load(f)

    data_added_dict[q.split("/")[0]][q.split("/")[1]] = (
        len(new_keyboard_data) - current_data[q.split("/")[0]][q.split("/")[1]]
    )

    current_data[q.split("/")[0]][q.split("/")[1]] = len(new_keyboard_data)

# Update total_data.json
with open("./total_data.json", "w", encoding="utf-8",) as f:
    json.dump(current_data, f, ensure_ascii=False, indent=2)

# Update data_updates.txt
data_added_string = """"""
for l in data_added_dict:
    data_added_string += f"\n{l}"
    for w in word_types:
        if data_added_dict[l][w] == 0:
            pass
        elif data_added_dict[l][w] == 1:  # remove the s for label
            data_added_string += f"{data_added_dict[l][w]} {w[:-1]},"
        else:
            data_added_string += f"{data_added_dict[l][w]} {w},"
    data_added_string = data_added_string[:-1]  # remove the last comma

with open("data_updates.txt", "w+") as f:
    f.writelines(data_added_string)
