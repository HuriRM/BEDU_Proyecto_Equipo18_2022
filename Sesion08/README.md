# Postwork 08 Equipo 18

## :diamonds: Miembros del Equipo 18
- Silvia Fernández Sabido
- Yutzil Lora Cabrera
- Norma Paulina López Zamora
- Ricardo Alejandro Gutiérrez Rocha
- José Miguel Carreño Gómez
- Hurí Rodríguez Morlet

## OBJETIVO

- Realizar un análisis estadístico completo de un caso
- Publicar en un repositorio de Github el análisis y el código empleado

## REQUISITOS

- Haber realizado los works y postworks previos
- Tener una cuenta en Github o en RStudioCloud

## DESARROLLO
Un centro de salud nutricional está interesado en analizar estadísticamente y probabilísticamente
los patrones de gasto en alimentos saludables y no saludables en los hogares mexicanos con base en
su nivel socioeconómico, en si el hogar tiene recursos financieros extras al ingreso y en si
presenta o no inseguridad alimentaria. Además, está interesado en un modelo que le permita
identificar los determinantes socioeconómicos de la inseguridad alimentaria.

La base de datos es un extracto de la Encuesta Nacional de Salud y Nutrición (2012) levantada 
por el Instituto Nacional de Salud Pública en México. La mayoría de las personas afirman que los 
hogares con menor nivel socioeconómico tienden a gastar más en productos no saludables que las 
personas con mayores niveles socioeconómicos y que esto, entre otros determinantes, lleva a que 
un hogar presente cierta inseguridad alimentaria.

La base de datos contiene las siguientes variables:

- nse5f (Nivel socieconómico del hogar): 1 "Bajo", 2 "Medio bajo", 3 "Medio", 4 "Medio alto", 5 "Alto"
- area (Zona geográfica): 0 "Zona urbana", 1 "Zona rural"
- numpeho (Número de persona en el hogar)
- refin (Recursos financieros distintos al ingreso laboral): 0 "no", 1 "sí"
- edadjef (Edad del jefe/a de familia)
- sexojef (Sexo del jefe/a de familia): 0 "Hombre", 1 "Mujer"
- añosedu (Años de educación del jefe de familia)
- ln_als (Logarítmo natural del gasto en alimentos saludables)
- ln_alns (Logarítmo natural del gasto en alimentos no saludables)
- IA (Inseguridad alimentaria en el hogar): 0 "No presenta IA", 1 "Presenta IA""

Plantea el problema del caso
Realiza un análisis descriptivo de la información
Calcula probabilidades que nos permitan entender el problema en México
Plantea hipótesis estadísticas y concluye sobre ellas para entender el problema en México
Estima un modelo de regresión, lineal o logístico, para identificiar los determinantes de la inseguridad alimentaria en México
Escribe tu análisis en un archivo README.MD y tu código en un script de R y publica ambos en un repositorio de Github.
NOTA: Todo tu planteamiento deberá estar correctamente desarrollado y deberás analizar e interpretar todos tus resultados para poder dar una conclusión final al problema planteado."


1.- Plantea el problema del caso.
Con base a los obtenidos por la ENSANUT, el centro de Salud nutricional esta interesado en:

a) Analizar estadísticamente y probabilísticamente los patrones de gasto en alimentos saludables
y no saludables en los hogares mexicanos con base en:

 I. Su nivel socioeconómico.

 II.Si el hogar tiene recursos financieros extrar al ingreso.

 III. Si presenta o no inseguridad alimentaria.

b) La generación de un modelo que le permita identificar los determinantes socioeconómicos de la
inseguridad alimentaria.

c) Evaluar si existe evidencia estadística para determinar si los hogares con menor nivel
socioeconómico tienden a gastar más en productos no saludables que las personas con
mayores niveles socioeconómicos.

2. Realiza un analisis descriptivo de la información

Analizando la base de datos, se observa valores faltantes con la siguiente proporción por cada variable:

- ln_alns: 42.89% de NAs
- edadjef: 12.29% de NAs
- sexojef: 12.23% de NAs
- ln_als: 1.92% de NAs

Para el manejo de datos faltantes existen dos opciones:

- Imputación de datos por distintos mecanismos.
- Eliminación de las unidades de información faltantes.

