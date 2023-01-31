# Plot3D Utilities

Plot3D Utilities are a collection of Python and Matlab functions to deal with processing solution files and grid files in the PLOT3D format. Most functions are generally oriented for column-major single precision data for solutions and grid files composed of one single grid.

## Pyton usage
```python
import plot3dUtils as p3d

# Reads grid file
[dims,x,y,z] = read_grid_file(grdfile)

# Reads solution file
iter = 100 # Solution iteration of choice
solfile = "sol-%07d.q" % iter
[dat, q] = read_solution_file(solfile)

# Compute metrics
[xi, eta, zeta, xjac] = metrics(x,y,z)
# ...
```
$$
   \begin{align\*}
    \frac{\xi_x}{J}   &=& y_\eta  z_\zeta - z_\eta  y_\zeta \\
    \frac{\xi_y}{J}   &=& z_\eta  x_\zeta - x_\eta  z_\zeta \\
    \frac{\xi_z}{J}   &=& x_\eta  y_\zeta - y_\eta  x_\zeta \\
    \frac{\eta_x}{J}  &=& y_\zeta z_\xi   - z_\zeta y_\xi   \\
    \frac{\eta_y}{J}  &=& z_\zeta x_\xi   - x_\zeta z_\xi   \\
    \frac{\eta_z}{J}  &=& x_\zeta y_\xi   - y_\zeta x_\xi   \\
    \frac{\zeta_x}{J} &=& y_\xi   z_\eta  - z_\xi   y_\eta  \\
    \frac{\zeta_y}{J} &=& z_\xi   x_\eta  - x_\xi   z_\eta  \\
    \frac{\zeta_z}{J} &=& x_\xi   y_\eta  - y_\xi   x_\eta  \\
   \end{align*}
$$

## To do
Grid interpolations, spectral analysis, grid convergence plotting routines, etc ...
