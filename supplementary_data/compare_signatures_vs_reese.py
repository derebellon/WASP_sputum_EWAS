#!/usr/bin/env python3
"""
CpG-level concordance of WASP sputum methylation signatures with the published
childhood-asthma methylation meta-analysis (Reese et al., PACE consortium,
J Allergy Clin Immunol 2019).

What it does
------------
1. Loads our significant DMP lists (probe-level) for three comparisons:
     A1  global asthma vs non-asthmatic
     C1  severe atopic vs rest
     C2  severe non-atopic vs rest
2. Loads Reese et al.'s 179 childhood-asthma CpGs (their Supplementary Table E5),
   which must be supplied by the user (see --reese; not redistributed here for
   copyright reasons - download it from the journal's supplementary material).
3. Matches by EXACT CpG (Illumina probe id) and reports, per signature:
     - number of shared CpGs (of Reese's 179)
     - direction-of-effect concordance
     - a hypergeometric enrichment p-value

Reproducibility
---------------
Our input lists are published in this repository (see README). Reese's table is
their copyrighted supplement; point --reese at the file you downloaded.

Usage
-----
    python compare_signatures_vs_reese.py \
        --hits-dir path/to/results_fresh/04_ewas \
        --reese path/to/reese_TableE5.docx \
        --out overlap_C1_vs_Reese179_CpG_level.csv
"""
import argparse, csv, os, re, sys

N_TESTED = 864152  # CpGs tested in the WASP sputum EWAS (denominator for enrichment)

def load_hits(path):
    """Return {probeID: delta_beta} from one of our *_HITS.csv files."""
    out = {}
    with open(path) as f:
        for row in csv.DictReader(f):
            pid = row.get("probeID")
            if not pid:
                continue
            try:
                out[pid] = float(row.get("beta") or row.get("coefficient"))
            except (TypeError, ValueError):
                out[pid] = None
    return out

def load_reese_e5(path):
    """Return {probeID: (gene, childhood_coef)} from Reese Supplementary Table E5 (.docx)."""
    from docx import Document
    d = Document(path)
    reese = {}
    for t in d.tables:
        for r in t.rows:
            c = [x.text.strip() for x in r.cells]
            if c and re.match(r"^cg\d{6,}$", c[0]):
                gene = c[2] or (c[3] if len(c) > 3 else "")
                coef = None
                try:
                    coef = float(c[4])
                except (IndexError, ValueError):
                    pass
                reese[c[0]] = (gene, coef)
    return reese

def hypergeom_sf(k, N, K, n):
    """P(X >= k) for hypergeometric; uses scipy if available, else a log-comb fallback."""
    try:
        from scipy.stats import hypergeom
        return float(hypergeom.sf(k - 1, N, K, n))
    except Exception:
        from math import lgamma, exp
        def lc(a, b):
            if b < 0 or b > a:
                return float("-inf")
            return lgamma(a + 1) - lgamma(b + 1) - lgamma(a - b + 1)
        total = 0.0
        for i in range(k, min(K, n) + 1):
            total += exp(lc(K, i) + lc(N - K, n - i) - lc(N, n))
        return total

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--hits-dir", required=True)
    ap.add_argument("--reese", required=True, help="Reese Supplementary Table E5 (.docx)")
    ap.add_argument("--out", default="overlap_C1_vs_Reese179_CpG_level.csv")
    a = ap.parse_args()

    sigs = {
        "A1_global_asthma": "EWAS_A1_asthma_GLOBAL_vs_CONTROLS_HITS.csv",
        "C1_severe_atopic": "EWAS_A9_phenotype_signature_C1_vs_rest_HITS.csv",
        "C2_severe_nonatopic": "EWAS_A10_phenotype_signature_C2_vs_rest_HITS.csv",
    }
    reese = load_reese_e5(a.reese)
    K = len(reese)
    print(f"Reese childhood CpGs loaded: {K}")

    for name, fn in sigs.items():
        ours = load_hits(os.path.join(a.hits_dir, fn))
        shared = sorted(set(ours) & set(reese))
        conc = sum(1 for cg in shared
                   if ours[cg] is not None and reese[cg][1] is not None
                   and (ours[cg] < 0) == (reese[cg][1] < 0))
        p = hypergeom_sf(len(shared), N_TESTED, K, len(ours))
        print(f"{name}: n={len(ours)} DMPs | shared CpGs={len(shared)} "
              f"| direction-concordant={conc}/{len(shared)} | hypergeom p={p:.2e}")
        if name.startswith("C1"):
            with open(a.out, "w", newline="") as g:
                w = csv.writer(g)
                w.writerow(["probeID", "gene", "our_delta_beta",
                            "reese_childhood_coef", "direction_concordant"])
                for cg in shared:
                    w.writerow([cg, reese[cg][0], ours[cg], reese[cg][1],
                                (ours[cg] < 0) == (reese[cg][1] < 0)])
            print(f"  wrote {a.out} ({len(shared)} rows)")

if __name__ == "__main__":
    sys.exit(main())
