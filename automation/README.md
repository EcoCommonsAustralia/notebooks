## Don't change EcoCommons Notebooks list in README.md manually!

Steps of updating the Readme.md of the notebook repo

1. Make sure the 'ipynb' and 'qmd' version of the new notebook is in the notebooks/notebooks folder.
2. In notebooks/automation, find the `notebooks-table-data.csv` file, add a new entry about the new notebook.
3. In bash, run `automation/autogenerate_notebooks_table.py` script. EcoCommons Notebooks table in `README.md` will update 
automatically. 

```bash
python3 automation/autogenerate_notebooks_table.py
```

4. Commit changes to feature branch. Create PR.
