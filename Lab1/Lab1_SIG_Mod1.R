#Importación de librerías, readxl para leer archivos tipo XLSX
#terra para manejo de archivos con estructura espacial
#rstudioapi nos permite la utilización de rutas relativas
library(readxl)
library(terra)
library(rstudioapi)

#Fijar la ruta de trabajo al archivo actual
setwd(dirname(getActiveDocumentContext()$path))

#Cargar los casos de bajo peso al nacar para 2022
data_BPN = read_excel('Data_Pob_COL//dataCOL_BPN_2022.xlsx')
#Cargar los datos de proyección poblacionales de Colombia de 2020 a 2050
data_ProyPob = read_excel('Data_Pob_COL//dataCOL_ProyPob_2020_2050.xlsx')

#Visualizar datos cargados previamente
View(data_BPN)
View(data_ProyPob)

#Cargar el mapa departamental de Colombia 
map_COL = vect("Mapa_Depto_COL//MGN_DPTO_POLITICO.shp")
#Graficar el mapa
plot(map_COL)
#mostrar el Coordinated Reference System del mapa anterior
crs(map_COL)

#Visualizar el data frame asociado al mapa que cargamos
View(as.data.frame(map_COL))

#Vemos el vector de verdaderos y falsos según los valores que compartan.
map_COL$DPTO_CCDGO %in% data_BPN$`ID DANE`
#Aca usamos el vector de verdaderos y falsos para hacer un subs#set y 
#saber que códigos del dane de nuestro DANE están en la base del SIVIGILA.
map_COL$DPTO_CCDGO[map_COL$DPTO_CCDGO %in% data_BPN$`ID DANE`] 

#Inicializamos la columna
map_COL$CasosBajoPesoAlNacer=NA 
#Hacemos el recorrido. El contador i va sobre los valores de la c#olumna del 
#código del dane del mapa.
for (i in map_COL$DPTO_CCDGO){
  #Aca los corchetes nos permiten hacer el subset.
  map_COL$CasosBajoPesoAlNacer[map_COL$DPTO_CCDGO==i] = data_BPN$ CASOS[data_BPN$`ID DANE`==i]
}

#Hacemos el plot
plot(map_COL,"CasosBajoPesoAlNacer",plg=list(title="CasosBajoPesoAlNacer"))

