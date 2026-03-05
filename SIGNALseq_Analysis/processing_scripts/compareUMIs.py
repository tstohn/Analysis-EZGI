import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
from tqdm import tqdm
from rapidfuzz.distance import Hamming, Levenshtein
from scipy.spatial.distance import squareform
from scipy.cluster.hierarchy import linkage, dendrogram
import umap

# Load data
df = pd.read_csv("SIGNALseq_Analysis/output/ezgi_ab/UMIPROTEIN_Counts_0.tsv", sep="\t")
filtered_df = df[df["AB"] == "pS6_[S240/S244]_2"]

# Select two example cells (change as needed)
sc_examples = ["GCCGGCGTTCAGATTCGGCTACAG", "CCGCGAGCTCAGGAGGTACCACCA","CAATTGTGGCACTGTCTGGCTCAG","CAATTGTGTGCGATCTTGTGAAGA"]
umi_df = filtered_df[filtered_df["SingleCell_ID"].isin(sc_examples)].copy()

# Sort UMIs by SingleCell_ID and UMI_COUNT
umi_df = umi_df.sort_values(by=["SingleCell_ID", "UMI_COUNT"], ascending=[True, False])

# Extract UMIs
umis = umi_df["UMI"].tolist()
n = len(umis)
print(umi_df)

# Compute distance matrix
USE_HAMMING = True
distance_matrix = np.zeros((n, n))
for i in tqdm(range(n)):
    for j in range(i + 1, n):
        dist = Hamming.distance(umis[i], umis[j]) if USE_HAMMING else Levenshtein.distance(umis[i], umis[j])
        distance_matrix[i, j] = dist
        distance_matrix[j, i] = dist

# Create a DataFrame for distances
df_dist = pd.DataFrame(distance_matrix, index=umis, columns=umis)

# Create metadata (SingleCell_ID for each UMI)
umi_meta = umi_df.drop_duplicates(subset="UMI")[["UMI", "SingleCell_ID"]].set_index("UMI")
umi_meta = umi_meta.loc[umis]  # ensure correct order

# Assign a color to each SingleCell_ID
unique_cells = umi_meta["SingleCell_ID"].unique()
palette = sns.color_palette("husl", len(unique_cells))
sc_color_map = dict(zip(unique_cells, palette))
row_colors = umi_meta["SingleCell_ID"].map(sc_color_map)

# Plot heatmap with row/col colors
sns.set(font_scale=0.6)
g = sns.clustermap(
    df_dist,
    row_cluster=False,
    col_cluster=False,
    row_colors=row_colors,
    col_colors=row_colors,
    cmap="mako_r",
    xticklabels=False,
    yticklabels=False,
    figsize=(12, 12)
)

# Optional: add a legend for cell colors
for label in unique_cells:
    g.ax_col_dendrogram.bar(0, 0, color=sc_color_map[label],
                            label=label, linewidth=0)
g.ax_col_dendrogram.legend(loc="center", ncol=1, bbox_to_anchor=(1.2, 0.5), title="SingleCell_ID")

# Save and show
plt.title("UMIs Ordered by Cell and Abundance", pad=20)
g.savefig("ordered_umi_heatmap_colored_0.png", dpi=300, bbox_inches="tight")
plt.show()



###################
#. PLOT THE UMAP
##################

# Run UMAP on distance matrix
reducer = umap.UMAP(metric="precomputed", random_state=42)
embedding = reducer.fit_transform(df_dist.values)

# Create UMAP DataFrame
umap_df = pd.DataFrame(embedding, columns=["UMAP1", "UMAP2"])
umap_df["SingleCell_ID"] = umi_meta["SingleCell_ID"].values

# Plot UMAP
plt.figure(figsize=(8, 6))
sns.scatterplot(
    data=umap_df,
    x="UMAP1", y="UMAP2",
    hue="SingleCell_ID",
    palette=sc_color_map,
    s=20,
    alpha=0.8
)
plt.title("UMAP of UMIs Colored by SingleCell_ID")
plt.legend(bbox_to_anchor=(1.05, 1), loc='upper left', title="SingleCell_ID")
plt.tight_layout()
plt.savefig("umi_umap_by_cell_0.png", dpi=300)
plt.show()