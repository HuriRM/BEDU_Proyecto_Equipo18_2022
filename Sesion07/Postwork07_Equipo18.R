"Utilizando el siguiente vector numérico, realiza lo que se indica:"
install.packages("forecast")
library(forecast)
  
url = "https://raw.githubusercontent.com/beduExpert/Programacion-R-Santander-2022/main/Sesion-07/Data/global.txt"

"Crea un objeto de serie de tiempo con los datos de Global. La serie debe ser mensual comenzando en Enero de 1856
Realiza una gráfica de la serie de tiempo anterior
Ahora realiza una gráfica de la serie de tiempo anterior, transformando a la primera diferencia
¿Consideras que la serie es estacionaria en niveles o en primera diferencia?
  Con base en tu respuesta anterior, obtén las funciones de autocorrelación y autocorrelación parcial?"

Global <- scan(url, sep="") # lee datos y los pone en un vector o lista, como los requiere una st

Global
head(Global)

# Crea un objeto de serie de tiempo con los datos de Global. 
# La serie debe ser mensual comenzando en Enero de 1856

tsg <- ts(Global, start = c(1856,1), frequency =12) 
tsg
str(tsg) # vemos que va de 1856 a 2006

# Realiza una gráfica de la serie de tiempo anterior

plot(tsg,
     main = "Serie mensual de la temperatura global",
     xlab = "Tiempo",
     sub = "Enero-1856 a diciembre-2006") 

"R= los datos oscilan y existe un punto de inflexión entre 
1900 y 1950 donde inicia una tendencia creciente.
Esto parece concordar con el fenómeno de cambio climático.

Para observar más claramente, descomponemos la serie de tiempo"

plot(decompose(tsg)) 

"la tendencia es creciente y parece haber estacionalidad"

"Analizamos las autocorrelaciones"

acf(tsg) # fuertemente autocorrelacionada
pacf(tsg) # algunas autocorrelaciones fuertes

"Nota: no funciona tomar log porque hay número negativos, lo que produce NAN's'"

"Ahora realiza una gráfica de la serie de tiempo anterior, 
transformando a la primera diferencia"

plot(diff(tsg), type = "l", 
      main = "Primera diferencia de la serie mensual de la temperatura global",
      xlab = "Tiempo", ylab = "Diferencias",
      sub = "Enero-1856 a diciembre-2006")

"R= Ahora los datos parecen estacionarios con media cero y varianza 1 "

# ¿Consideras que la serie es estacionaria en niveles o en primera diferencia?

# R= en primera diferencia, pues varían alrededor de la media 0 con varianza 1

# Con base en tu respuesta anterior, obtén las funciones de autocorrelación y autocorrelación parcial?

acf( diff(tsg) ) # se observa fuerte autocorrelación en algunos valores cercanos a 0 y en 2

pacf( diff(tsg) ) # se observa fuerte autocorrelación en casi todo el rango, esperaba que mejorara
  
"De acuerdo con lo observado en las gráficas anteriores, se sugiere un modelo ARIMA 
con AR(1), I(1) y MA desde 1 a 4 rezagos Estima los diferentes modelos ARIMA propuestos:"

  "ARIMA representa modelos Autorregresivos (AR) Integrados (I) de Media Móvil (MA) y se 
 representan como ARIMA(q,d,p):
- q: Número de términos autorregresivos (de la variable dependiente)
- d: Número de diferencias aplicadas a la variable para hacerla estacionaria
- p: Número de rezagos en el término de error (ruido blanco)"

# R = como son estacionarios se puede usar arima
?arima

  arima(tsg, order = c(1,1,1)) # aic = -2278.26
  arima(tsg, order = c(1,1,2)) # aic = -2306.96
  arima(tsg, order = c(1,1,3)) # aic = -2307.88
  arima(tsg, order = c(1,1,4)) # aic = -2310.39 mejor

  # "7) Con base en el criterio de Akaike, estima el mejor modelo ARIMA y realiza una 
  # predicción de 12 periodos (meses)"
  
  "R = siguiendo el criterio de Akaike el mejor modelo arima es el de 4 rezagos 
  pues tiene el mínimo valor de aic"
  
 mod.elegido <- arima(tsg, order = c(1,1,4), seas = c(2,0,2))
 summary(mod.elegido)

 
 "arima(x = tsg, order = c(1, 1, 4), seasonal = c(2, 0, 2))
 AIC=-2379.11"
 
 
    
 mod.alterno <- auto.arima(tsg, seasonal = TRUE)
 summary(mod.alterno)
 
 "ARIMA(0,1,3)(2,0,0)[12]
 AIC=-2295.69
 "

  prediccion <- predict(mod.elegido,12)
  
  p <- prediccion$pred
  p
  
  "Jan       Feb       Mar       Apr       May       Jun       Jul       Aug
  2006 0.3944191 0.4109006 0.4241679 0.4249647 0.4256583 0.4262620 0.4267875 0.4272449
  Sep       Oct       Nov       Dec
  2006 0.4276430 0.4279895 0.4282911 0.4285537"
  
  ts.plot(cbind(window(tsg, start = 1970), p), col = c("blue", "red"), xlab = "")
  title(main = "Predicción para la serie de temperatura global",
        xlab = "Mes",
        ylab = "Temperatura")
  
