# draw_xor_cnot_8bit.py
from pathlib import Path
from qiskit import QuantumCircuit, QuantumRegister

PROJECT_DIR = Path("/Users/shahbaz/Python_projects/neqr_demo")
OUT_PNG     = PROJECT_DIR / "diagram_xor_cnot_8bit.png"

def build_xor_cnot(key_byte: int):
    qk = QuantumRegister(8,"k")
    qg = QuantumRegister(8,"g")
    qc = QuantumCircuit(qk,qg, name="XOR_CNOT_8BIT")

    # prepare |k> as classical pattern (X on 1-bits; MSB at k[0])
    for i in range(8):
        if (key_byte>>(7-i)) & 1:
            qc.x(qk[i])

    qc.barrier()

    # CNOTs: key -> grayscale (quantum XOR)
    for i in range(8):
        qc.cx(qk[i], qg[i])

    return qc

def main():
    KEY=0xA6
    qc = build_xor_cnot(KEY)
    fig = qc.draw(output="mpl", idle_wires=False)
    fig.savefig(OUT_PNG, dpi=200, bbox_inches="tight")
    print(f"Saved XOR (CNOT) diagram: {OUT_PNG}")

if __name__=="__main__":
    main()