La manera más sencilla para resolver esto pero bibliográficamente más discutida (Cañizares et.al., 2004), consiste en eliminar las unidades de información incompletas y quedarse con una base de datos más pequeña pero completa. Esto podría producir un impacto en la precisión y potencia de las estimaciones. Además, los sesgos pueden ser graves cuando el mecanismo que genera los datos ausentes no puede ser ignorado, siendo este nuestro caso.

En caso de trabajar con una base de datos completa, estaríamos conservando solo el 51% de la base de datos original. Por todo lo anterior, se decide realizar imputación de datos vía parámetros de tendencia central, según la distribución de la variable.

Debido a que, la variable edadjef y ln_als muestran probable sesgo, se utiliza la mediana para sustituir los valores nulos. Para la variable ln_alns, se sustituyen los valores nulos por la media.

Para el caso del sexo, se hace uso de la funcion complete.cases ya que al evaluar entre las ventajas/desventajas de imputar datos u omitirlos, se decidió omitir el 12.23% de la base de datos original.

Para el correcto análisis de la información se decide factorizar las siguientes variables:

- nse5f con etiquetas ordinales: "Bajo", "Medio Bajo", "Medio", "Medio Alto" y  "Alto"
- area con etiquetas “Zona urbana” y “Zona rural”
- refin con etiquetas “Si” y ”No”
- sexo con etiquetas “Hombre” y ”Mujer”
- IA con etiquetas "No presenta IA" y "Presenta IA"

Partiendo de una base de datos de 40 809 observaciones, tras el proceso de limpieza de datos, imputación de datos y eliminación de filas, el tamaño de la muestra probabilística es de 35 818 observaciones para cada una de las 10 variables (descritas al inicio del script), las cuales permiten contar con estimaciones en un conjunto amplio de indicadores sobre la inseguridad alimentaria en México de acuerdo a la ENSANUT 2012.

Tras analizar la nueva base de datos y obtener las medidas de tendencia central, desviación estándar, percentiles, rangos intercuartílicos y generando distintas graficas, la información nos empieza a dar las primeras perspectivas sobre la ENSANUT 2012 y la situación en México.

Considerando que cada observación contenida en la base de datos de la ENSANUT 2012 fue generada hogar por hogar, el promedio de la edad del jefe/a de  familia es de 49 años, teniendo el cuartil inferior (25%) debajo de los 37 años, el cuartil mediano (50%) debajo de los 47 años y el cuartil superior (75%) debajo de los 60 años. Sabemos que la edad mínima del jefe de familia fue de 18 años y la máxima encontrada fue de 111 años, teniendo valores atípicos al sobrepasar el Q3 por más de 1.5 veces el IQR = 23 años.

Comparando los promedios se observa que en la muestra de estudio, el gasto en alimentos saludables tiene un promedio mayor (ln_alns 6.05 > ln_als 4.12) lo cual no necesariamente representa que exista un mayor consumo de estos alimentos saludables, si no la posible representación del costo que pueden tener estos alimentos.

Si fuese el costo el condicionante del aumento en el gasto de alimentos saludables, seria mas fácil la adquisicion de alimentos no saludables lo cual podría tener influencia en la inseguridad alimentaria pues normalmente estos alimentos son hipercalóricos pero deficientes en macro y micro nutrientes.

Considerando que la ENSANUT 2012 nos proporciona los datos particulares de cada uno de los 35818 hogares encuestados, vemos que en un 75.26% el jefe de familia es Hombre y en un 24.74% es Mujer. El promedio de los años de educación del jefe/a de familia es de 9 años, lo cual traducido al sistema educativo mexicano, correspondiendo al nivel Secundaria (6 años de primaria más 3 de secundaria). Teniendo en cuenta que comúnmente los ingresos están relacionados con el nivel de educación de las personas, esto nos puede dar una idea de la facilidad/dificultad con la que las personas puedan tener y mantener una alimentación sana. 

Otra variable relevante de la ENSANUT 2012 es el número de personas en el hogar, pues la dieta que se presente en un hogar será diferente para el número de personas en el hogar donde se observa que en promedio por hogar hay 4 habitantes, siendo esto también la moda de la variable. 

Por último, los datos de la muestra corresponden a 23075 hogares de la zona urbana con un 64.42% y 12743 hogares en la zona rural con un 35.57%.

Cabe mencionar que la ENSANUT 2012 se aplicó a diferentes niveles socioeconómicos con la siguientes proporción: 

