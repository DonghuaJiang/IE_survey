# neqr_row_encrypt.py
# Requires: numpy, pandas, pillow
# pip install numpy pandas pillow

from pathlib import Path
import argparse
import numpy as np
import pandas as pd
from PIL import Image

# ---- Fixed project directory ----
PROJECT_DIR = Path("/Users/shahbaz/Python_projects/neqr_demo")

def bits_to_int(bstr: str) -> int:
    return int(bstr, 2)

def int_to_bits(x: int, width: int) -> str:
    return format(int(x), f"0{width}b")

def infer_size_from_df(df: pd.DataFrame) -> int:
    if "y" in df.columns and "x" in df.columns:
        max_dim = max(df["y"].max(), df["x"].max()) + 1
        n = int(np.log2(max_dim))
        assert 2**n == max_dim, "y/x columns do not look like power-of-two indices"
        return 2**n
    elif "pos_bits" in df.columns:
        L = len(str(df["pos_bits"].iloc[0]))
        assert L % 2 == 0, "pos_bits length must be even"
        n = L // 2
        return 2**n
    else:
        raise ValueError("CSV must have either columns y,x or pos_bits.")

def ensure_yx_columns(df: pd.DataFrame) -> pd.DataFrame:
    if "y" in df.columns and "x" in df.columns:
        return df.copy()
    if "pos_bits" not in df.columns:
        raise ValueError("CSV missing both (y,x) and pos_bits; cannot derive positions.")
    out = df.copy()
    L = len(str(out["pos_bits"].iloc[0]))
    assert L % 2 == 0, "pos_bits length must be even"
    n = L // 2
    y_bits = out["pos_bits"].str.slice(0, n)
    x_bits = out["pos_bits"].str.slice(n, L)
    out["y"] = y_bits.apply(bits_to_int)
    out["x"] = x_bits.apply(bits_to_int)
    return out

def get_gray_from_row(row: pd.Series) -> int:
    if "gray" in row and not pd.isna(row["gray"]):
        return int(row["gray"])
    if "gray_bits" in row and isinstance(row["gray_bits"], str):
        return bits_to_int(row["gray_bits"])
    raise ValueError("CSV must have 'gray' or 'gray_bits' for pixel intensities.")

# Rebuilding an image from the NEQR rows (after shuffling)
def build_image_from_terms(df: pd.DataFrame, size: int) -> np.ndarray:
    img = np.zeros((size, size), dtype=np.uint8)
    for _, r in df.iterrows():
        y = int(r["y"])
        x = int(r["x"])
        g = get_gray_from_row(r)
        img[y, x] = g
    return img

# Row-shuffle function
def row_shuffle(df: pd.DataFrame, size: int, seed: str):
    rng = np.random.default_rng(np.frombuffer(seed.encode("utf-8"), dtype=np.uint8).sum())
    perm = rng.permutation(size)         # old y -> new y'

    out = df.copy()
    out["y"] = out["y"].map(lambda old_y: int(perm[old_y]))

    n = int(np.log2(size))
    if "y_bits" in out.columns:
        out["y_bits"] = out["y"].map(lambda v: int_to_bits(v, n))
    if "pos_bits" in out.columns:
        if "x_bits" in out.columns:
            out["pos_bits"] = out["y_bits"] + out["x_bits"]
        else:
            out["x_bits"] = out["x"].map(lambda v: int_to_bits(v, n))
            out["pos_bits"] = out["y_bits"] + out["x_bits"]

    return out

def save_image(img: np.ndarray, out_path: Path):
    PROJECT_DIR.mkdir(parents=True, exist_ok=True)
    Image.fromarray(img, mode="L").save(out_path)

def main():
    parser = argparse.ArgumentParser(description="Row-shuffle NEQR CSV and save encrypted image + row_encrypted CSV in project folder.")
    parser.add_argument("--csv", default="houses_256_neqr_terms.csv",
                        help="NEQR terms CSV filename (inside project dir)")
    parser.add_argument("--seed", default="my-secret-key",
                        help="Seed/key for row permutation (use same seed to decrypt)")
    parser.add_argument("--out-image", default="encrypted_rows.png",
                        help="Output image filename (saved inside project dir)")
    parser.add_argument("--out-csv", default=None,
                        help="Output CSV filename for row-encrypted NEQR terms (default: derived from out-image)")
    args = parser.parse_args()

    # Resolve paths to project dir
    csv_path = PROJECT_DIR / Path(args.csv).name
    out_img_path = PROJECT_DIR / Path(args.out_image).name
    if args.out_csv:
        out_csv_path = PROJECT_DIR / Path(args.out_csv).name
    else:
        out_csv_path = PROJECT_DIR / (out_img_path.stem + "_row_encrypted.csv")

    assert csv_path.exists(), f"CSV not found in project folder: {csv_path}"

    # Read CSV
    df0 = pd.read_csv(csv_path, dtype=str)
    for col in ["gray", "y", "x"]:
        if col in df0.columns:
            df0[col] = pd.to_numeric(df0[col], errors="coerce")

    # Ensure y,x present and infer size
    df_pos = ensure_yx_columns(df0)
    size = infer_size_from_df(df_pos)

    # Row-shuffle (encrypt)
    df_enc = row_shuffle(df_pos, size=size, seed=args.seed)

    # Save encrypted image
    img_enc = build_image_from_terms(df_enc, size)
    save_image(img_enc, out_img_path)
    print(f"Encrypted (row-shuffled) image -> {out_img_path.resolve()}")

    # Save row-encrypted NEQR CSV
    cols = [c for c in ["amplitude","gray","gray_bits","y","y_bits","x","x_bits","pos_bits"] if c in df_enc.columns]
    df_enc.to_csv(out_csv_path, index=False, columns=cols or None)
    print(f"Row-encrypted NEQR CSV -> {out_csv_path.resolve()}")

if __name__ == "__main__":
    main()