library(terra)
library(geodata)

#Descargar la base de datos con variables bioclimáticas para Colombia del 
#servidor worldclim
clim <- geodata::worldclim_country(var = 'bio', res = 0.5, download = F, country="Colombia",path="data")

#Graficar el raster
plot(clim$wc2.1_30s_bio_1)

#Extraer el sistema de coordenadas de referencia
crs(clim)

#Calcula la diferencia de temperatura extremas
dif=clim$wc2.1_30s_bio_5-clim$wc2.1_30s_bio_6
plot(dif)

#Comprobar la diferencia de temperaturas extremas
plot(dif-clim$wc2.1_30s_bio_7)

Mapa=vect("Mapa_Depto_COL/MGN_DPTO_POLITICO.shp")

#Comparación de CRS entre el raster y el shapefile
crs(Mapa)==crs(clim)

#project me lleva un coordenada de referencia a otro, utilizando el primero 
#parámetro (Raster o Shapefile) al segundo parámetro (CRS)
ClimP=project(clim,crs(Mapa)) 
crs(Mapa)==crs(ClimP)

#Calcular la temperatura promedio por departamentos
Tprom=extract(ClimP$wc2.1_30s_bio_1,Mapa,na.rm=T,fun=mean)

Mapa$Tprom = Tprom$wc2.1_30s_bio_1 
plot(Mapa,"Tprom",plg=list(title="Tprom"))

#LABORATORIO 1.2

#A) Busque que más variables ofrece el servidor wordclim, y liste las 19 
#variables bioclimáticas y de una breve definición de cada una.

#B) Haga una mapa de temperatura máxima, mínima, y 
#desviación estándar de la temperatura para cada departamento.

#Temperatura máxima
Tmax = extract(ClimP$wc2.1_30s_bio_1, Mapa, na.rm=T, fun=max)
Mapa$Tmax = Tmax$wc2.1_30s_bio_1 
plot(Mapa,"Tmax",plg=list(title="Tmax"))

#Temperatura mínima
Tmin = extract(ClimP$wc2.1_30s_bio_1, Mapa, na.rm=T, fun=min)
Mapa$Tmin = Tmin$wc2.1_30s_bio_1 
plot(Mapa,"Tmin",plg=list(title="Tmin"))

#Desviación estándar de la temperatura
Tstd = extract(ClimP$wc2.1_30s_bio_1, Mapa, na.rm=T, fun=sd)
Mapa$Tstd = Tstd$wc2.1_30s_bio_1 
plot(Mapa,"Tstd",plg=list(title="Tstd"))