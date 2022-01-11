"""
Update Data
-----------

Updates all data for Scribe by running all WDQS queries and formatting scripts.
"""


import json
import os

from tqdm.auto import tqdm
from wikidataintegrator import wdi_core

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

word_types = ["nouns", "verbs", "prepositions"]

with open("total_data.json") as f:
    current_data = json.load(f)
current_languages = list(current_data.keys())

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
    query_results = wdi_core.WDFunctionsEngine.execute_sparql_query(
        """{}""".format("".join(query_lines))
    )

print(query_results)
print(query_path)
