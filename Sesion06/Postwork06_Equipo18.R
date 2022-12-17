"Supongamos que nuestro trabajo consiste en aconsejar a un cliente sobre como
mejorar las ventas de un producto particular, y el conjunto de datos con el que
disponemos son datos de publicidad que consisten en las ventas de aquel producto
en 200 diferentes mercados, junto con presupuestos de publicidad para el producto
en cada uno de aquellos mercados para tres medios de comunicación diferentes: TV,
radio, y periódico. No es posible para nuestro cliente incrementar directamente
las ventas del producto. Por otro lado, ellos pueden controlar el gasto en
publicidad para cada uno de los tres medios de comunicación. Por lo tanto, si
determinamos que hay una asociación entre publicidad y ventas, entonces podemos
instruir a nuestro cliente para que ajuste los presupuestos de publicidad, y así
indirectamente incrementar las ventas.

En otras palabras, nuestro objetivo es desarrollar un modelo preciso que pueda ser
usado para predecir las ventas sobre la base de los tres presupuestos de medios
de comunicación. Ajuste modelos de regresión lineal múltiple a los datos
advertisement.csv y elija el modelo más adecuado siguiendo los procedimientos
vistos

Considera:
  
Y: Sales (Ventas de un producto)
X1: TV (Presupuesto de publicidad en TV para el producto)
X2: Radio (Presupuesto de publicidad en Radio para el producto)
X3: Newspaper (Presupuesto de publicidad en Periódico para el producto)"

adv <- read.csv("https://raw.githubusercontent.com/beduExpert/Programacion-R-Santander-2022/main/Sesion-06/data/advertising.csv")
library(dplyr)
library(ggplot2)

str(adv)

adv.select <- select(adv, Sales, Radio, Newspaper, TV)
str(adv.select)
round(cor(adv.select),4)  

pairs(~ Sales + Radio + Newspaper + TV, 
      data = adv, gap = 0.4, cex.labels = 1.5)

attach(adv)
m1 <- lm(Sales ~ Radio + Newspaper + TV)

summary(m1) #0.9011

m2 <- update(m1, ~.-Newspaper)
summary(m2) #0.9016

minteraction1 <- lm(Sales ~ Radio + Newspaper + TV + 
              Radio:Newspaper + TV:Newspaper)

summary(minteraction1) #0.9016

minteraction2 <- lm(Sales ~ Radio + TV + Radio:TV)
summary(minteraction2) #0.9127

"El modelo que presenta el mejor R2 ajustada es el minteraction2 ya que 
sólo se consideran las variables significativas y su respectiva interacción
con lo que se eleva la R2 ajustada a 0.9127 sin caer en sobreajuste"