- 22.28% pertenece a un nivel socioeconómico Bajo,
- 21.34% a un nivel socioeconómico Medio Bajo.
- 20.25%, a un nivel socioeconómico Medio.
- 19.12%, a un Nivel Socioeconómico Medio Alto.
- 16.9%, a un Nivel Socioeconómico Alto.

Los datos también nos dicen que el 80.98% no recibe ingresos extra a su salario y el 19.02% sí los recibe.

### Casos con Inseguridad Alimentaria

Considerando únicamente los casos donde existe Inseguridad Alimentaria (74.09%), observamos lo siguiente:

El sexo del jefe de familia es Hombre en 74.73% de los casos y es Mujer en un 25.27% de los casos.

La inseguridad alimentaria se presenta en todo los niveles socioeconómicos con la siguiente proporción:

- 26.18% pertenece a un Nivel Socioeconómico Bajo
- 23.67% a un Nivel Socioeconómico Medio Bajo
- 21.30% a un Nivel Socioeconómico Medio
- 17.47% a un Nivel Socioeconómico Medio Alto
- 11.36% a un Nivel Socioeconómico Alto. 

Claramente se puede observar que el porcentaje de Inseguridad Alimentaria disminuye mientras más alto sea el nivel socioeconómico.

Respecto a la zona geográfica donde existe Inseguridad Alimentaria, el 61.1% habita en Zona Urbana y el 38.9% habita en Zona Rural.
Teniendo en cuenta que el total de observaciones es de 35818 y que solo en 26541 se presenta IA, es decir, en el 74.09%, es posible que en 7 de cada 10 hogares exista inseguridad alimentaria.

De las familias que cuentan con ingresos extra (6814 obs), el 80.52% presenta inseguridad alimentaria y el 19.47% no presenta Inseguridad Alimentaria. Sabiendo que este ingreso extra al salario se debe a algún tipo de apoyo económico, nos da una idea de la efectividad y alcance que tienen estos programas pudiendo tomar estos datos para encuestas futuras y evaluar el rendimiento de los programas de apoyo, comprobar si aumenta o disminuye este indicador.

Volviendo a la muestra que contiene todos los casos, después de crear boxplots para observar el gasto de alimentos saludables y no saludables para cada nivel socioeconómico, se observa como en el boxplot de Ln Gasto en Alimentos Saludables pareciera incrementar el gasto mientras más alto sea el Nivel Socioeconómico. Sin embargo, no es tan marcado este mismo patrón para Ln Gasto en Alimentos No Saludables.

Y por último, al graficar por localidad de residencia, el porcentaje de consumidores de alimentos saludables parece ser mayor en localidades urbanas en comparación con las rurales.

3. Calcula probabilidades que nos permitan entender el problema en México.

Se planteó la cuestión de cuál sería la probabilidad de que el jefe de familia tenga más de 60 años. Se obtuvo un resultado de 24.3426% Lo que nos indicaría una población mayormente joven.

Adicionalmente, se calculó cuál sería la probabilidad de que el jefe de familia tenga entre 30 y 50 años. Se obtuvo una probabilidad de 41.03%, la cual refuerza la conclusión anterior.

Por último, se planteó la cuestión de cuál sería la probabilidad de que el jefe de familia tenga al menos un grado universitario. Para esto se consideraron 17 años de estudio (6 de primaria, 3 de secundaria, 3 de preparatoria y 5 de universidad). El resultado obtenido fue de tan sólo 8.07%.

4. Plantea hipótesis estadísticas y concluye sobre ellas para entender el problema en México

Se realizó el planteamiento de diferentes hipótesis que nos permitieron entender el problema en México. 

Hipótesis 1. El ENSANUT 2012 señala que el promedio del número de habitantes por casa es igual a 3.89 (Institución Nacional de Salud Pública, 2012).

Planteamiento de hipótesis estadísticas

- Ho: prom.ENSANUT.oficial = prom.numpeho
- Ha:prom.ENSANUT.oficial != prom.numpeho

Para resolver este problema se realizó una prueba de t de Student y el resultado que se obtuvo fue el siguiente.

t = -1.5016, df = 35817, p-value = 0.1332

Conclusión: Con un nivel de confianza del 95%, no se rechaza la hipótesis nula, por lo que el promedio calculado por el ENSANUT del número de habitantes por hogar es igual al promedio del número de habitantes en esta muestra"


