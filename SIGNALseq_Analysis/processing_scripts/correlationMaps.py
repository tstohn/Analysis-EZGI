import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import numpy as np

# Load the TSV file
df = pd.read_csv("SIGNALseq_Analysis/output/ezgi_ab/ABPROTEIN_Counts_UMI2MM.tsv", sep="\t")

# Pivot to wide format: rows = SCs, columns = ABs, values = Count
matrix = df.pivot_table(index="SingleCell_BARCODE", columns="AB_BARCODE", values="AB_COUNT", fill_value=0)
log_mat = np.log1p(matrix)  # log(x + 1)
clr_mat = log_mat.sub(log_mat.mean(axis=1), axis=0)
print(clr_mat)
# Compute correlation matrix between ABs
corr_matrix = clr_mat.corr(method="pearson")  # or 'spearman'

# Plot the heatmap
plt.figure(figsize=(10, 8))
sns.heatmap(
    corr_matrix,
    cmap="RdBu",       # Red to Blue, reversed for positive=blue, negative=red
    center=0,            # White at 0
    square=True,
    cbar_kws={"label": "Correlation"}
)
plt.title("Correlation Between Antibodies Across Single Cells")
plt.tight_layout()
plt.savefig("CORR_MAP_0.png", dpi=300)
plt.show()