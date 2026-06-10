# neqr_row_decrypt.py
# Requires: numpy, pandas, pillow
# pip install numpy pandas pillow

from pathlib import Path
import argparse
import numpy as np
import pandas as pd
from PIL import Image

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

def build_image_from_terms(df: pd.DataFrame, size: int) -> np.ndarray:
    img = np.zeros((size, size), dtype=np.uint8)
    for _, r in df.iterrows():
        y = int(r["y"])
        x = int(r["x"])
        g = get_gray_from_row(r)
        img[y, x] = g
    return img

def decrypt_row_shuffle(df_encrypted: pd.DataFrame, size: int, seed: str) -> pd.DataFrame:
    """
    Recreate the same permutation from 'seed', then apply its inverse to restore rows.
    """
    rng = np.random.default_rng(np.frombuffer(seed.encode("utf-8"), dtype=np.uint8).sum())
    perm = rng.permutation(size)                  # old y -> y'
    inv_perm = np.empty_like(perm)
    inv_perm[perm] = np.arange(size)              # y' -> old y

    out = df_encrypted.copy()
    out["y"] = out["y"].map(lambda yprime: int(inv_perm[yprime]))

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
    parser = argparse.ArgumentParser(description="Decrypt row-shuffled NEQR CSV and save decrypted image + NEQR CSV.")
    parser.add_argument("--csv", default="encrypted_rows_row_encrypted.csv",
                        help="Row-encrypted CSV filename (inside project dir)")
    parser.add_argument("--seed", default="my-secret-key",
                        help="Seed/key used during encryption (must match)")
    parser.add_argument("--out-image", default="decrypted_rows.png",
                        help="Output decrypted image filename (inside project dir)")
    parser.add_argument("--out-csv", default=None,
                        help="Output decrypted NEQR CSV filename (default derived from out-image)")
    args = parser.parse_args()

    in_csv_path = PROJECT_DIR / Path(args.csv).name
    out_img_path = PROJECT_DIR / Path(args.out_image).name
    if args.out_csv:
        out_csv_path = PROJECT_DIR / Path(args.out_csv).name
    else:
        out_csv_path = PROJECT_DIR / (out_img_path.stem + ".csv")

    assert in_csv_path.exists(), f"Row-encrypted CSV not found in project folder: {in_csv_path}"

    # Read row-encrypted CSV
    df_enc = pd.read_csv(in_csv_path, dtype=str)
    for col in ["gray", "y", "x"]:
        if col in df_enc.columns:
            df_enc[col] = pd.to_numeric(df_enc[col], errors="coerce")

    # Ensure y,x present and infer size
    df_enc = ensure_yx_columns(df_enc)
    size = infer_size_from_df(df_enc)

    # Decrypt (invert row shuffle via seed)
    df_dec = decrypt_row_shuffle(df_enc, size=size, seed=args.seed)

    # Save decrypted image
    img_dec = build_image_from_terms(df_dec, size)
    save_image(img_dec, out_img_path)
    print(f"Decrypted image -> {out_img_path.resolve()}")

    # Save decrypted NEQR CSV
    cols = [c for c in ["amplitude","gray","gray_bits","y","y_bits","x","x_bits","pos_bits"] if c in df_dec.columns]
    df_dec.to_csv(out_csv_path, index=False, columns=cols or None)
    print(f"Decrypted NEQR CSV -> {out_csv_path.resolve()}")

if __name__ == "__main__":
    main()