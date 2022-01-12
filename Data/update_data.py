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

    print(language)
    print(word_type)

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

for q in tqdm(queries_to_run[:1], desc="Data updated", unit="dirs",):
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

    call(
        ["python", f"./{q.split('/')[0]}/{q.split('/')[1]}/format_{q.split('/')[1]}"],
        shell=True,
    )
