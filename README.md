# Plot3D Utilities

Plot3D Utilities are a collection of Python and Matlab functions to deal with processing solution files and grid files in the PLOT3D format. Most functions are generally oriented for column-major single precision data for solutions and grid files composed of one single grid.

## Pyton usage
```python
import plot3dUtils as p3d

# Reads grid file
[x,y,z,dims] = read_grid_file(grdfile)

# Reads solution file
iter = 100 # Solution iteration of choice
solfile = "sol-%07d.q" % iter
[dat, q] = read_solution_file(solfile)

# Compute metrics
[xi, eta, zeta, xjac] = metrics(x,y,z)
# ...
'''

## To do
Grid interpolations, spectral analysis, grid convergence plotting routines, etc ...
