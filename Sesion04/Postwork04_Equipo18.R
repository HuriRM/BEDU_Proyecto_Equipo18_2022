#Postwork4

#Utilizando la variable total_intl_charge de la base de datos telecom_service.csv de la sesión
#3, realiza un análisis probabilístico. Para ello, debes determinar la función de distribución
#de probabilidad que más se acerque el comportamiento de los datos. Hint: Puedes apoyarte de
#medidas descriptivas o técnicas de visualización.

telecom <- read.csv("https://raw.githubusercontent.com/beduExpert/Programacion-R-Santander-2022/main/Sesion-03/Data/telecom_service.csv")
mean <- mean(telecom$total_intl_charge) #2.76
sd <- sd(telecom$total_intl_charge) #0.75
library(DescTools)
moda <- Mode(telecom$total_intl_charge) #2.7
mediana <- median(telecom$total_intl_charge) #2.78

?hist()
hist(telecom$total_intl_charge, main = "Distribucion Total Intl Charge")

"Tras obtener las medidas de tendencia central, se observa que la media, mediana y 
moda tienen valores similares, así mismo el histograma pareciera demostrar 
simetría, por lo que se concluye que la variable total_intl_charge se distribuye
de manera normal"

#Una vez que hayas seleccionado el modelo, realiza lo siguiente:
  
#Grafica la distribución teórica de la variable aleatoria total_intl_charge

curve(dnorm(x, mean = mean, sd = sd), from=0, to=5.4, 
      col='blue', main = "Distribucion Total Intl Charge",
      ylab = "f(x)", xlab = "X")

#¿Cuál es la probabilidad de que el total de cargos internacionales sea menor a
#1.85 usd?  


pnorm(q = 1.85, mean = mean, sd = sd) "R = 0.1125"
  
 #¿Cuál es la probabilidad de que el total de cargos internacionales sea mayor a 3 usd?

pnorm(q = 3, mean = mean, sd = sd, lower.tail = FALSE) # R = 0.3774
  
"¿Cuál es la probabilidad de que el total de cargos internacionales esté entre 2.35usd 
y 4.85 usd?"

pnorm(q = 4.85, mean = mean, sd = sd) - pnorm(q = 2.35, mean = mean, sd = sd) #R = 0.7060
  
"Con una probabilidad de 0.48, ¿cuál es el total de cargos internacionales más alto que
podría esperar?"

qnorm(p = 0.48, mean = mean, sd = sd) # R = 2.73 USD
  
"¿Cuáles son los valores del total de cargos internacionales que dejan exactamente al centro 
el 80% de probabilidad?"

qnorm(p = .1, mean = mean, sd = sd); qnorm(p = .9, mean = mean, sd = sd)
"R = 1.8 USD y 3.73 USD"
