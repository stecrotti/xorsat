# XOR-SAT formulas and p-spin Ising model
This was produced as a project for a university course in Fall '19. 
It is based on [M. Mézard, F. Ricci-Tersenghi, R. Zecchina, *Two Solutions to Diluted p-Spin Models
and XORSAT Problems*, Journal of Statistical Physics, 2003](http://chimera.roma1.infn.it/FEDERICO/Publications_files/2003_JSP_111_505.pdf).
Belief Propagation equations are implemented in their Min-Sum form to look for solutions to XOR-SAT instances drawn from a random ensemble. The problem is equivalent to that of finding the Ground State for a p-spin Ising model, i.e. an Ising model where spins interact not in pairs but in p-uples.
A brief explanation of the main results follows

### Phase transitions
Call *density* the ratio of number of constraints and number of variables. It can b
 - **Dynamic transition**: The core size undergoes a first order phase transition at some density around 0.82 (for p=3), where it jumps to a value extensive with the number of variables N. 
 - **SAT/UNSAT transition**: Around 0.92 (for p=3),  the core contains more constraints than variables and the probability of satisfiability becomes exponentially small.

 ### Energy
 Energy in the p-spin Ising model corresponds to the number of unsatisfied constraints in the XOR-SAT formula. Belief Propagation is able to find solutions only up to the dynamic transition around 0.82, above which more sophisticated techniques like Survey Propagation are needed.
 ![energy](https://github.com/stecrotti/xorsat/blob/master/images/energy.png?raw=true  "Energy")
 
 ### Leaf Removal algorithm
 Recursively remove from the hypergraph all leaves and the hyperedges they are attached to, until there is none left. The subgraph resulting at the end, called *core*, is the frozen part of the graph, formed by those variable whose value is forced by the rigidness of the system.

 ![core](https://github.com/stecrotti/xorsat/blob/master/images/core.png?raw=true "Core")
 
  
 


<!--stackedit_data:
eyJoaXN0b3J5IjpbLTMzMTE0MzE4NCwxMTI0MzM0NjMxLC05NT
U4MDU4NDEsLTIwOTY3ODkyMjAsMTA1OTg5Mjk1MCwyMDgzNjc0
OTMsMTAyNTg1NTczNV19
-->