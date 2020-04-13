# XOR-SAT formulas and p-spin Ising model
This was produced as a project for a university course in Fall '19. 
It is based on [M. Mézard, F. Ricci-Tersenghi, R. Zecchina, *Two Solutions to Diluted p-Spin Models
and XORSAT Problems*, Journal of Statistical Physics, 2003](http://chimera.roma1.infn.it/FEDERICO/Publications_files/2003_JSP_111_505.pdf).
Belief Propagation equations are implemented in their Min-Sum form to look for solutions to XOR-SAT instances drawn from a random ensemble. The problem is equivalent to that of finding the Ground State for a $p$-spin Ising model, i.e. an Ising model where spins interact not in pairs but in $p$-uples.
A brief explanation of the main results follows

### Leaf Removal algorithm
 Recursively remove from the hypergraph all leaves and the hyperedges they are attached to, until there is none left. The subgraph resulting at the end, called *core*, is the frozen part of the graph, formed by those variable whose value is forced by the rigidness of the system.
 - **Dynamic transition**: The core size undergoes a first order phase transition at some density around 0.82 (for p=3), where it jumps to a value extensive with the number of variables N. 
 - **SAT/UNSAT transition**: Around 0.92 (for p=3),  the core contains more constraints than variables.
 ![core](https://github.com/stecrotti/xorsat/blob/master/images/core.png?raw=true "core")
 
 ### Energy
 Energy in the p-spin Ising model corresponds to the number of unsatisfied constraints in the XOR-SAT formula. 
 


<!--stackedit_data:
eyJoaXN0b3J5IjpbLTY2MTM3Mjk1NCwtMjA5Njc4OTIyMCwxMD
U5ODkyOTUwLDIwODM2NzQ5MywxMDI1ODU1NzM1XX0=
-->