Hipótesis 2. El gasto en alimentos saludables es igual en los diferentes niveles socioeconómicos

Planteamiento de hipótesis:

- Ho: prom_ln_als_nse5f1 = prom_ln_als_nse5f2 = prom_ln_als_nse5f3 = prom_ln_als_nse5f4 = prom_ln_als_nse5f5 
- Ha: prom_ln_als_nse5f1 != prom_ln_als_nse5f2 != prom_ln_als_nse5f3 != prom_ln_als_nse5f4 != prom_ln_als_nse5f5

Para resolver este problema se realizó una prueba ANOVA y el resultado obtenido fue el siguiente:

F value = 1277, Df = 4, Pr(>F) = <2e-16

Con un nivel de confianza del 95%, se rechaza la hipótesis nula, por lo que, hay evidencia estadística de que el gasto en alimentos saludables es diferente en al menos un nivel socioeconómico. Para determinar entre qué grupos hay diferencias se procede a realizar una prueba posthoc. Observando que hay una diferencia significativa con un p = <2e-16 entre cada nivel socioeconómico. La prueba posthoc nos permute concluir, con un nivel de confianza del 95%, que existe evidencia estadística de que el gasto en alimentos saludables es diferente entre todos los niveles socioeconómicos.

Hipótesis 3. Evaluar si existe evidencia estadística para determinar si los hogares con menor nivel socioeconómico tienden a gastar más en productos no saludables que los hogares con mayores niveles socioeconómicos

Planteamiento de hipótesis de varianzas:

- Ho: var.nse5f1.ln_alns = var.nse5f5.ln_alns
- Ha: var.nse5f1.ln_alns != var.nse5f5.ln_alns

Para resolver este problema se realizó una prueba para determinar que las varianzas son iguales, donde se obtuvo una p = <2.2e-16, por lo que, con un nivel de confianza del 95%, existe evidencia estadística para rechazar la hipótesis nula, por lo que las varianzas son diferentes.

Planteamiento de hipótesis:

- Ho: prom.nse5f1.ln_alns = prom.nse5f5.ln_alns
- Ha: prom.nse5f1.ln_alns != prom.nse5f5.ln_alns

Para resolver este problema se realizó una prueba t de Student de doble cola, donde se obtuvo una p = <2.2e-16, por lo que, con un nivel de confianza del 95%, existe evidencia estadística para rechazar la hipótesis nula, por lo que la evidencia parece indicar que el gasto en alimentos no saludables entre el nivel socioeconómico bajo y alto son diferentes.

Se calcularon las medias de gastos en alimentos no saludables y saludables por nivel socioeconómico. 

Hipótesis 4: El promedio del gasto en alimentos no saludables en un nivel socioeconomico bajo es mayor que el promedio del gasto en alimentos no saludables en un nivel socioeconómico alto. 

Planteamiento de hipótesis:

- Ho: prom.ln_alns.nse5f1(3.93) <= prom.ln_alns.nse5f5
- Ha: prom.ln_alns.nse5f1(3.93) > prom.ln_alns.nse5f5

Para resolver este problema se realizo una prueba t de Student de cola superior, en el cual se obtuvo una p = <2.2e-16. Por lo que se concluyó, que con un nivel de confianza del 95%, existe evidencia estadística para rechazar la hipótesis nula, por lo que el promedio del gasto en alimentos no saludables en un nivel socioeconómico bajo es mayor que en un nivel socioeconómico alto.

Hipótesis 5: El gasto en alimentos NO saludables es igual en los diferentes niveles socioeconómicos.

Planteamiento de hipótesis:

- Ho: prom_ln_alns_nse5f1 = prom_ln_alns_nse5f2 = prom_ln_alns_nse5f3 = prom_ln_alns_nse5f4 = prom_ln_alns_nse5f5 
- Ha: prom_ln_alns_nse5f1 != prom_ln_alns_nse5f2 != prom_ln_alns_nse5f3 != prom_ln_alns_nse5f4 != prom_ln_alns_nse5f5

Para resolver este problema se realizó una prueba ANOVA y el resultado obtenido fue el siguiente:

F value = 501, Df = 4, Pr(>F) = <2e-16

