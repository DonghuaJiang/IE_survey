# neqr_qiskit_256_encrypt_cnot.py
# pip install qiskit pandas numpy

from pathlib import Path
import numpy as np
import pandas as pd
from qiskit import QuantumCircuit, QuantumRegister
from qiskit.circuit.library import MCXGate

PROJECT_DIR = Path("/Users/shahbaz/Python_projects/neqr_demo")
CSV_PATH = PROJECT_DIR / "houses_256_neqr_terms.csv"

# --- Register sizes ---
# We keep the image layout: grayscale g(8), position y(8), x(8)
# and ADD a quantum key register k(8) for CNOT-based XOR.
Q_GRAY = 8
Q_Y    = 8
Q_X    = 8
Q_KEY  = 8

def bits(val_or_str, width: int) -> str:
    """Return zero-padded binary string of length `width`."""
    return format(int(val_or_str), f"0{width}b")

def apply_address_match_controls(qc: QuantumCircuit, yreg, xreg, y_val: int, x_val: int):
    """
    Prepare all-ones controls for MCX:
      For each address bit that should be 0, temporarily apply X so the
      MCX (which triggers on '1') activates only at address (y_val, x_val).
    """
    flips = []
    y_bits = bits(y_val, Q_Y)
    x_bits = bits(x_val, Q_X)

    for i, b in enumerate(y_bits):
        if b == "0":
            qc.x(yreg[i]); flips.append((yreg[i], True))
        else:
            flips.append((yreg[i], False))

    for i, b in enumerate(x_bits):
        if b == "0":
            qc.x(xreg[i]); flips.append((xreg[i], True))
        else:
            flips.append((xreg[i], False))

    return flips

def uncompute_address_match_controls(qc: QuantumCircuit, flips):
    """Undo the temporary X gates applied for address matching."""
    for q, did in reversed(flips):
        if did:
            qc.x(q)

def write_gray_bits_for_pixel(qc: QuantumCircuit, gray_reg, yreg, xreg,
                              y_val: int, x_val: int, gray_val: int):
    """
    Addressed write into NEQR:
    For pixel (y_val, x_val), for each grayscale bit that is 1,
    apply a 16-controlled X (controls = y||x) on the corresponding gray qubit.
    """
    if gray_val == 0:
        return

    flips = apply_address_match_controls(qc, yreg, xreg, y_val, x_val)
    controls = list(yreg) + list(xreg)

    # MSB at gray_reg[0], LSB at gray_reg[7]
    for k in range(Q_GRAY):
        if (gray_val >> (Q_GRAY - 1 - k)) & 1:
            mcx = MCXGate(num_ctrl_qubits=len(controls))  # all-ones controls
            qc.append(mcx, controls + [gray_reg[k]])

    uncompute_address_match_controls(qc, flips)

def build_neqr_from_csv(df: pd.DataFrame):
    """
    Build NEQR circuit:
      - Allocate g(8), y(8), x(8)
      - Put Y and X into uniform superposition with H gates
      - For each pixel (y,x), for each gray bit=1, addressed MCX on g[*]
    Returns: (qc, q_gray, q_y, q_x)
    """
    # Allocate image registers
    q_gray = QuantumRegister(Q_GRAY, "g")
    q_y    = QuantumRegister(Q_Y,    "y")
    q_x    = QuantumRegister(Q_X,    "x")

    # NOTE: we won't add the key register here yet; we add it in main() so
    #       the image build is identical to your previous pipeline.
    qc = QuantumCircuit(q_gray, q_y, q_x, name="NEQR_256")

    # Position superposition (16 H gates → 1/2^8 factor)
    for qb in q_y: qc.h(qb)
    for qb in q_x: qc.h(qb)

    # Ensure numeric y, x, gray exist
    df = df.copy()
    if "y" not in df.columns or "x" not in df.columns:
        if "pos_bits" not in df.columns:
            raise ValueError("CSV must have columns y,x or pos_bits to derive them.")
        L = len(str(df["pos_bits"].iloc[0]))
        n = L // 2
        df["y"] = df["pos_bits"].str.slice(0, n).apply(lambda b: int(b, 2))
        df["x"] = df["pos_bits"].str.slice(n, L).apply(lambda b: int(b, 2))

    if "gray" not in df.columns:
        if "gray_bits" not in df.columns:
            raise ValueError("CSV must have gray or gray_bits to derive grayscale values.")
        df["gray"] = df["gray_bits"].apply(lambda b: int(b, 2))

    # Addressed writes (this is the heavy part)
    for y_val, df_row in df.groupby("y", sort=True):
        for _, r in df_row.iterrows():
            x_val  = int(r["x"])
            g_val  = int(r["gray"])
            write_gray_bits_for_pixel(qc, q_gray, q_y, q_x, int(y_val), x_val, g_val)

    return qc, q_gray, q_y, q_x

def prepare_quantum_key_register(qc: QuantumCircuit, key_reg, key_byte: int):
    """
    Prepare the quantum key register |k> in a computational-basis pattern
    that encodes the classical 8-bit key.
      - If key bit i == 1, we apply X to key_reg[i].
      - Bit order: MSB at index 0, LSB at index 7 (matches grayscale order).
    """
    for i in range(Q_KEY):
        if (key_byte >> (Q_KEY - 1 - i)) & 1:
            qc.x(key_reg[i])

def xor_with_key_via_cnot(qc: QuantumCircuit, key_reg, gray_reg):
    """
    Perform quantum XOR of the grayscale with the key register via CNOT:
      CX(key[i] -> gray[i]) for i in 0..7
    This implements: |g> -> |g XOR k>
    """
    for i in range(Q_KEY):
        qc.cx(key_reg[i], gray_reg[i])

def main():
    # Load NEQR terms CSV
    df = pd.read_csv(CSV_PATH, dtype=str)
    # Cast numeric columns if present
    for col in ["gray", "y", "x"]:
        if col in df.columns:
            df[col] = pd.to_numeric(df[col], errors="coerce")

    # Build NEQR circuit (image registers only)
    qc, q_gray, q_y, q_x = build_neqr_from_csv(df)

    # --- Add a quantum key register (8 qubits) and append to the circuit ---
    q_key = QuantumRegister(Q_KEY, "k")  # quantum key
    qc.add_register(q_key)

    # 1) Prepare the quantum key state |k> from a classical 8-bit pattern
    KEY = 0xA6  # example key: 0b1010_0110
    prepare_quantum_key_register(qc, q_key, KEY)

    # 2) XOR = CNOTs from key to grayscale: |g> -> |g XOR k>
    xor_with_key_via_cnot(qc, q_key, q_gray)

    # Save circuit (QPY format)
    out_qpy = PROJECT_DIR / "neqr_256_encrypted_cnot.qpy"
    try:
        from qiskit import qpy
        with open(out_qpy, "wb") as f:
            qpy.dump(qc, f)
        print(f"Saved circuit (CNOT-XOR): {out_qpy}")
    except Exception as e:
        print("Could not save QPY:", e)

    # Optional: simulate to spot-check a few addresses (heavy; 24+8=32 qubits if key is kept).
    # Tip: For a light check, temporarily *remove* the key register or measure/discard it,
    # or build NEQR for a small subset first.

if __name__ == "__main__":
    main()