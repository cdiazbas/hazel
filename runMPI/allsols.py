# -*- coding: iso-8859-15 -*-
from FuncDesigner import *
from openopt import *
import numpy as np
import pdb

def unique(a, precision):
    order = np.lexsort(a.T)
    a = a[order]
    diff = np.diff(a, axis=0)
    ui = np.ones(len(a), 'bool')
    ui[1:] = (np.abs(diff) > precision).any(axis=1)
    return a[ui]
    
def all_solutions(Qmeas, Umeas, tolerance):

# Find all solutions using the saturation limit
	th, chi = oovars('th chi')
	F = [ (0.25*(((3.0*cos(th)**2-1.0) * (3.0*(1.0-sin(th)**2)-1.0+sin(th)**2*cos(2.0*chi)))) == Qmeas)(tol=tolerance),
	(4.0*0.25*((3.0*cos(th)**2-1.0) * sin(th) * cos(th) * sin(chi)) == Umeas)(tol=tolerance)]
	#(sin(th)*cos(chi) == -0.00495)(tol=tolerance)]

	startpoint = {th: 0.0, chi: 0.0}
	solver = 'interalg'
	p = SNLE(F, startpoint, ftol=1e-5)
	p.constraints = (th>=0, th<np.pi, chi>=-np.pi, chi<np.pi)

	th.tol = 1e-3
	chi.tol = 1e-3

	r = p.solve(solver, maxSolutions=8)

	sol = np.asarray([[th(s),chi(s)] for s in r.solutions])

	if (sol.shape[0] > 1):

# Get the unique solutions
		sol = unique(sol, 1e-2)

	return sol
	
sol = all_solutions(0.75073, -0.10625, 7e-4)
print 'Number of unique solutions found : ', sol.shape[0]
print sol