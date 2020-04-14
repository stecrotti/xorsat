# XOR-SAT formulas and p-spin Ising model
This work was produced for a university course in Fall '19. 
It is based on [M. Mézard, F. Ricci-Tersenghi, R. Zecchina, *Two Solutions to Diluted p-Spin Models
and XORSAT Problems*, Journal of Statistical Physics, 2003](http://chimera.roma1.infn.it/FEDERICO/Publications_files/2003_JSP_111_505.pdf).

Belief Propagation equations are implemented in their Min-Sum form to look for solutions to XOR-SAT instances drawn from a random ensemble in the thermodynamic limit of ![Ninf](https://latex.codecogs.com/gif.latex?N%5Crightarrow%20%5Cinfty) variables. 
The problem is equivalent to that of finding the Ground State for a p-spin Ising model (an Ising model where spins interact not in pairs but in p-uples) defined of a factor graph.
A brief explanation of the main results follows
### Leaf Removal algorithm
 Recursively remove from the graph all leaves and the factors (also called hyperedges) they are attached to, until there is none left. The subgraph resulting at the end, called *core*, is the frozen part of the graph, formed by those variable whose value is forced by the rigidness of the system.
 The density ![gamma](https://latex.codecogs.com/gif.latex?%5Cgamma) is the ratio of number of constraints and number of variables. As the density varies from 0 to 1 and beyond, the system undergoes two phase transitions
 - **Dynamic transition**: At some density ![gammad](https://latex.codecogs.com/gif.latex?%5Cgamma_d) (~0.82 for p=3), the core size jumps from 0 to a value extensive with N, the number of variables 
 - **SAT/UNSAT transition**: From![gammac](https://latex.codecogs.com/gif.latex?%5Cgamma_c) (~0.92 for p=3) up,  the core contains more constraints than variables and the probability of an instance being satisfiable becomes exponentially small ![core](https://github.com/stecrotti/xorsat/blob/master/images/core.png?raw=true "Core")
 
 ### Energy
 Energy in the p-spin Ising model corresponds to the number of unsatisfied constraints in the XOR-SAT formula. Belief Propagation is able to find solutions only up to the dynamic transition at ![gammad](https://latex.codecogs.com/gif.latex?%5Cgamma_d), above which more sophisticated techniques like Survey Propagation are needed
 ![energy](https://github.com/stecrotti/xorsat/blob/master/images/energy.png?raw=true  "Energy")
 
 ------------
 ### Some links
 Julia Language [Julia](https://julialang.org/)
 
 Survey Propagation [SP](https://arxiv.org/abs/cs/0212002)
 
 

  
 


<!--stackedit_data:
eyJoaXN0b3J5IjpbLTEyNzAzMjExMjksLTE5MjM3NjE5NjAsMj
cwNDM5NjM4LC00ODQ4NjExMzksMTEyNDMzNDYzMSwtOTU1ODA1
ODQxLC0yMDk2Nzg5MjIwLDEwNTk4OTI5NTAsMjA4MzY3NDkzLD
EwMjU4NTU3MzVdfQ==
-->