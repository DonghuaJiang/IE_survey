# neqr_2x2_qiskit_draw.py
# pip install qiskit matplotlib

from pathlib import Path
from qiskit import QuantumCircuit, QuantumRegister
from qiskit.circuit.library import MCXGate

PROJECT_DIR = Path("/Users/shahbaz/Python_projects/neqr_demo")
OUT_PNG     = PROJECT_DIR / "neqr_2x2_qiskit.png"

# Paper pixels (y,x,gray)
PIXELS = [(0,0,0), (0,1,100), (1,0,200), (1,1,255)]

Q_GRAY, Q_Y, Q_X = 8, 1, 1  # 8-bit gray + 1y + 1x

def write_pixel_msb_to_g7(qc, g, y, x, yv, xv, gv):
    """ MSB→g7 (top), ..., LSB→g0 (bottom). Control-on-0 via X-mask only if gv>0. """
    if gv == 0:
        return
    if yv == 0: qc.x(y[0])
    if xv == 0: qc.x(x[0])
    ctr = [y[0], x[0]]
    for b in range(7, -1, -1):           # b=7..0 -> g[7]..g[0]
        if (gv >> b) & 1:
            qc.append(MCXGate(2), ctr + [g[b]])
    if xv == 0: qc.x(x[0])
    if yv == 0: qc.x(y[0])

def build_neqr_2x2_qc():
    g = QuantumRegister(Q_GRAY, "g")   # created as g[0]..g[7]
    y = QuantumRegister(Q_Y, "y")
    x = QuantumRegister(Q_X, "x")
    qc = QuantumCircuit(g, y, x, name="NEQR_2x2")

    # Step 1: show I on grayscale lines; H on y,x (like the paper)
    for qi in g: qc.id(qi)
    qc.h(y[0]); qc.h(x[0])
    qc.barrier(label="addr superposition")      # single labeled barrier

    # Step 2: four Ω blocks in paper order, each with a single labeled barrier
    for (yv, xv, gv) in [(0,0,0), (0,1,100), (1,0,200), (1,1,255)]:
        qc.barrier(label=f"Ω_{yv}{xv}")        # one barrier, no extras
        write_pixel_msb_to_g7(qc, g, y, x, yv, xv, gv)

    return qc

def main():
    qc = build_neqr_2x2_qc()
    # Draw with paper wire order (top→bottom): g7..g0, y, x
    # Creation indices are g0..g7,y,x → 0..9
    wire_order = [7,6,5,4,3,2,1,0, 8, 9]
    fig = qc.draw(output="mpl",
                  idle_wires=False,
                  wire_order=wire_order,
                  fold=-1,
                  plot_barriers=True)
    PROJECT_DIR.mkdir(parents=True, exist_ok=True)
    fig.savefig(OUT_PNG, dpi=300, bbox_inches="tight")
    print(f"✅ Saved: {OUT_PNG}")

if __name__ == "__main__":
    main()