# -*- coding: utf-8 -*-
import numpy as np
import pandas as  pd
from netCDF4 import Dataset
#import matplotlib as plt
import matplotlib.pyplot as plt
from mpl_toolkits.basemap import Basemap


data=Dataset("hycomRe.nc")


lon=data.variables['LON'][:]
lat=data.variables['LAT'][:]
temp=data.variables['WATER_TEMP'][0,0,:,:]



fig = plt.figure()
#  resolution ='l' is ok , nor use 'h' will work sloyly
m=Basemap(projection='merc',llcrnrlat=21,urcrnrlat=26,\
            llcrnrlon=115,urcrnrlon=123,resolution='l')

#set fig size
fig.set_size_inches(15, 8, forward=True)
ax = plt.gca()


# need to 2D due to data is 2D
x,y=np.meshgrid(lon,lat)


#contour  mk linspace to adjust,  cmap is color to choose , extebd is the colorbar extend  ,cmap='rainbow'
cs=m.contourf(x,y,temp, np.linspace(15,25,21) ,extend='both',cmap='rainbow'  ,latlon=True)
#color bar  pad is distance in colobar to pic
cbar = m.colorbar(cs, location='right', pad="10%")
#set fontsize in color bar 
cbar.ax.tick_params(labelsize=20)
#draw land and costline
m.drawcoastlines()
m.fillcontinents(color='gray',lake_color='gray')

####################       label   ################################################  
      
#make ylabel
m.drawparallels(np.arange(21,27,1),labels=[1,1,0,0],fontsize=20, linewidth=0.0)
#make xlabel
m.drawmeridians(np.arange(116,124,2),labels=[0,0,0,1],fontsize=20, linewidth=0.0)
#title
plt.title('SST  ',fontsize=30,weight='bold')  
        
plt.xlabel('Longitude',fontsize=30, labelpad=35)
plt.ylabel('Latitude',fontsize=30,  labelpad=55)

fig.savefig('pyhycom.png')
