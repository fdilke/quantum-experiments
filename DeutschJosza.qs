    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Logical;    
    
    //////////////////////////////////////////////////////////////////
    // Part I. Oracles
    //////////////////////////////////////////////////////////////////
    
    // Task 1.1. f(x) = 0
    // Inputs:
    //      1) N qubits in arbitrary state |x⟩ (input register)
    //      2) a qubit in arbitrary state |y⟩ (output qubit)
    // Goal: transform state |x, y⟩ into state |x, y ⊕ f(x)⟩ (⊕ is addition modulo 2).
    operation Oracle_Zero_Reference (x : Qubit[], y : Qubit) : Unit is Adj {
        // Since f(x) = 0 for all values of x, |y ⊕ f(x)⟩ = |y⟩.
        // This means that the operation doesn't need to do any transformation to the inputs.
        // Build the project and run the tests to see that T01_Oracle_Zero test passes.
    }
    
    
    // Task 1.2. f(x) = 1
    // Inputs:
    //      1) N qubits in arbitrary state |x⟩ (input register)
    //      2) a qubit in arbitrary state |y⟩ (output qubit)
    // Goal: transform state |x, y⟩ into state |x, y ⊕ f(x)⟩ (⊕ is addition modulo 2).
    operation Oracle_One_Reference (x : Qubit[], y : Qubit) : Unit is Adj {
        // Since f(x) = 1 for all values of x, |y ⊕ f(x)⟩ = |y ⊕ 1⟩ = |NOT y⟩.
        // This means that the operation needs to flip qubit y (i.e. transform |0⟩ to |1⟩ and vice versa).
        X(y);
    }
    
   
    // Task 1.3. f(x) = xₖ (the value of k-th qubit)
    // Inputs:
    //      1) N qubits in arbitrary state |x⟩ (input register)
    //      2) a qubit in arbitrary state |y⟩ (output qubit)
    //      3) 0-based index of the qubit from input register (0 <= k < N)
    // Goal: transform state |x, y⟩ into state |x, y ⊕ xₖ⟩ (⊕ is addition modulo 2).
    operation Oracle_Kth_Qubit_Reference (x : Qubit[], y : Qubit, k : Int) : Unit is Adj {        
//        EqualityFactB(0 <= k and k < Length(x), true, "k should be between 0 and N-1, inclusive");
        CNOT(x[k], y);
    }
    
    
    // Task 1.4. f(x) = 1 if x has odd number of 1s, and 0 otherwise
    // Inputs:
    //      1) N qubits in arbitrary state |x⟩ (input register)
    //      2) a qubit in arbitrary state |y⟩ (output qubit)
    // Goal: transform state |x, y⟩ into state |x, y ⊕ f(x)⟩ (⊕ is addition modulo 2).
    operation Oracle_OddNumberOfOnes_Reference (x : Qubit[], y : Qubit) : Unit is Adj {       
        // Hint: f(x) can be represented as x_0 ⊕ x_1 ⊕ ... ⊕ x_(N-1)
        for q in x {
            CNOT(q, y);
        }
        // alternative solution: ApplyToEachA(CNOT(_, y), x);
    }
    
    
    // Task 1.5. f(x) = Σᵢ 𝑟ᵢ 𝑥ᵢ modulo 2 for a given bit vector r (scalar product function)
    // Inputs:
    //      1) N qubits in arbitrary state |x⟩ (input register)
    //      2) a qubit in arbitrary state |y⟩ (output qubit)
    //      3) a bit vector of length N represented as Int[]
    // You are guaranteed that the qubit array and the bit vector have the same length.
    // Goal: transform state |x, y⟩ into state |x, y ⊕ f(x)⟩ (⊕ is addition modulo 2).
    
    // Note: the functions featured in tasks 1.1, 1.3 and 1.4 are special cases of this function.
    operation Oracle_ProductFunction_Reference (x : Qubit[], y : Qubit, r : Int[]) : Unit is Adj {        
        // The following line enforces the constraint on the input arrays.
        // You don't need to modify it. Feel free to remove it, this won't cause your code to fail.
//        EqualityFactI(Length(x), Length(r), "Arrays should have the same length");
            
        for i in IndexRange(x) {
            if r[i] == 1 {
                CNOT(x[i], y);
            }
        }
    }

    /// # Summary
    /// Given two operations, applies one as conjugated with the other.
    ///
    /// # Description
    /// Given two operations, respectively described by unitary operators $U$
    /// and $V$, applies them in the sequence $U^{\dagger} V U$. That is,
    /// this operation implements the unitary operator given by $V$ conjugated
    /// with $U$.
    ///
    /// # Input
    /// ## outerOperation
    /// The operation $U$ that should be used to conjugate $V$. Note that the
    /// outer operation $U$ needs to be adjointable, but does not
    /// need to be controllable.
    /// ## innerOperation
    /// The operation $V$ being conjugated.
    /// ## target
    /// The input to be provided to the outer and inner operations.
    ///
    /// # Type Parameters
    /// ## 'T
    /// The target on which each of the inner and outer operations act.
    ///
    /// # Remarks
    /// The outer operation is always assumed to be adjointable, but does not
    /// need to be controllable in order for the combined operation to be
    /// controllable.
    ///
    /// # See Also
    /// - Microsoft.Quantum.Canon.ApplyWith
    /// - Microsoft.Quantum.Canon.ApplyWithA
    /// - Microsoft.Quantum.Canon.ApplyWithC
    operation ApplyWithCA<'T>(outerOperation : ('T => Unit is Adj), innerOperation : ('T => Unit is Adj + Ctl), target : 'T) : Unit {
        body (...) {
            outerOperation(target);
            innerOperation(target);
            Adjoint outerOperation(target);
        }

        adjoint auto;

        controlled (controlRegister, ...) {
            outerOperation(target);
            Controlled innerOperation(controlRegister, target);
            Adjoint outerOperation(target);
        }

        controlled adjoint auto;
    }

    /// # Summary
    /// Applies a unitary operator on the target register if the control register state corresponds to a specified bit mask.
    ///
    /// # Input
    /// ## bits
    /// Boolean array.
    /// ## oracle
    /// Unitary operator.
    /// ## targetRegister
    /// Quantum register acted on by `oracle`.
    /// ## controlRegister
    /// Quantum register that controls application of `oracle`.
    ///
    /// # Remarks
    /// The length of `bits` and `controlRegister` must be equal.
    /// For example, `bits = [0,1,0,0,1]` means that `oracle` is applied if and only if `controlRegister`" is in the state $\ket{0}\ket{1}\ket{0}\ket{0}\ket{1}$.
    operation ControlledOnBitStringImpl<'T> (bits : Bool[], oracle : ('T => Unit is Adj + Ctl), controlRegister : Qubit[], targetRegister : 'T) : Unit
    {
        body (...)
        {
            ApplyWithCA(ApplyPauliFromBitString(PauliX, false, bits, _), Controlled oracle(_, targetRegister), controlRegister);
        }
        
        adjoint invert;
        controlled distribute;
        controlled adjoint distribute;
    }

    /// # Summary
    /// Returns a unitary operator that applies an oracle on the target register if the control register state corresponds to a specified bit mask.
    ///
    /// # Input
    /// ## bits
    /// Boolean array.
    /// ## oracle
    /// Unitary operator.
    ///
    /// # Output
    /// A unitary operator that applies `oracle` on the target register if the control register state corresponds to the bit mask `bits`.
    function ControlledOnBitString<'T> (bits : Bool[], oracle : ('T => Unit is Adj + Ctl)) : ((Qubit[], 'T) => Unit is Adj + Ctl)
    {
        return ControlledOnBitStringImpl(bits, oracle, _, _);
    }

 operation ControlledOnIntImpl<'T> (numberState : Int, oracle : ('T => Unit is Adj + Ctl), controlRegister : Qubit[], targetRegister : 'T) : Unit
    {
        body (...)
        {
            let bits = IntAsBoolArray(numberState, Length(controlRegister));
            (ControlledOnBitString(bits, oracle))(controlRegister, targetRegister);
        }
        
        adjoint invert;
        controlled distribute;
        controlled adjoint distribute;
    }
    
    
    /// # Summary
    /// Returns a unitary operator that applies an oracle on the target register if the control register state corresponds to a specified positive integer.
    ///
    /// # Input
    /// ## numberState
    /// Positive integer.
    /// ## oracle
    /// Unitary operator.
    ///
    /// # Output
    /// A unitary operator that applies `oracle` on the target register if the control register state corresponds to the number state `numberState`.
    function ControlledOnInt<'T> (numberState : Int, oracle : ('T => Unit is Adj + Ctl)) : ((Qubit[], 'T) => Unit is Adj + Ctl)
    {
        return ControlledOnIntImpl(numberState, oracle, _, _);
    }    
    
    // Task 1.6. f(x) = Σᵢ (𝑟ᵢ 𝑥ᵢ + (1 - 𝑟ᵢ)(1 - 𝑥ᵢ)) modulo 2 for a given bit vector r
    // Inputs:
    //      1) N qubits in arbitrary state |x⟩ (input register)
    //      2) a qubit in arbitrary state |y⟩ (output qubit)
    //      3) a bit vector of length N represented as Int[]
    // You are guaranteed that the qubit array and the bit vector have the same length.
    // Goal: transform state |x, y⟩ into state |x, y ⊕ f(x)⟩ (⊕ is addition modulo 2).
    operation Oracle_ProductWithNegationFunction_Reference (x : Qubit[], y : Qubit, r : Int[]) : Unit is Adj {
        // The following line enforces the constraint on the input arrays.
        // You don't need to modify it. Feel free to remove it, this won't cause your code to fail.
//        EqualityFactI(Length(x), Length(r), "Arrays should have the same length");
            
        for i in IndexRange(x) {
            if r[i] == 1 {
                CNOT(x[i], y);
            } else {
                // do a 0-controlled NOT
                (ControlledOnInt(0, X))([x[i]], y);
            }
        }
    }
    
    
    // Task 1.7. f(x) = Σᵢ 𝑥ᵢ + (1 if prefix of x is equal to the given bit vector, and 0 otherwise) modulo 2
    // Inputs:
    //      1) N qubits in arbitrary state |x⟩ (input register)
    //      2) a qubit in arbitrary state |y⟩ (output qubit)
    //      3) a bit vector of length P represented as Int[] (1 <= P <= N)
    // Goal: transform state |x, y⟩ into state |x, y ⊕ f(x)⟩ (⊕ is addition modulo 2).
    
    // A prefix of length k of a state |x⟩ = |x₁, ..., xₙ⟩ is the state of its first k qubits |x₁, ..., xₖ⟩.
    // For example, a prefix of length 2 of a state |0110⟩ is 01.
    operation Oracle_HammingWithPrefix_Reference (x : Qubit[], y : Qubit, prefix : Int[]) : Unit is Adj {        
        // The following line enforces the constraint on the input arrays.
        // You don't need to modify it. Feel free to remove it, this won't cause your code to fail.
        let P = Length(prefix);
//        EqualityFactB(1 <= P and P <= Length(x), true, "P should be between 1 and N, inclusive");
            
        // Hint: the first part of the function is the same as in task 1.4
        for q in x {
            CNOT(q, y);
        }
            
        // add check for prefix as a multi-controlled NOT
        // true bits of r correspond to 1-controls, false bits - to 0-controls
        within {
            for i in 0 .. P - 1 {
                    
                if prefix[i] == 0 {
                    X(x[i]);
                }
            }
        } apply {
            Controlled X(x[0 .. P - 1], y);
        }
    }
    
    
    // Task 1.8*. f(x) = 1 if x has two or three bits (out of three) set to 1, and 0 otherwise  (majority function)
    // Inputs:
    //      1) 3 qubits in arbitrary state |x⟩ (input register)
    //      2) a qubit in arbitrary state |y⟩ (output qubit)
    // Goal: transform state |x, y⟩ into state |x, y ⊕ f(x)⟩ (⊕ is addition modulo 2).
    operation Oracle_MajorityFunction_Reference (x : Qubit[], y : Qubit) : Unit is Adj {        
        // The following line enforces the constraint on the input array.
        // You don't need to modify it. Feel free to remove it, this won't cause your code to fail.
//        EqualityFactB(3 == Length(x), true, "x should have exactly 3 qubits");
            
        // f(x) can be represented in terms of AND and ⊕ operations as follows:
        // f(x) = (x₀ AND x₁) ⊕ (x₀ AND x₂) ⊕ (x₁ AND x₂)
        CCNOT(x[0], x[1], y);
        CCNOT(x[0], x[2], y);
        CCNOT(x[1], x[2], y);
    }  
    

    //////////////////////////////////////////////////////////////////
    // Part II. Deutsch-Jozsa Algorithm
    //////////////////////////////////////////////////////////////////

    // Task 2.1. State preparation for Deutsch-Jozsa (or Bernstein-Vazirani) algorithm
    // Inputs:
    //      1) N qubits in |0⟩ state (query register)
    //      2) a qubit in |0⟩ state (answer register)
    // Goal:
    //      1) prepare an equal superposition of all basis vectors from |0...0⟩ to |1...1⟩ on query register
    //         (i.e. state (|0...0⟩ + ... + |1...1⟩) / sqrt(2^N) )
    //      2) prepare |-⟩ state (|-⟩ = (|0⟩ - |1⟩) / sqrt(2)) on answer register
    operation DJ_StatePrep_Reference (query : Qubit[], answer : Qubit) : Unit is Adj {        
        ApplyToEachA(H, query);
        X(answer);
        H(answer);
    }
    
    // Task 2.2. Deutsch-Jozsa algorithm implementation
    // Inputs:
    //      1) the number of qubits in the input register N for the function f
    //      2) a quantum operation which implements the oracle |x⟩|y⟩ -> |x⟩|y ⊕ f(x)⟩, where
    //         x is N-qubit input register, y is 1-qubit answer register, and f is a Boolean function
    // You are guaranteed that the function f implemented by the oracle is either
    // constant (returns 0 on all inputs or 1 on all inputs) or
    // balanced (returns 0 on exactly one half of the input domain and 1 on the other half).
    // Output:
    //      true if the function f is constant
    //      false if the function f is balanced
    
    // Note: a trivial approach is to call the oracle multiple times:
    //       if the values for more than half of the possible inputs are the same, the function is constant.
    // Quantum computing allows to perform this task in just one call to the oracle; try to implement this algorithm.
    operation DJ_Algorithm_Reference (N : Int, Uf : ((Qubit[], Qubit) => Unit)) : Bool {
        
        // Declare variable in which the result will be accumulated;
        // this variable has to be mutable to allow updating it.
        mutable isConstantFunction = true;
    
        // allocate N qubits for input register and 1 qubit for output
        use (x, y) = (Qubit[N], Qubit());

        // prepare qubits in the right state
        DJ_StatePrep_Reference(x, y);

        // apply oracle
        Uf(x, y);
            
        // apply Hadamard to each qubit of the input register
        ApplyToEach(H, x);
            
        // measure all qubits of the input register;
        // the result of each measurement is converted to an Int
        for i in 0 .. N - 1 {
            if M(x[i]) != Zero {
                set isConstantFunction = false;
            }
        }
            
        // before releasing the qubits make sure they are all in |0⟩ state
        Reset(y);
        
        return isConstantFunction;
    }

    operation theFn(qubits: Qubit[], retVal: Qubit) : Unit {
        Reset(retVal);
    }

    @EntryPoint()
    operation Main() : Bool {
        let nQubits = 3;
        Message($"Running DJ_Algorithm: {nQubits}");
        
        // Use Grover's algorithm to find a particular marked state.
        let results = DJ_Algorithm_Reference(nQubits, theFn);
        return results;
    }


    //////////////////////////////////////////////////////////////////
    // Part III. Bernstein-Vazirani Algorithm
    //////////////////////////////////////////////////////////////////  
    
    // Task 3.1. Bernstein-Vazirani algorithm implementation
    // Inputs:
    //      1) the number of qubits in the input register N for the function f
    //      2) a quantum operation which implements the oracle |x⟩|y⟩ -> |x⟩|y ⊕ f(x)⟩, where
    //         x is N-qubit input register, y is 1-qubit answer register, and f is a Boolean function
    // You are guaranteed that the function f implemented by the oracle is a scalar product function
    // (can be represented as f(𝑥₀, …, 𝑥ₙ₋₁) = Σᵢ 𝑟ᵢ 𝑥ᵢ modulo 2 for some bit vector r = (𝑟₀, …, 𝑟ₙ₋₁)).
    // You have implemented the oracle implementing the scalar product function in task 1.5.
    // Output:
    //      A bit vector r reconstructed from the function
    
    // Note: a trivial approach is to call the oracle N times:
    //       |10...0⟩|0⟩ = |10...0⟩|r₀⟩, |010...0⟩|0⟩ = |010...0⟩|r₁⟩ and so on.
    // Quantum computing allows to perform this task in just one call to the oracle; try to implement this algorithm.
    operation BV_Algorithm_Reference (N : Int, Uf : ((Qubit[], Qubit) => Unit)) : Int[] {
                
        // allocate N qubits for input register and 1 qubit for output
        use (x, y) = (Qubit[N], Qubit());
            
        // prepare qubits in the right state
        DJ_StatePrep_Reference(x, y);
            
        // apply oracle
        Uf(x, y);
            
        // apply Hadamard to each qubit of the input register
        ApplyToEach(H, x);
            
        // measure all qubits of the input register;
        // the result of each measurement is converted to an Int
        mutable r = [0, size = N];
        for i in 0 .. N - 1 {
            if M(x[i]) != Zero {
                set r w/= i <- 1;
            }
        }
            
        // before releasing the qubits make sure they are all in |0⟩ state
        Reset(y);
        return r;
    }
    
    
    //////////////////////////////////////////////////////////////////
    // Part IV. Come up with your own algorithm!
    //////////////////////////////////////////////////////////////////
    
    // Task 4.1. Reconstruct the oracle from task 1.6
    // Inputs:
    //      1) the number of qubits in the input register N for the function f
    //      2) a quantum operation which implements the oracle |x⟩|y⟩ -> |x⟩|y ⊕ f(x)⟩, where
    //         x is N-qubit input register, y is 1-qubit answer register, and f is a Boolean function
    // You are guaranteed that the function f implemented by the oracle can be represented as
    // f(𝑥₀, …, 𝑥ₙ₋₁) = Σᵢ (𝑟ᵢ 𝑥ᵢ + (1 - 𝑟ᵢ)(1 - 𝑥ᵢ)) modulo 2 for some bit vector r = (𝑟₀, …, 𝑟ₙ₋₁).
    // You have implemented the oracle implementing this function in task 1.6.
    // Output:
    //      A bit vector r which generates the same oracle as the one you are given
    operation Noname_Algorithm_Reference (N : Int, Uf : ((Qubit[], Qubit) => Unit)) : Int[] {
                
        use (x, y) = (Qubit[N], Qubit());
        // apply oracle to qubits in all 0 state
        Uf(x, y);
            
        // f(x) = Σᵢ (𝑟ᵢ 𝑥ᵢ + (1 - 𝑟ᵢ)(1 - 𝑥ᵢ)) = 2 Σᵢ 𝑟ᵢ 𝑥ᵢ + Σᵢ 𝑟ᵢ + Σᵢ 𝑥ᵢ + N = Σᵢ 𝑟ᵢ + N
        // remove the N from the expression
        if N % 2 == 1 {
            X(y);
        }
            
        // now y = Σᵢ 𝑟ᵢ
            
        // Declare an Int array in which the result will be stored;
        // the variable has to be mutable to allow updating it.
        mutable r = [0, size = N];

        // measure the output register
        let m = M(y);
        if m == One {
            // adjust parity of bit vector r
            set r w/= 0 <- 1;
        }
            
        return r;
    }