# XOR-SAT formulas and p-spin Ising model
This work was produced for the *Algorithms for Optimization, Inference and Learning* course in Fall '19. 
It is based on [M. Mézard, F. Ricci-Tersenghi, R. Zecchina, *Two Solutions to Diluted p-Spin Models
and XORSAT Problems*, Journal of Statistical Physics, 2003](http://chimera.roma1.infn.it/FEDERICO/Publications_files/2003_JSP_111_505.pdf).

Belief Propagation equations are implemented in their Min-Sum form to look for solutions to XOR-SAT instances drawn from a random ensemble in the thermodynamic limit of ![Ninf](https://latex.codecogs.com/gif.latex?N%5Crightarrow%20%5Cinfty) variables. 
The problem is equivalent to that of finding the Ground State for a p-spin Ising model (an Ising model where spins interact not in pairs but in p-uples) defined over a factor graph.
A brief explanation of the main results follows
### Leaf Removal algorithm
 Recursively remove from the graph all leaves and the factors (also called hyperedges) they are attached to, until there is no leaf left. The subgraph resulting at the end, called *core*, is the frozen part of the graph, formed by those variable whose value is forced by the rigidness of the system.
 The density ![gamma](https://github.com/stecrotti/xorsat/blob/master/latex/gamma.gif?raw=true) is the ratio of number of constraints and number of variables. As the density varies from 0 to 1 and beyond, the system undergoes two phase transitions
 - **Dynamic transition**: At some density ![gammad](https://github.com/stecrotti/xorsat/blob/master/latex/gammad.gif?raw=true) (~0.82 for p=3), the core size jumps from 0 to a value extensive with N, the number of variables 
 - **SAT/UNSAT transition**: From ![gammac](https://github.com/stecrotti/xorsat/blob/master/latex/gammac.gif?raw=true) (~0.92 for p=3) up,  the core contains more constraints than variables and the probability of an instance being satisfiable becomes exponentially small ![core](https://github.com/stecrotti/xorsat/blob/master/images/core.png?raw=true "Core")
 
 ### Energy
 Energy in the p-spin Ising model corresponds to the number of unsatisfied constraints in the XOR-SAT formula. For ![gamma](https://github.com/stecrotti/xorsat/blob/master/latex/gamma.gif?raw=true)  < ![gammad](https://github.com/stecrotti/xorsat/blob/master/latex/gammad.gif?raw=true), all solutions are concentrated in one cluster, meaning that each one can be reached from any other with a finite number of spin flips. In this regime BP, which is a local algorithm, is able to find solutions. Instead, for ![gammad](https://github.com/stecrotti/xorsat/blob/master/latex/gammad.gif?raw=true) < ![gamma](https://github.com/stecrotti/xorsat/blob/master/latex/gamma.gif?raw=true) < ![gammac](https://github.com/stecrotti/xorsat/blob/master/latex/gammac.gif?raw=true) , systems are still solvable, but solutions are scattered into an extensive (with respect to N) number of clusters, therefore more sophisticated techniques such as Survey Propagation are required in order
to approximate the actual behavior.
![energy](https://github.com/stecrotti/xorsat/blob/master/images/energy.png?raw=true  "Energy")
 
 ------------
 ### Some links
 - Julia Language [Julia](https://julialang.org/)
- Phase transitions in combinatorial optimization [Simplest random K-satisfiability problem](https://arxiv.org/abs/cond-mat/0011181)
- Survey Propagation [Survey propagation: an algorithm for satisfiability](https://arxiv.org/abs/cs/0212002)


 
 

  
 


<!--stackedit_data:
eyJoaXN0b3J5IjpbMTMzNjE5ODUwNF19
-->