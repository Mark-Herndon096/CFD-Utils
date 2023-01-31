#!/usr/bin/env python3
import numpy as np
from matplotlib import cm
from matplotlib import pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

# Arrays from grid and solution are FORTRAN order
# meaning inner index moves the fastest

# Ignore runtime warnings -- sorry! comment out if you want :)
np.seterr(all='ignore')

# Function to read a single precision grid file
# only one grid per file (ng == 1 ) is alllowed for current implementation
def read_grid_file(fname) :
	ng = np.fromfile(fname, dtype=np.int32, count=1, sep='', offset=0)
	ng = ng[0]
	dims = np.fromfile(fname, dtype=np.int32, count=3*ng, sep='', offset=4)
	headerLength = 4 + 12*ng
	x = np.fromfile(fname, dtype=np.float32, count=np.prod(dims), sep='', offset=headerLength)
	xlength = 4*np.prod(dims)
	off = headerLength + xlength
	y = np.fromfile(fname, dtype=np.float32, count=np.prod(dims), sep='', offset=off)
	off = headerLength + 2*xlength
	z = np.fromfile(fname, dtype=np.float32, count=np.prod(dims), sep='', offset=off)
	
	x = np.reshape(x, (dims[0],dims[1],dims[2]),'F')
	y = np.reshape(y, (dims[0],dims[1],dims[2]),'F')
	z = np.reshape(z, (dims[0],dims[1],dims[2]),'F')
	return [dims, x, y, z]

# Function to read a solution file
# FORMAT:
# header --> ng, dims(3,ng)
# dat    --> [xm1, aoa, Re, tau]
# q      --> q(:,:,:,5) conserved variable array
def read_solution_file(fname) :
	ng = np.fromfile(fname, dtype=np.int32, count=1, sep='', offset=0)
	ng = ng[0]
	dims = np.fromfile(fname, dtype=np.int32, count=3*ng, sep='', offset=4)
	headerLength = 4 + 12*ng
	dat = np.fromfile(fname, dtype=np.float32, count=4, sep='', offset=headerLength)
	headerLength = 20 + 12*ng
	q = np.fromfile(fname, dtype=np.float32, count=ng*np.prod(dims)*5, sep='',offset=headerLength)
	q = np.reshape(q, (dims[0],dims[1],dims[2],5),'F')
	return [dat, q]

# Adjust function to your liking
def plot_contour(x,y,F,xs,xe,ys,ye) :
	fig, ax = plt.subplots()
	ax.contourf(x,y,F,256, cmap=cm.coolwarm, vmin=-0.5, vmax=0.5)
	ax.set_xlim(xs, xe)
	ax.set_ylim(ys, ye)
	return fig

# Second order finite difference in uniform computational space
def deriv(x,opdir) :
	ni = x.shape[0]
	nj = x.shape[1]
	nk = x.shape[2]
	dx = np.zeros((ni,nj,nk),dtype=np.float32)
	if opdir == 1 :
		dx[0,:,:]    = x[1,:,:] - x[0,:,:]
		dx[1:-2,:,:] = 0.5*(x[2:-1,:,:]-x[0:-3,:,:])
		dx[-1,:,:]   = x[-1,:,:] - x[-2,:,:]
	if opdir == 2 :
		dx[:,0,:]    = x[:,1,:] - x[:,0,:]
		dx[:,1:-2,:] = 0.5*(x[:,2:-1,:]-x[:,0:-3,:])
		dx[:,-1,:]   = x[:,-1,:] - x[:,-2,:]
	if opdir == 3 :
		if nk == 3 :
			dx[:,:,0] = x[:,:,1] - x[:,:,0]
			dx[:,:,1] = 0.5*(x[:,:,-1]-x[:,:,0])
			dx[:,:,2] = x[:,:,-1] - x[:,:,-2]
		else :
			dx[:,:,0]    = x[:,:,1] - x[:,:,0]
			dx[:,:,1:-2] = 0.5*(x[:,:,2:-1]-x[:,:,0:-3])
			dx[:,:,-1]   = x[:,:,-1] - x[:,:,-2]
	return dx

