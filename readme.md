# XOR-SAT formulas and p-spin Ising model
This was produced as a project for a university course in Fall '19. 
It is based on [M. Mézard, F. Ricci-Tersenghi, R. Zecchina, *Two Solutions to Diluted p-Spin Models
and XORSAT Problems*, Journal of Statistical Physics, 2003](http://chimera.roma1.infn.it/FEDERICO/Publications_files/2003_JSP_111_505.pdf).
Belief Propagation equations are implemented in their Min-Sum form to look for solutions to XOR-SAT instances drawn from a random ensemble. The problem is equivalent to that of finding the Ground State for a $p$-spin Ising model, i.e. an Ising model where spins interact not in pairs but in $p$-uples.
A brief explanation of the main results follows

### Leaf Removal algorithm
 Recursively remove from the hypergraph all leaves and the hyperedges they are attached to, until there is none left. The subgraph resulting at the end, called *core*, is the frozen part of the graph, formed by those variable whose value is forced by the rigidness of the system.
 The core size undergoes a first order phase transition at some density around 0.82 (for p=3), where it jumps to a value extensive w.r.t. N. Around 0.92 (for p=3), the SAT/UNSAT transition takes place

<!--stackedit_data:
eyJoaXN0b3J5IjpbLTE3MDAxNzk5MzEsLTIwOTY3ODkyMjAsMT
A1OTg5Mjk1MCwyMDgzNjc0OTMsMTAyNTg1NTczNV19
-->