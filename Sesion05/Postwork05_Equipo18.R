"El data frame iris contiene información recolectada por Anderson sobre 50 flores
de 3 especies distintas (setosa, versicolor y virginica), incluyendo medidas en 
centímetros del largo y ancho del sépalo así como de los pétalos.

Estudios recientes sobre las mismas especies muestran que:
  
1. En promedio, el largo del sépalo de la especie setosa (Sepal.Length) es igual a
5.7 cm
2. En promedio, el ancho del pétalo de la especie virginica (Petal.Width) es menor a
2.1 cm
3. En promedio, el largo del pétalo de la especie virgínica es 1.1 cm más grande que
el promedio del largo del pétalo de la especie versicolor.
4. En promedio, no existe diferencia en el ancho del sépalo entre las 3 especies.
Utilizando pruebas de inferencia estadística, concluye si existe evidencia
suficiente para concluir que los datos recolectados por Anderson están en línea
con los nuevos estudios.

Utiliza 99% de confianza para toda las pruebas, en cada caso realiza el
planteamiento de hipótesis adecuado y concluye.

1. En promedio, el largo del sépalo de la especie setosa (Sepal.Length) es igual a
5.7 cm

Planteamiento de hipótesis:
H0: mean.Sepal.Length.setosa = 5.7
H1: mean.Sepal.Length.setosa != 5.7"

View(iris)

t.test(iris[iris$Species == "setosa","Sepal.Length"], alternative = 'two.sided', mu=5.7) #p = <2.2e-16

"Con un nivel de confianza del 99%, se rechaza la hipótesis nula, por lo que,
en promedio, el largo del sépalo de la espacie I. setosa recolectado por Anderson es
distinto a 5.7 cm, a diferencia de lo recolectado en los nuevos estudios.

2. En promedio, el ancho del pétalo de la especie virginica (Petal.Width) es menor a
2.1 cm

Planteamiento de hipótesis:
H0: mean.Petal.Width.virginica >= 2.1
H1: mean.Petal.Width.virginica < 2.1"

t.test(iris[iris$Species == "virginica","Petal.Width"], alternative = 'less', mu = 2.1) #p = 0.0313

"No se puede rechazar la hipótesis nula a un nivel de confianza del 99%, es decir, no existe 
evidencia suficiente para concluir que el ancho del pétalo de I. virginica de acuerdo a los
datos recolectados por Anderson es menor a 2.1 cm.

3. En promedio, el largo del pétalo de la especie virgínica es 1.1 cm más grande que
el promedio del largo del pétalo de la especie versicolor.

Planteamiento de hipótesis:
H0: La diferencia entre el mean.Petal.Length.virginica y mean.Petal.Length.versicolor = 1.1
  mean.Petal.Length.virginica = mean.Petal.Length.versicolor
H1: La diferencia entre el mean.Petal.Length.virginica y mean.Petal.Length.versicolor != 1.1"
  

var.test(iris[iris$Species == "virginica", "Petal.Length"], 
         iris[iris$Species == "versicolor", "Petal.Length"], 
         ratio = 1, alternative = "two.sided") #p = 0.2637

"Planteamiento de hipótesis de varianza
H0: Las varianzas son iguales
H1: Las varianzas son diferentes
No se rechaza la hipótesis nula"

t.test(x = iris[iris$Species == "virginica", "Petal.Length"], y = iris[iris$Species == "versicolor", "Petal.Length"],
       mu = 1.1, alternative = "greater", var.equal = TRUE)#p =0.06405


"No se puede rechazar la hipótesis nula a un nivel de confianza del 99%, por lo que,
en promedio, el largo del pétalo de la especia virginica no es 1.1 cm más grande que
el largo del pétalo de la especia versicolor en los datos recolectados por Anderson,
a diferencia de lo recolectado en los nuevos estudios

4. En promedio, no existe diferencia en el ancho del sépalo entre las 3 especies.

Planteamiento de hipótesis:
H0: mean.Sepal.Width.virginica = mean.Sepal.Width.versicolor = mean.Sepal.Width.setosa
H1: mean.Sepal.Width.virginica != mean.Sepal.Width.versicolor != mean.Sepal.Wdith.setosa"

boxplot(Sepal.Width ~ Species, data = iris)

anova <- aov(Sepal.Width ~ Species,
             data = iris) #p = <2e-16

summary(anova)

"Con un nivel de confianza del 99%, se rechaza la hipótesis nula, por lo que, sí existe
diferencia entre el ancho del sépalo entre las 3 especies de acuerdo a los datos 
recolectados por Anderson, a diferencia de lo recolectado en los nuevos estudios."
