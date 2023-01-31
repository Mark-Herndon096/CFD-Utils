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
## Mathematics
Metrics of the coordinate transformation $(x,y,z) \rightarrow (\xi,\eta,\zeta)$ are defined

$$
   \begin{align\*}
    \xi_x   &= J(y_\eta  z_\zeta - z_\eta  y_\zeta) \\ 
    \xi_y   &= J\\,(z_\eta \\, x_\zeta - x_\eta \\, z_\zeta) \\  
    \xi_z   &= J\\,(x_\eta \\, y_\zeta - y_\eta \\, x_\zeta) \\  
    \eta_x  &= J\\,(y_\zeta \\, z_\xi   - z_\zeta \\, y_\xi) \\
    \eta_y  &= J\\,(z_\zeta \\, x_\xi   - x_\zeta \\, z_\xi) \\
    \eta_z  &= J\\,(x_\zeta \\, y_\xi   - y_\zeta \\, x_\xi) \\
    \zeta_x &= J\\,(y_\xi \\,  z_\eta  - z_\xi \\, y_\eta)   \\
    \zeta_y &= J\\,(z_\xi \\,  x_\eta  - x_\xi \\, z_\eta)   \\
    \zeta_z &= J\\,(x_\xi \\,  y_\eta  - y_\xi \\,  x_\eta)  \\
   \end{align*}
$$

where the inverse jacobian of the transformation $J^{-1}=1/J$ 

$$
J^{-1} = x_{\xi}\\,\xi_x + y_{\xi}\\,\xi_y + z_{\xi}\\,\xi_z
$$

Derivatives with respect to spatial (cartesian) directions may now be expressed as

$$
   \begin{align\*}
      \frac{\partial}{\partial x} &= \xi_x\frac{\partial}{\partial \xi} + \eta_x\frac{\partial}{\partial \eta} + \zeta_x\frac{\partial}{\partial \zeta} \\
      \\
          \frac{\partial}{\partial y} &= \xi_y\frac{\partial}{\partial \xi} + \eta_y\frac{\partial}{\partial \eta} + \zeta_y\frac{\partial}{\partial \zeta} \\
      \\
          \frac{\partial}{\partial z} &= \xi_z\frac{\partial}{\partial \xi} + \eta_z\frac{\partial}{\partial \eta} + \zeta_z\frac{\partial}{\partial \zeta} \\
      \\
   \end{align\*}
$$

which allow for analysis on general curvilinear grids or unequally spaced cartesian grids for finite-difference applications. As an example, the cartesian component of vorticity in the $z$-direction can be computed as

$$
   \begin{align\*}
   \omega_z &=\left(\frac{\partial v}{\partial x} - \frac{\partial u}{\partial y}\right) \\
   \\
            &=\left(\xi_y\frac{\partial v}{\partial \xi} + \eta_y\frac{\partial v}{\partial \eta} + \zeta_y\frac{\partial v}{\partial \zeta}\right) -\left(\xi_x\frac{\partial u}{\partial \xi} + \eta_x\frac{\partial u}{\partial \eta} + \zeta_x\frac{\partial u}{\partial \zeta}\right)
   \end{align\*}
$$


## To do
Grid interpolations, spectral analysis, grid convergence plotting routines, etc ...