Con un nivel de confianza del 95%, se rechaza la hipótesis nula, por lo que, hay evidencia estadística de que el gasto en alimentos no saludables es diferente en al menos un nivel socioeconómico. Para determinar entre qué grupos hay diferencias se procede a realizar una prueba posthoc. Observando que hay una diferencia significativa con un p = <2e-16 entre cada nivel socioeconómico. La prueba posthoc nos permute concluir, con un nivel de confianza del 95%, que existe evidencia estadística de que el gasto en alimentos no saludables es diferente entre todos los niveles socioeconómico.
 
5. Estima un modelo de regresión, lineal o logístico, para identificiar los determinantes de la inseguridad alimentaria en México

Se calcularon los coeficientes de correlación de Pearson entre pares de variables cuantitativas para determinar los factores que afectan los montos de los gastos en alimentos saludables y no saludables, los cuales sugieren que de manera general:

Gasto en alimentación saludable = f(número. personas en el hogar, años educación del jefe de familia, gasto en alimentación no saludable)

Gastos en alimentación no saludable = f(años educación del jefe de familia, gasto en alimentación saludable)

Según estos análisis 

El gasto en alimentos saludables parece determinado por: 

- núm de personas en el hogar
- años de educación del jefe de familia
- gasto en alimentos no saludables

El gasto en alimentación NO-saludable parece determinado por:

- años de educación del jefe de familia
- gasto en alimentos saludables

### Modelos de regresión lineal

Tomando como base el resultado de los puntos 4 y 5, se construyeron modelos de regresión lineal y se fueron añadiendo otras variables y sus interacciones.

Gasto en alimentos saludables

Modelo base:

```R
lm.s <- lm(ln_als ~ numpeho + añosedu + ln_alns, df.c)
summary(lm)
```
Que tiene una R-cuadrada ajustada = 0.189

A este modelo se le fueron añadiendo otras variables cuantitativas y categóricas, así como interacciones entre ellas, para buscar un mejor ajuste. Se probaron las siguientes opciones:

```R
m1 <- lm(ln_als ~ nse5f + area + numpeho + refin + edadjef + sexojef + añosedu + IA+ ln_alns) # R cuad ajust = 0.2506

m1.5 <- lm(ln_als ~ nse5f + area + numpeho + refin + edadjef + añosedu + IA+ ln_alns) #0.2506

m2 <- lm(ln_als ~ nse5f + nse5f:area + area + numpeho + refin + edadjef + sexojef + añosedu + IA+ ln_alns) #0.2512

m3 <- lm(ln_als ~ nse5f + nse5f:numpeho + area + numpeho + refin + edadjef + sexojef + añosedu + IA+ ln_alns) #0.2505

m4 <- lm(ln_als ~ nse5f + nse5f:refin + area + numpeho + refin + edadjef + sexojef + añosedu + IA+ ln_alns) #0.2506

m5 <- lm(ln_als ~ nse5f + nse5f:edadjef + area + numpeho + refin + edadjef + sexojef + añosedu + IA+ ln_alns) #0.2524, mejora

m5.5 <- lm(ln_als ~ nse5f + nse5f:edadjef + area + numpeho + edadjef:sexojef+ refin + edadjef + sexojef + añosedu + IA+ ln_alns) #0.2528

m6 <- lm(ln_als ~ nse5f + nse5f:sexojef + area + numpeho + refin + edadjef + sexojef + añosedu + IA+ ln_alns) #0.2506

m7 <- lm(ln_als ~ nse5f + nse5f:añosedu + area + numpeho + refin + edadjef + sexojef + añosedu + IA+ ln_alns) #0.2507
```
De los modelos de regresión lineal para el gasto en alimentos saludables, se escoge el modelo m1.5 sin interacciones ya que el sexojef no fue significativo pero al considerar interacciones se escoge el modelo m5.5, donde se consideran como determinantes las siguientes interacciones: nse5f:edadjef, edadjef:sexojef

Gasto en alimentos no saludables:

Repitiendo el proceso para el gasto en alimentos no saludables

Modelo base:

```R
lm.ns <- lm(ln_alns ~ añosedu + ln_als, df.c) # R-cuadrada ajustada = 0.06247
```

Vamos probando otras variables y sus interacciones:

