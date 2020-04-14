# XOR-SAT formulas and p-spin Ising model
This was produced as a project for a university course in Fall '19. 
It is based on [M. Mézard, F. Ricci-Tersenghi, R. Zecchina, *Two Solutions to Diluted p-Spin Models
and XORSAT Problems*, Journal of Statistical Physics, 2003](http://chimera.roma1.infn.it/FEDERICO/Publications_files/2003_JSP_111_505.pdf).

Belief Propagation equations are implemented in their Min-Sum form to look for solutions to XOR-SAT instances drawn from a random ensemble. The problem is equivalent to that of finding the Ground State for a p-spin Ising model (an Ising model where spins interact not in pairs but in p-uples) defined of a factor graph.
A brief explanation of the main results follows
### Leaf Removal algorithm
 Recursively remove from the graph all leaves and the factors (or hyperedges) they are attached to, until there is none left. The subgraph resulting at the end, called *core*, is the frozen part of the graph, formed by those variable whose value is forced by the rigidness of the system.
 Call *density* the ratio of number of constraints and number of variables. As the density varies from 0 to 1 and beyond, the system undergoes two phase transitions
 - **Dynamic transition**: At some density ~0.82 (for p=3), the core size jumps to a value extensive with the number of variables N. 
 - **SAT/UNSAT transition**: From ~0.92 (for p=3) on,  the core contains more constraints than variables and the probability of satisfiability becomes exponentially small. ![core](https://github.com/stecrotti/xorsat/blob/master/images/core.png?raw=true "Core")
 
 ### Energy
 Energy in the p-spin Ising model corresponds to the number of unsatisfied constraints in the XOR-SAT formula. Belief Propagation is able to find solutions only up to the dynamic transition around 0.82, above which more sophisticated techniques like Survey Propagation are needed.
 ![energy](https://github.com/stecrotti/xorsat/blob/master/images/energy.png?raw=true  "Energy")
 
 

  
 


<!--stackedit_data:
eyJoaXN0b3J5IjpbLTEwMjUzNDE3MTIsLTQ4NDg2MTEzOSwxMT
I0MzM0NjMxLC05NTU4MDU4NDEsLTIwOTY3ODkyMjAsMTA1OTg5
Mjk1MCwyMDgzNjc0OTMsMTAyNTg1NTczNV19
-->