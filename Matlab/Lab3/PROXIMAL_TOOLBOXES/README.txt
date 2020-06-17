
PROXIMAL_TOOLBOXES

---------------------------------------------------------------------------
Copyright Notice
================
Copyright 2010, Sofia Mosci and Lorenzo Rosasco

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License, Version 3, 29 June 2007, as published by the Free Software Foundation.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
---------------------------------------------------------------------------

Introduction
============

This set of MATLAB toolboxes contain an implementation of the
regularization algorithms described in the papers 

"Solving Structured Sparsity Regularization with Proximal Methods";
by Sofia Mosci, Lorenzo Rosasco, Matteo Santoro, Alessando Verri, Silvia Villa; 
ECML 2010, Barcelona, Spain.

"A Primal-dual algorithm for group lasso with overlapping groups";
by Sofia Mosci, Alessando Verri, Silvia Villa, Lorenzo Rosasco; 
NIPS 2010, Vancouver, Canada.


The toolboxes are:
1) L1L2_TOOLBOX (Lasso and Elastic net Regularization)
2) GROUP-LASSO_TOOLBOX (Group lasso)
3) MULTI-TASK_TOOLBOX (Multi-task learning or Joint Features Selection)
4) GLOPRIDU_TOOLBOX (Group-Lasso with Overlap, primal-dual optimization)


Each toolbox contains a learning algorithm (<ALGORITHM>_algorithm.m) a function for computing the regularization path (<ALGORITHM>_regpath.m), 
a function for performing the K-fold/LOO cross-validation framework (<ALGORITHM>_kcv.m),
a function estimating the maximum value for the regularization parameter (<ALGORITHM>_tau_max.m), 
and a function for predicting the labels on a data set given the model returned by <ALGORITHM>_KCV.m (<ALGORITHM>_pred.m). 
The algorithms names are "l1l2" for l1l2 regularization, 
"grl" for Group-l1l2 regularization and "mtl" for multi-task learning, "glo" for group lasso with overlap.   
For usage details, type  "help <FUN_NAME>" (e.g. "help l1l2_kcv") at the MATLAB prompt.

There is a "utilities" folder included and 3 demos:
-demo_kcv.m: showing how to perform cross-validation with l1, l1l2, group lasso and multi-task learning.
-demo_glopridu_kcv.m: showing how to perform cross-validation with group lasso with overlap.
-demo_projection_vs_duplication: evaluates running time and number of iterations necessary 
 for computing the regularizton path of Glopridu and Group-lasso with replicates

---------------------------------------------------------------------------

Contact Information
===================

Both the papers and the code are available at
http://www.disi.unige.it/person/MosciS/CODE/Prox.html

  Sofia Mosci		mosci@disi.unige.it
  Lorenzo Rosasco	lrosasco@mit.edu

---------------------------------------------------------------------------


This code is in development stage; any comments or bug reports are 
very welcome.
