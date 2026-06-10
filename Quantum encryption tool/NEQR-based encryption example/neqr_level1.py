from PIL import Image       # load/convert/resize images
import numpy as np          # fast arrays and maths
import pandas as pd         # nice tables (DataFrame) + CSV export
from pathlib import Path    # safe file paths
from math import log2       # log base 2
import argparse             # read --image etc. from command line

def int_to_bits(x, bits):   # integers → fixed-width bit strings
    return format(int(x), f"0{bits}b")

# Load an image from `path`, convert to 8-bit grayscale,
# resize to `target_size` (must be power-of-two square), return as np.ndarray

def load_grayscale_power_of_two(path: Path, target_size=(256, 256)) -> np.ndarray:
    img = Image.open(path).convert("L")  # 8-bit grayscale
    if img.size != target_size:
        img = img.resize(target_size, Image.NEAREST)
    arr = np.array(img, dtype=np.uint8)
    h, w = arr.shape
    assert h == w and (h & (h - 1) == 0), "Image must be square with power-of-two size."
    return arr

# NEQRImage class: holds image and provides methods to extract NEQR terms
class NEQRImage:
    def __init__(self, img: np.ndarray, q: int = 8): #Build one NEQR “term” per pixel  
        self.img = img
        self.q = q
        self.n = int(log2(img.shape[0]))
        assert img.shape == (2**self.n, 2**self.n), "Image must be 2^n by 2^n."
        self.size = 2**self.n
        self.amplitude = 1 / (2**self.n)

    # (amplitude, gray_bits, pos_bits) for each pixel
    def pixel_entry(self, y: int, x: int): #Get NEQR term for pixel at (y,x)
        gray_bits = int_to_bits(self.img[y, x], self.q)
        y_bits = int_to_bits(y, self.n)
        x_bits = int_to_bits(x, self.n)
        pos_bits = y_bits + x_bits
        return (self.amplitude, gray_bits, pos_bits)

    # Generator over all NEQR terms
    def iter_terms(self):
        for y in range(self.size):
            for x in range(self.size):
                yield self.pixel_entry(y, x)

    # Export all NEQR terms to a pandas DataFrame
    def to_dataframe(self, include_split_pos=False) -> pd.DataFrame:
        data = []
        for y in range(self.size):
            y_bits = int_to_bits(y, self.n)
            for x in range(self.size):
                x_bits = int_to_bits(x, self.n)
                gray = int(self.img[y, x])
                gray_bits = int_to_bits(gray, self.q)
                pos_bits = y_bits + x_bits
                if include_split_pos:
                    data.append((self.amplitude, gray, gray_bits, y, y_bits, x, x_bits, pos_bits))
                else:
                    data.append((self.amplitude, gray, gray_bits, pos_bits))
        cols = (["amplitude","gray","gray_bits","y","y_bits","x","x_bits","pos_bits"]
                if include_split_pos else ["amplitude","gray","gray_bits","pos_bits"])
        return pd.DataFrame(data, columns=cols)

# Main script
if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--image", default="/Users/shahbaz/houses_256.jpg",
                    help="Path to image (defaults to /Users/shahbaz/houses_256.jpg)")
    parser.add_argument("--csv", action="store_true", help="Export all terms to CSV")
    args = parser.parse_args()

    # Load image and build NEQR representation (print 3 sample terms)
    img_path = Path(args.image)
    img = load_grayscale_power_of_two(img_path, target_size=(256, 256))
    neqr = NEQRImage(img, q=8)

    print("Sample NEQR terms (amp * |gray> |pos>):")
    for i, (amp, gray_bits, pos_bits) in enumerate(neqr.iter_terms()):
        print(f"{amp:.6f} * |{gray_bits}> |{pos_bits}>")
        if i >= 2:  # show first 3
            break

    # Always export the NEQR CSV to your project directory
    df = neqr.to_dataframe(include_split_pos=True)

    # Force output folder to your project directory
    project_dir = Path("/Users/shahbaz/Python_projects/neqr_demo")
    out_path = project_dir / "houses_256_neqr_terms.csv"

    df.to_csv(out_path, index=False)
    print(f"✅ Exported NEQR terms to: {out_path.resolve()}")