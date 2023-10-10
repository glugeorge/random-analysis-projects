import numpy as np
import matplotlib.pyplot as plt
import matplotlib.colors as colors
import matplotlib.colors as mcolors
#adapted from Matlab script by Karthaus Mars group 2022, F. Oraschewski, A. Klose and F. Temme

def simulate_temperature(z,G,cycle_G): 

    # Constants
    secperyear = 31556926  # seconds per Earth year

    # Time settings:
    t_cycle         = 120000  # time of glacial cycle
    dt              = 1000  # time step
    settle_cycles   = 1
    timemax         = (settle_cycles + 1) * t_cycle + dt + 1  # modelled time
    t               = np.arange(0, timemax, dt)  # time vector
    t_n             = len(t)  # number of time steps

    # Spatial settings
    z_n     = len(z)                # number of spacial steps
    w       = acc*(z/H_0+1)         # approximation of vertical velocity

    # Temperature settings
    T_deltaMean = 10 
    T_mean      = 157.5  + T_deltaMean  # Mean temperature over glacial cycle
    T_variable  = 12.4  #
    T_abs       = 273.15 # Absolute temperature
    T_surf      = T_mean + T_variable * np.sin(t / t_cycle * 2 * np.pi)  # surface temperature
    T_save      = np.zeros((z_n, t_n))
    Tpmp        = 273.15 + (H_0 - z) * 8.7e-4  # Temperature of pressure melting point

    if cycle_G:
        G_variable  = 0.04
        G_cycle     = G + G_variable * np.sin(t / t_cycle * (1/4) * np.pi)
        G           = G_cycle

    # thermal conductivity settings
    K   = 2.1 * secperyear  # W m ^ -1, thermal conductivity 

    # specific heat settings
    c   = 152.5 + 7.122 * T_save[:,0]

    # density
    rho_ice     = 917
    rho         = rho_ice

    # Thermal diffusivity
    k   = K/(rho * c)  

    # initialization
    if cycle_G:
        T_save[:, 0]    = T_mean + (H_0 - z) * 0  # initialization of temperature
    else: 
        T_save[:, 0]    = T_mean + (H_0 - z) * 0  # initialization of temperature
    f               = z * 0.  # initialization of term 1
    g               = z * 0.  # initialization of term 2

    for kk in range(t_n - 1):
        T_old   = T_save[:,kk]  # initialization of temperature
        T_new   = np.copy(T_old)
        #K[:-1]   = 9.828 * np.exp(-5.7*10**(-3) * T_old[:-1]) * secperyear
        c       = 152.5 + 7.122 * T_save[:,0]
        k       = K/(rho * c)
        
        # iteration in space
        for nn in range(z_n - 1):
            alpha   = (k[nn] / dz + w[nn]) * dt / dz
            beta    = 1 + (2 * k[nn] / dz + w[nn]) * dt / dz
            gamma   = k[nn] * dt / dz ** 2
            if nn == 0:
                f[nn] = 1
                if cycle_G:
                    g[nn] = G[kk] * secperyear * dz / K
                else: 
                    g[nn] = G * secperyear * dz / K
            else:
                f[nn] = alpha / (beta - gamma * f[nn - 1])
                g[nn] = (T_old[nn] + gamma * g[nn - 1]) / (beta - gamma * f[nn - 1])

        T_new[-1] = T_surf[kk]  # upper boundary condition (surface temperature)
        for nn in reversed(range(z_n - 1)):
            T_new[nn]   = T_new[nn + 1] * f[nn] + g[nn]
            if T_new[nn] > Tpmp[nn]:
                T_new[nn]   = Tpmp[nn]

        T_save[:,kk + 1] = T_new
    
    return T_save, t
    
    # if t[kk] > settle_cycles * t_cycle and T_new[0]>T_melting:
         
    #     plt.plot(T_new, z, '-')
    #     plt.xlim([145, 300])
    #     plt.plot(T_melting * np.ones(np.shape(T_new)), z, 'k')
    #     plt.xlabel('Temperature (K)')
    #     plt.ylabel('Height (m)')
    #     text=plt.text(250,10,np.str(t[kk]/1000) + ' ka')
    #     text.set_bbox(dict(facecolor='white', alpha=1.0, edgecolor='white'))

    #     plt.pause(0.05)
    # elif t[kk] > settle_cycles * t_cycle and T_new[0]<T_melting:
    #     plt.plot(T_new, z, '--')
    #     plt.xlim([145, 300])
    #     plt.plot(T_melting * np.ones(np.shape(T_new)), z, 'k')
    #     plt.xlabel('Temperature (K)')
    #     plt.ylabel('Height (m)')
    #     plt.pause(0.05)
    
cycle_G     = False 
acc = 0.01  # Surface accumulation
G   = 0.03  # W m ^ -2, Geothermal heat flux
H_0     = 1500                  # Current ice cap thickness(m)
dz      = 10                    # depth spacing
z       = np.arange(0, H_0, dz) # spacing vector


T_save, t = simulate_temperature(z,G,cycle_G)

colors1     = plt.cm.Reds_r(np.linspace(0., 1, 128))
colors2     = plt.cm.Blues(np.linspace(0., 1, 128))
colorsMap   = np.vstack((colors2, colors1))
mymap       = mcolors.LinearSegmentedColormap.from_list('my_colormap', colorsMap)
mymap       = np.flip(mymap)
T_melting   = 199


fig, (ax1, ax2, ax3) = plt.subplots(3,1, sharex=True)
if cycle_G:
    ax1.plot(t,1000*G)
else:
    ax1.plot(t,1000*G*np.ones(np.shape(t)))
ax1.set_ylim([0,100])
ax1.set_ylabel('Geothermal heat flux [mW m$^{-2}$]')

ax2.plot(t,T_save[-1,:])
ax2.set_ylim([100,250])
ax2.set_ylabel('Temperature [k]')

divnorm = colors.TwoSlopeNorm(vmin=150, vcenter=T_melting, vmax=250)
cb = ax3.pcolor(t,z,T_save, norm=divnorm, cmap=mymap)
ax3.set_xlabel('time')
ax3.set_xlabel('Height [m]')
plt.colorbar(cb, ax=ax3, location='bottom')

aux = np.where(T_save[0,:]>T_melting)
if aux[0] != []:
    ax1.axvspan(t[aux[0][1]], t[aux[0][-1]], color='grey', alpha=0.2)
    ax2.axvspan(t[aux[0][1]], t[aux[0][-1]], color='grey', alpha=0.2)

plt.show()
