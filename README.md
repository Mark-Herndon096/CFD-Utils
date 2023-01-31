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
metrics of the transformation are defined as

$$
   \begin{align\*}
    \xi_x/J   &=& y_\eta  z_\zeta - z_\eta  y_\zeta \\
    \xi_y/J   &=& z_\eta  x_\zeta - x_\eta  z_\zeta \\
    \xi_z/J   &=& x_\eta  y_\zeta - y_\eta  x_\zeta \\
    \eta_x/J  &=& y_\zeta z_\xi   - z_\zeta y_\xi   \\
    \eta_y/J  &=& z_\zeta x_\xi   - x_\zeta z_\xi   \\
    \eta_z/J  &=& x_\zeta y_\xi   - y_\zeta x_\xi   \\
    \zeta_x/J &=& y_\xi   z_\eta  - z_\xi   y_\eta  \\
    \zeta_y/J &=& z_\xi   x_\eta  - x_\xi   z_\eta  \\
    \zeta_z/J &=& x_\xi   y_\eta  - y_\xi   x_\eta  \\
   \end{align*}
$$

where the inverse jacobian $J^{-1}$ is



## To do
Grid interpolations, spectral analysis, grid convergence plotting routines, etc ...
