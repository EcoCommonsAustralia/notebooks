import nbformat

# Load the possibly corrupted notebook
with open("EC_RF.ipynb", "r", encoding="utf-8") as f:
    nb = nbformat.read(f, as_version=4)

# Write it back with clean formatting
with open("EC_RF.ipynb", "w", encoding="utf-8") as f:
    nbformat.write(nb, f)

print("Notebook cleaned and saved as EC_RF.ipynb")