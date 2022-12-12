# Postwork Sesión 2.

#### Objetivo

"- Conocer algunas de las bases de datos disponibles en `R`
- Observar algunas características y manipular los DataFrames con `dplyr`
- Realizar visualizaciones con `ggplot`
#### Requisitos

1. Tener instalado R y RStudio
2. Haber realizado el prework y estudiado los ejemplos de la sesión."

#### Desarrollo

"1) Inspecciona el DataSet iris disponible directamente en la librería de ggplot. 
Identifica las variables que contiene y su tipo, asegúrate de que no hayan datos faltantes y 
que los datos se encuentran listos para usarse."
df.iris <- iris

head(df.iris)
names(df.iris)
class(df.iris)
class(df.iris$Sepal.Length)
class(df.iris$Sepal.Width)
class(df.iris$Petal.Length)
class(df.iris$Petal.Width)
class(df.iris$Species)
str(df.iris)

sum(complete.cases(df.iris))
sum(is.na(df.iris))

"2) Crea una gráfica de puntos que contenga `Sepal.Lenght` en el eje horizontal, 
`Sepal.Width` en el eje vertical, que identifique `Species` por color y que el tamaño
de la figura está representado por `Petal.Width`. 
Asegúrate de que la geometría contenga `shape = 10` y `alpha = 0.5`."
library(ggplot2)
library(dplyr)
?ggplot2
g1 <- ggplot(df.iris, aes(x=Sepal.Length, y=Sepal.Width, color= Species, size=Petal.Width)) + geom_point(shape=10, alpha=0.5)
g1
"""
Según la gráfica obtenida, se observa que la especie Iris setosa, además de que 
es la que tiene el pétalo más pequeño, es la que presenta ancho de sépalo mayor 
y la longitud de sépalo menor.

Ante un análisis visual, las otras dos especies (I.versicolor e I.virginica) 
son de ancho de pétalo parecido, sin embargo, la I.virginica presenta dimensiones
de sépalo mayores.

"""

"3) Crea una tabla llamada `iris_mean` que contenga el promedio de todas las variables 
agrupadas por `Species`."
iris_mean <- df.iris %>% select(Species, Sepal.Length, Sepal.Width, Petal.Length, Petal.Width) %>% group_by(Species) %>% 
  summarize(Sepal.Length = mean(Sepal.Length), Sepal.Width=mean(Sepal.Width), Petal.Length=mean(Petal.Length), Petal.Width=mean(Petal.Width))
iris_mean
"""
  Species    Sepal.Length Sepal.Width Petal.Length Petal.Width
  <fct>             <dbl>       <dbl>        <dbl>       <dbl>
1 setosa             5.01        3.43         1.46       0.246
2 versicolor         5.94        2.77         4.26       1.33 
3 virginica          6.59        2.97         5.55       2.03 

"""
"4) Con esta tabla, agrega a tu gráfica anterior otra geometría de puntos para agregar 
los promedios en la visualización. Asegúrate que el primer argumento de la geometría 
sea el nombre de tu tabla y que los parámetros sean `shape = 23`, `size = 4`, 
`fill = 'black'` y `stroke = 2`. También agrega etiquetas, temas y los cambios 
necesarios para mejorar tu visualización."
g1 + geom_point(data=iris_mean, shape=23, size=4, fill='black', stroke=2)

"""
La gráfica con promedios confirma el análisis anterior.

"""