```R
m8 <- lm(ln_alns ~ nse5f + refin + ln_als + IA) #0.07963

m9 <- lm(ln_alns ~ nse5f + ln_als + IA) #0.0797

m10 <- lm(ln_alns ~ nse5f + ln_als + IA + nse5f:ln_als) #0.0852

m11 <- lm(ln_alns ~ nse5f + ln_als + IA + nse5f:ln_als + nse5f:IA) #0.0854

m12 <- lm(ln_alns ~ nse5f + ln_als + IA + nse5f:ln_als + ln_als:IA) #0.0852
```

El modelo m8 considera sólo las variables planteadas en la hipótesis original, pero encontramos que la variable refin no es significativa por lo que se elige el modelo m9. 
Dentro de los modelos donde se consideran las interacciones, se elige el modelo m11 con las interacciones con el nivel socioeconómico.

### Modelos de regresión logística

Para encontrar los factores determinantes de la Inseguridad Alimentario dentro de esta muestra, se usó el método de regresión logística con un enfoque aditivo y mixto para las interacciones. Se empezó con un modelo de solo una variable:

```R
logistic.1 <- glm(IA ~ nse5f, 
                  data = df.c, family = binomial)
```

A este modelo se le fueron agregando todas las variables primero sin interacciones. 

El rango del criterio de informacion de Akaike (AIC) dentro de los modelos con variables individuales fue de 38087 (solo una variable) a 37020 (con todas las variables). De igual manera se obtuvo un rango de la pseudo R-cuadrada de 0.0708 (solo una variable) a 0.0972 (con todas las variables). En el modelo que contaba cn todas las variables se observó que la variable individual de Edad de Jefe de Familia no se correlacionaba significativamente a un nivel de confianza del 95%, por lo que se elaboró otro modelo sin esa variable obteniendo lo siguiente:

```R
logistic.9 <- glm(IA ~ nse5f + numpeho + refin + sexojef + añosedu + ln_als + ln_alns, 
                  data = df.c, family = binomial)
summary(logistic.9) #AIC = 37018
pseudo_r2.9 <- (logistic.9$null.deviance - logistic.9$deviance)/logistic.9$null.deviance
pseudo_r2.9 #0.0971
```

La pseudo R-cuadrada del modelo sin la variabla de edadjef (pseudo R2 = 0.0971 no disminuye considerablemente y todas las demas variables permanecen significativas con un nivel de confianza del 95%. 

A continuacion se evaluaron modelos con diferentes interacciones con un rango de AIC de 36991 a 36913. De igual manera se obtuvo un rando de la pseudo R-cuadrada de 0.0979 a 0.1003. Teniendo en cuanta las interacciones se obtuvo el siguiente modelo con el mejor AIC y la mejor R-cuadrada sin caer en sobreajuste. 

```R
logistic.14 <- glm(IA ~ nse5f:numpeho + nse5f + nse5f:edadjef + numpeho:añosedu + numpeho:ln_als+ numpeho + refin + edadjef:sexojef + sexojef + añosedu + ln_als + ln_alns, 
                   data = df.c, family = binomial)
summary(logistic.14) #AIC = 36911
pseudo_r2.14 <- (logistic.14$null.deviance - logistic.14$deviance)/logistic.14$null.deviance
pseudo_r2.14 #0.1003
```

En conclusión, se encontró que los determinantes de la Inseguridad Alimentaria son las variables por sí solas, asi como las siguientes interacciones:

- Nivel socioeconómico con número de personas en el hogar
- Nivel socioeconómico con edad del jefe de familia
- Número de personas en el hogar con años de educación 
- Número de personas en el hogar con el gasto en alimentos saludables
- Edad y sexo del jefe de familia

## Referencias

 Cañizares, M., Barroso, I., & Alfonso, K. (2004). Datos incompletos: una mirada crítica para su manejo en estudios sanitarios. Gaceta Sanitaria,           18(1), 58–63. https://scielo.isciii.es/scielo.php?script=sci_arttext&pid=S0213-91112004000100010#t1
 
 
 Institución Nacional de Salud Pública. (2012). Encuesta Nacional de Salud y Nutrición Resultados Nacionales 2012 (C. Oropeza Abundez, F. Reveles, J. J. García Letechipia, & S. De Voghel Gutiérrez, Eds.; pp. 1–200) [Review of Encuesta Nacional de Salud y Nutrición Resultados Nacionales 2012]. Instituto Nacional de Salud Pública. https://ensanut.insp.mx/encuestas/ensanut2012/doctos/informes/ENSANUT2012ResultadosNacionales.pdf

