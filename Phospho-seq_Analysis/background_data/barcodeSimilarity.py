#!/usr/bin/env python3
import sys
from typing import List  # <— add this

def hamming_distance(a: str, b: str) -> int:
    """Return Hamming distance between equal-length strings."""
    if len(a) != len(b):
        return float('inf')
    return sum(c1 != c2 for c1, c2 in zip(a, b))

def get_hamming_neighbors(file_path: str, query: str) -> List[str]:  # <— use List[str]
    """Read comma-separated barcodes from first line of file and return those 1 Hamming away."""
    with open(file_path) as f:
        first_line = f.readline().strip()
    barcodes = [s.strip() for s in first_line.split(',') if s.strip()]
    return [bc for bc in barcodes if hamming_distance(bc, query) == 1]

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print(f"Usage: {sys.argv[0]} <file> <query_barcode>")
        sys.exit(1)

    file_path = sys.argv[1]
    query = sys.argv[2]
    neighbors = get_hamming_neighbors(file_path, query)
    print("\n".join(neighbors))