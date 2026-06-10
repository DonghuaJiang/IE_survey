# draw_neqr_24q_onepixel_fullgray.py
# Shows a *complete* NEQR "addressed write" for one pixel
# with grayscale value = 255 (0b11111111),
# so that all 8 grayscale qubits are active.
#
# pip install qiskit matplotlib pandas numpy

from pathlib import Path
import pandas as pd
from qiskit import QuantumCircuit, QuantumRegister
from qiskit.circuit.library import MCXGate

PROJECT_DIR = Path("/Users/shahbaz/Python_projects/neqr_demo")
CSV_PATH     = PROJECT_DIR / "houses_256_neqr_terms.csv"
OUT_PNG      = PROJECT_DIR / "diagram_neqr_24q_onepixel_fullgray.png"

Q_GRAY = 8
Q_Y    = 8
Q_X    = 8

def bits(v, w): 
    return format(int(v), f"0{w}b")

def apply_addr_mask(qc: QuantumCircuit, yreg, xreg, yv: int, xv: int):
    """
    Make MCX ("all-ones" controls) trigger exactly for address (yv, xv).
    Flip address qubits that should be 0 before MCX, and unflip after.
    """
    flips = []
    yb = bits(yv, Q_Y)
    xb = bits(xv, Q_X)
    for i, b in enumerate(yb):
        if b == "0":
            qc.x(yreg[i]); flips.append((yreg[i], True))
        else:
            flips.append((yreg[i], False))
    for i, b in enumerate(xb):
        if b == "0":
            qc.x(xreg[i]); flips.append((xreg[i], True))
        else:
            flips.append((xreg[i], False))
    return flips

def unmask(qc: QuantumCircuit, flips):
    for q, do in reversed(flips):
        if do:
            qc.x(q)

def write_pixel(qc: QuantumCircuit, g, y, x, yv: int, xv: int, gv: int):
    """
    Addressed write:
    For each '1' bit in gray value gv, append a 16-controlled X with controls=y||x
    and target=g[k]. MSB is g[0], LSB is g[7].
    """
    if gv == 0:
        return
    flips = apply_addr_mask(qc, y, x, yv, xv)
    ctr = list(y) + list(x)
    for k in range(Q_GRAY):
        if (gv >> (Q_GRAY - 1 - k)) & 1:
            qc.append(MCXGate(len(ctr)), ctr + [g[k]])
    unmask(qc, flips)

def main():
    # Allocate registers
    g = QuantumRegister(Q_GRAY, "g")
    y = QuantumRegister(Q_Y,    "y")
    x = QuantumRegister(Q_X,    "x")
    qc = QuantumCircuit(g, y, x, name="NEQR_256_ONEPIXEL_FULLGRAY")

    # Step 1: Create uniform superposition of addresses
    for qb in y: qc.h(qb)
    for qb in x: qc.h(qb)
    qc.barrier(label="addr superposition")

    # Step 2: Manually select one pixel (y=0, x=0) and set gray=255 (11111111)
    y_sel, x_sel, gv = 0, 0, 255
    print(f"Using pixel (y={y_sel}, x={x_sel}) with gray={gv} (bits {bits(gv,8)})")

    # Step 3: Write intensity using 16-controlled X for each gray bit=1
    write_pixel(qc, g, y, x, y_sel, x_sel, gv)
    qc.barrier(label="NEQR addressed write")

    # Step 4: Check operations summary
    try:
        print("Ops count:", qc.count_ops())
    except Exception:
        pass

    # Step 5: Draw and save
    fig = qc.draw(output="mpl", idle_wires=False)
    fig.savefig(OUT_PNG, dpi=200, bbox_inches="tight")
    print(f"✅ Saved full NEQR diagram (24q, all gray bits active): {OUT_PNG}")

if __name__ == "__main__":
    main()