# Calculate metrics for coordinate transformation to uniform computational space
def metrics(x,y,z) :
	dims = np.shape(x)
	ni = dims[0]
	nj = dims[1]
	nk = dims[2]
	xi   = np.zeros((ni,nj,nk,3))
	eta  = np.zeros((ni,nj,nk,3))
	zeta = np.zeros((ni,nj,nk,3))
	xjac = np.zeros((ni,nj,nk))
	
	xmet = np.zeros((ni,nj,nk,3))
	ymet = np.zeros((ni,nj,nk,3))
	zmet = np.zeros((ni,nj,nk,3))
	
	
	# Derivatives of x in xi, eta, and zeta
	xmet[:,:,:,0] = deriv(x,1)
	xmet[:,:,:,1] = deriv(x,2)
	xmet[:,:,:,2] = deriv(x,3)
	# Derivatives of y in xi, eta, and zeta
	ymet[:,:,:,0] = deriv(y,1)
	ymet[:,:,:,1] = deriv(y,2)
	ymet[:,:,:,2] = deriv(y,3)
	# Derivatives of z in xi, eta, and zeta
	zmet[:,:,:,0] = deriv(z,1)
	zmet[:,:,:,1] = deriv(z,2)
	zmet[:,:,:,2] = deriv(z,3)

	xi[:,:,:,0]   = ymet[:,:,:,1]*zmet[:,:,:,2] - zmet[:,:,:,1]*ymet[:,:,:,2]
	xi[:,:,:,1]   = zmet[:,:,:,1]*xmet[:,:,:,2] - xmet[:,:,:,1]*zmet[:,:,:,2]
	xi[:,:,:,2]   = xmet[:,:,:,1]*ymet[:,:,:,2] - ymet[:,:,:,1]*xmet[:,:,:,2]
	eta[:,:,:,0]  = ymet[:,:,:,2]*zmet[:,:,:,0] - zmet[:,:,:,2]*ymet[:,:,:,0]
	eta[:,:,:,1]  = zmet[:,:,:,2]*xmet[:,:,:,0] - xmet[:,:,:,2]*zmet[:,:,:,0]
	eta[:,:,:,2]  = xmet[:,:,:,2]*ymet[:,:,:,0] - ymet[:,:,:,2]*xmet[:,:,:,0]
	zeta[:,:,:,0] = ymet[:,:,:,0]*zmet[:,:,:,1] - zmet[:,:,:,0]*ymet[:,:,:,1]
	zeta[:,:,:,1] = zmet[:,:,:,0]*xmet[:,:,:,1] - xmet[:,:,:,0]*zmet[:,:,:,1]
	zeta[:,:,:,2] = xmet[:,:,:,0]*ymet[:,:,:,1] - ymet[:,:,:,0]*xmet[:,:,:,1]
	xjac[:,:,:]   = xmet[:,:,:,0]*xi[:,:,:,0]   + ymet[:,:,:,0]*xi[:,:,:,1] + zmet[:,:,:,0]*xi[:,:,:,2]
	xi[:,:,:,0]   = xi[:,:,:,0]/xjac[:,:,:] 
	xi[:,:,:,1]   = xi[:,:,:,1]/xjac[:,:,:] 
	xi[:,:,:,2]   = xi[:,:,:,2]/xjac[:,:,:] 
	eta[:,:,:,0]  = eta[:,:,:,0]/xjac[:,:,:] 
	eta[:,:,:,1]  = eta[:,:,:,1]/xjac[:,:,:] 
	eta[:,:,:,2]  = eta[:,:,:,2]/xjac[:,:,:] 
	zeta[:,:,:,0] = zeta[:,:,:,0]/xjac[:,:,:] 
	zeta[:,:,:,1] = zeta[:,:,:,1]/xjac[:,:,:] 
	zeta[:,:,:,2] = zeta[:,:,:,2]/xjac[:,:,:] 

	return [xi, eta, zeta, xjac]

def compute_z_vorticity(u,v,xi,eta) :
	dims = np.shape(u)
	ni = dims[0]
	nj = dims[1]
	nk = dims[2]

	uxi = deriv(u,1)
	vxi = deriv(v,1)
	uet = deriv(u,2)
	vet = deriv(v,2)

	omega = np.zeros((ni,nj,nk))
	
	with np.errstate(all='ignore') :
		omega[:,:,:] =  xi[:,:,:,0]*vxi[:,:,:] + eta[:,:,:,0]*vet[:,:,:] - (xi[:,:,:,1]*uxi[:,:,:] + eta[:,:,:,1]*uet[:,:,:])
	return omega

# Example main program for computing z-vorticity components
# of a solution file 
def main() :
	[dims, x, y, z] = read_grid_file("cylinder.sp.x")
	[dat, q] = read_solution_file("sol-0010000.q") 
	
	[xi, eta, zeta, xjac] = metrics(x,y,z)
	u = q[:,:,:,1]/q[:,:,:,0] # Definition of u-velocity
	v = q[:,:,:,2]/q[:,:,:,0] # Definition of v-velocity

	wz = compute_z_vorticity(u,v,xi,eta)
	
	xs = -1.0
	xe =  5.0
	ys = -3.0
	ye = 3.0
	f1 = plot_contour(x[:,:,1],y[:,:,1],wz[:,:,1],xs,xe,ys,ye)	
	plt.show()

if __name__ == "__main__" :
	main()
