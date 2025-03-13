 import Microsoft.Quantum.Diagnostics.*;
 
    @EntryPoint()
    operation Main() : (Result, Result) {
        // Your entanglement code goes here.
        // allocate 2 qubits which will be in the 0 state by default.
        use (q1, q2) = (Qubit(), Qubit());
        // apply the Hadamard operation to put q1 into a Schrodinger's cat state: 50% chance of being |0> or |1>
        H(q1);
        // it's now ( |0> + |1> )/sqrt(2)
        // Entangle q1 and q2, making q2 depend on q1.
        CNOT(q1, q2);        
        // both are now the Bell pair, ( |00> + |11> )/sqrt(2)
        // Show the entangled state of the qubits.
        DumpMachine();        
        // DO an observation (measurement) of the qubits, collapsing the wave function
        let (m1, m2) = (M(q1), M(q2));
        // Reset q1 and q2 to the 0 state.
        Reset(q1);
        Reset(q2);
        // return the measurement
        return (m1, m2);                
    }

