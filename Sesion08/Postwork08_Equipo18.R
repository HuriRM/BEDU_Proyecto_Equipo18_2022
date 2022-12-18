# Equipo 18
#### Proyecto Final “Estadística y Programación con R” ####
"
OBJETIVO
- Realizar un análisis estadístico completo de un caso
- Publicar en un repositorio de Github el análisis y el código empleado

REQUISITOS
- Haber realizado los works y postworks previos
- Tener una cuenta en Github o en RStudioCloud

DESARROLLO
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

La base de datos contiene las siguientes variables:"

# nse5f (Nivel socieconómico del hogar): 1 "Bajo", 2 "Medio bajo", 3 "Medio", 4 "Medio alto", 5 "Alto"
# area (Zona geográfica): 0 "Zona urbana", 1 "Zona rural"
# numpeho (Número de persona en el hogar)
# refin (Recursos financieros distintos al ingreso laboral): 0 "no", 1 "sí"
# edadjef (Edad del jefe/a de familia)
# sexojef (Sexo del jefe/a de familia): 0 "Hombre", 1 "Mujer"
# añosedu (Años de educación del jefe de familia)
# ln_als (Logarítmo natural del gasto en alimentos saludables)
# ln_alns (Logarítmo natural del gasto en alimentos no saludables)
# IA (Inseguridad alimentaria en el hogar): 0 "No presenta IA", 1 "Presenta IA"

"
1. Plantea el problema del caso.
2. Realiza un análisis descriptivo de la información.
3. Calcula probabilidades que nos permitan entender el problema en México.
4. Plantea hipótesis estadísticas y concluye sobre ellas para entender el problema en México.
5. Estima un modelo de regresión, lineal o logístico, para identificiar los determinantes de la 
inseguridad alimentaria en México.
6. Escribe tu análisis en un archivo README.MD y tu código en un script de R y publica ambos en un
repositorio de Github.

NOTA: Todo tu planteamiento deberá estar correctamente desarrollado y deberás analizar e interpretar
todos tus resultados para poder dar una conclusión final al problema planteado."

#### 1.- Plantea el problema del caso. ####
"Con base a los obtenidos por la Encuesta Nacional de Salud y Nutrición 2012 (ENSANUT), el centro 
de Salud nutricional está interesado en:

A) Analizar estadísticamente y probabilísticamente los patrones de gasto en alimentos saludables
y no saludables en los hogares mexicanos con base en:

      I. Su nivel socioeconómico.

      II.Si el hogar tiene recursos financieros extra al ingreso.

     III. Si presenta o no inseguridad alimentaria.

B) La generación de un modelo que le permita identificar los determinantes socioeconómicos de la
inseguridad alimentaria.

C) Evaluar si existe evidencia estadística para determinar si los hogares con menor nivel
socioeconómico tienden a gastar más en productos no saludables que las personas con
mayores niveles socioeconómicos"


#### Limpieza de datos ####

# Carga de datos
df<-read.csv("https://raw.githubusercontent.com/beduExpert/Programacion-R-Santander-2022/main/Sesion-08/Postwork/inseguridad_alimentaria_bedu.csv")
str(df)
summary(df)

# Contar el número de NAs total
sum(is.na(df)) #28299

library(VIM)
aggr(df,numbers=T,sortVar=T)
"La columna ln_alns es la columna que presenta el mayor porcentaje de valores 
faltates (42.89%)"

# Contar el número de NAs por columna
sum(is.na(df$ln_alns)) #17504 -> 42.89% de NA's
sum(is.na(df$edadjef)) #5017 -> 12.29% de NA's
sum(is.na(df$sexojef)) # 4991 -> 12.23% de NA's
sum(is.na(df$ln_als)) #787 -> 1.92% de NA's

# Manejo de datos incompletos
"La manera más sencilla para resolver este caso, pero bibliográficamente más discutida,
consiste en eliminar las unidades de información incompletas y quedarse con un df más
pequeño pero completo. Esto podría producir un impacto en la precisión y potencia de las
estmaciones. Además, los sesgos pueden ser graves cuando el mecanismo que genera los datos
ausentes no puede ser ignorado, este nuestro caso."

(nrow(na.omit(df)))/(nrow(df))*100

"En caso de trabajar con un df completo, estariamos conservando solo el 51% del df original.
Por todo lo anterior, se decide realizar procedimientos de imputación"

# Imputacion de valores de acuerdo a las siguientes evaluaciónes

library(DescTools)
hist(na.omit(df$edadjef), main = "Histograma de Edad de Jefe de Familia", 
     xlab = "Edad", ylab = "Cantidad")
mean(na.omit(df$edadjef)) #49.00
median(na.omit(df$edadjef)) #47 
Mode(na.omit(df$edadjef)) #42
# Tiene un sesgo a la derecha

hist(na.omit(df$ln_alns),  main = "Histograma de Gasto en Alimentos No Saludables", 
     xlab = "Logaritmo natural del Gasto", ylab = "Cantidad")
mean(na.omit(df$ln_alns)) #4.12
median(na.omit(df$ln_alns)) #4.03
Mode(na.omit(df$ln_alns)) #3.4
# No parece tener sesgo considerable

hist(na.omit(df$ln_als),  main = "Histograma de Gasto en Alimentos Saludables", 
     xlab = "Logaritmo natural del Gasto", ylab = "Cantidad")
mean(na.omit(df$ln_als)) #6.07
median(na.omit(df$ln_als)) #6.16
Mode(na.omit(df$ln_als)) #6.04
sd(na.omit(df$ln_als)) #0.746
# Tiene un sesgo a la izquierda

"Debido a que, la variable edadjef y ln_als muestran probable sesgo, se utiliza la mediana
para sustituir los valores nulos. Para la variable ln_alns, se sustituyen los valores nulos 
por la media"

df$edadjef[is.na(df$edadjef)] <- median(na.omit(df$edadjef))
# Se sustituyen los NAs en df2$edadjef por la mediana de la columna sin NAs

df$ln_als[is.na(df$ln_als)] <- median(na.omit(df$ln_als))
# Se sustituyen los NAs de df$ln_als con la mediana de las observaciones

df$ln_alns[is.na(df$ln_alns)] <- mean(na.omit(df$ln_alns))
#Se sustituyen los NAs de df$ln_alns con el promedio de las observaciones

"Para el caso del sexo, se hace uso de la funcion complete.cases ya que al evaluar entre las
ventajas/desvetejas de imputarle datos o eliminarlos, se decide eliminarlos"
df.c <- df[complete.cases(df), ]

(nrow(df.c))/(nrow(df))
str(df.c)
"Se crea el nuevo df.c, el cual mantiene el 87.76% del tamaño original"


# Factorizando variables categoricas
df.c$nse5f <- factor(df.c$nse5f, labels = c("Bajo", "Medio Bajo", "Medio", "Medio Alto", "Alto"), 
                     ordered = TRUE)
df.c$IA <- factor(df.c$IA, labels = c("No presenta IA", "Presenta IA"))
df.c$area <- factor(df.c$area, labels = c("Zona Urbana", "Zona Rural"))
df.c$refin <- factor(df.c$refin, labels = c("No", "Sí"))
df.c$sexojef <-factor(df.c$sexojef, labels = c("Hombre", "Mujer"))


#### 2. Realiza un análisis descriptivo de la información. ####
#### General ####
summary(df.c)
str(df.c)
"Partiendo de una dataset de 40 809 observaciones, tras el proceso de limpieza de datos, imputación de
datos y eliminación de filas, el tamaño de la muestra probabilística es de 35 818 observaciones para cada 
una de las 10 variables (descritas al inicio del script), las cuales permiten contar con estimaciones en
un conjunto amplio de indicadores sobre la inseguridad alimentaria en México de acuerdo a la ENSANUT 2012"

# Medidas de tendencia central y dispersión de edadjef
moda.edadjef <- Mode(df.c$edadjef)  #42
mediana.edadjef <- median(df.c$edadjef)  #47 
promedio.edadjef <- mean(df.c$edadjef)  #49.00
de.edadjef <- sd(df.c$edadjef) #15.82

hist(df.c$edadjef, main = "Histograma de Edad de Jefe de Familia",
     xlab = "Edad jefe/a de familia",
     ylab = "Frecuencia")

"Considerando que cada observación contenida en el dataset de la ENSANUT 2012 fue generada hogar por hogar,
el promedio de la edad del jefe/a de  familia es de 49 años, teniendo el cuartil inferior (25%) debajo de 
los 37 años, el cuartil mediano (50%) debajo de los 47 años y el cuartil superior (75%) debajo de los 60 años.
Sabemos que la edad mínima del jefe de familia fue de 18 años y la máxima encontrada fue de 111 años, 
teniendo outliers al sobrepasar el Q3 por más de 1.5 veces el IQR = 23 años."

# Medidas de tendencia central y dispersión de ln_alns
moda.ln_alns <- Mode(df.c$ln_alns) #3.4
mediana.ln_alns <- median(df.c$ln_alns) #4.03
promedio.ln_alns <- mean(df.c$ln_alns)  #4.12
de.ln_alns <- sd(df.c$ln_alns) #0.786

# Medidas de tendencia central y dispersión de ln_als
moda.ln_als <- Mode(df.c$ln_alns) #6.04
mediana.ln_als <- median(df.c$ln_als) #6.16
promedio.ln_als <- mean(df.c$ln_als)  #6.07
de.ln_als <- sd(df.c$ln_als) #0.746

#Histograma de la variable Ln de Gasto en Alimentos
hist(df.c$ln_alns, col = "lightblue", main = "Histograma de Ln de Gasto en Alimentos",
     xlab = " ",
     ylab = "Frecuencia")
hist(df.c$ln_als, col = rgb(1, 0, 0, alpha = 0.5), add = TRUE)
abline(v = promedio.ln_als, col = "red")
abline(v = promedio.ln_alns, col = "blue")
text(promedio.ln_als, par("usr")[3] + 20500, 
     labels = round(c(promedio.ln_als),2) , 
     col = "red", xpd = TRUE)
text(promedio.ln_alns, par("usr")[3] + 20500, 
     labels = round(c(promedio.ln_alns),2) , 
     col = "blue", xpd = TRUE)
legend("topleft", c("ln_alns", "ln_als"), box.lty = 2,
       lty = 1, col = c("blue", "red"), lwd = c(1, 2, 2))

sum(df.c$ln_als)
sum(df.c$ln_alns)

"Comparando los promedios se observa que en la muestra de estudio, el gasto en alimentos saludables tiene
un promedio mayor (ln_alns 6.05 > ln_als 4.12) lo cual no necesariamente representa que exista un mayor 
consumo de estos alimentos saludables, si no la posible representación del costo que pueden tener estos 
alimentos limitando su consumo únicamente a aquellos que les sea posible adquirirlo e integrarlo a la dieta.
En contraste y con el mismo supuesto anterior, para los alimentos no saludables observamos que, 
económicamente hablando, puede ser más fácil su adquisición e integración en la dieta, con lo cual y a reserva 
del análisis estadístico posterior, podría tener influencia en la inseguridad alimentaria pues normalmente
estos alimentos son hipercalóricos pero deficiente en macro y micro nutrientes."

# Medidas de tendencia central y dispersión de numpeho
moda.numpeho <- Mode(df.c$numpeho) #4, el cual se repite 8073 veces
mediana.numpeho <- median(df.c$numpeho) #4
promedio.numpeho <- mean(df.c$numpeho) #3.88

#Histograma de numpeho
hist(df.c$numpeho, xlim = c(0, 15), col = "orange", main = "Número de Personas en el Hogar", 
     xlab = "Numero de personas en el hogar",
     ylab = "Frecuencia")
abline(v = promedio.numpeho, col = "red")
text(promedio.numpeho, par("usr")[3] + 10200, 
     labels = round(c(promedio.numpeho),2) , 
     col = "red", xpd = TRUE)


# Histogramas de Edad de Jefe de Familia y Sexo de Jefe de Familia
library(ggplot2)
ggplot(df.c, aes(x = edadjef, fill = sexojef, color = sexojef)) +
  geom_histogram(alpha = 0.5, position = "identity") +
  xlab("Edad de Jefe de Familia") +
  ylab("Cantidad") +
  ggtitle("Frecuencia de Edad por Sexo") +
  guides(fill = guide_legend(title = "Sexo"),
         colour = guide_legend(title = "Sexo"))

# Medidas de tendencia central y dispersión de añosedu
moda.añosedu <- Mode(df.c$añosedu) #9, el cual se repite 15560 veces
mediana.añosedu <- median(df.c$añosedu) #9
promedio.añosedu <- mean(df.c$añosedu) #10.27 años

#Histograma de añosedu
hist(df.c$añosedu, main = "Años de educación del jefe/a de familia",
     xlab = "Años de educacion",
     ylab = "Frecuencia")

# Proporcion del sexo del jefe/a de familia
transform(table(df.c$sexojef), 
          rel.freq=prop.table(Freq), 
          cum.freq=cumsum(prop.table(Freq)))
" Hombre     Mujer 
  26957     8861
0.7526104 0.2473896"

plot(df.c$sexojef, main = "Obervaciones por sexo del jefe/a de familia")

"Considerando que la ENSANUT 2012 nos proporciona los datos particulares de cada uno de los 35818 hogares 
encuestados, vemos que en un 75.26% el jefe de familia es Hombre y en un 24.74% es Mujer. El promedio de 
los años de educación del jefe/a de familia es de 9 años, lo cual traducido al sistema educativo mexicano,
corresponde al nivel Secundaria (6 años de primaria más 3 de secundaria). Teniendo en cuenta que 
comúnmente los ingresos están relacionados con el nivel de educación de las personas, esto nos puede dar 
una idea de la facilidad/dificultad con la que las personas puedan tener y mantener una alimentación sana.
Otra variable relevante de la ENSANUT 2012 es el número de personas en el hogar, pues la dieta que se 
presente en un hogar será diferente para el número de personas en el hogar donde se observa que en promedio
por hogar hay 4 habitantes, siendo esto también la moda de la variable."

# Propoción del area (Zona geografica)
transform(table(df.c$area), 
          rel.freq=prop.table(Freq), 
          cum.freq=cumsum(prop.table(Freq)))
"Zona Urbana  Zona Rural
  23075       12743
  0.6442292   0.3557708"

plot(df.c$area, main = "Observaciones por Zona Geografica", col = "lightblue")

# Propoción por nivel socioeconomico
plot(df.c$nse5f, main = "Histograma del Nivel socioeconomico", ylab = "Frecuencia",
     col = "green")
transform(table(df.c$nse5f), 
          rel.freq=prop.table(Freq), 
          cum.freq=cumsum(prop.table(Freq)))

"Por último, los datos de la muestra corresponden a 23075 hogares de la zona urbana con un 64.42% y 
12743 hogares en la zona rural con un 35.57%, Cabe mencionar que la ENSANUT 2012 se aplicó a diferentes 
niveles socioeconómicos con la siguientes proporción:
22.28% pertenece a un nivel socioeconómico Bajo,
21.34% a un nivel socioeconómico Medio Bajo.
20.25%, a un nivel socioeconómico Medio.
19.12%, a un Nivel Socioeconómico Medio Alto.
16.9%, a un Nivel Socioeconómico Alto."

# Propoción de los que reciben ingresos extras
transform(table(df.c$refin), 
          rel.freq=prop.table(Freq), 
          cum.freq=cumsum(prop.table(Freq)))
"   No        Sí 
0.8097605 0.1902395 
  29004     6814"

"Dentro de la muestra, el 80.98% no recibe ingresos extra a su salario y el 19.02% sí los recibe"

#### Casos con IA ####
# Propoción por presencia de Inseguridad Alimentaria
plot(df.c$IA, main = "Histograma de la IA", ylab = "Frecuencia", col = "yellow")
prop.table(table(df.c$IA)) 
"No presenta IA     Si presenta IA 
    25.90%            74.09%"
"Considerando únicamente los casos donde existe Inseguridad Alimentaria (74.09%), observamos lo 
siguiente:"

# Creacion de df apoyo "IA.Si"
IA.Si <- df.c[df.c$IA ==  "Presenta IA",]

# Propoción por sexo del jefe/a de familia
plot(IA.Si$sexojef, main = "Sexo del jefe de hogar con IA", ylab= "Frecuencia", col = "brown")
prop.table(table(IA.Si$sexojef))
"Hombre    Mujer 
0.747259 0.252741 "
"En las familias que presentan Inseguridad Alimentaria, el sexo del jefe de familia es Hombre en 74.73% 
de los casos y es Mujer en un 25.27% de los casos."


# Propoción por nivel socioeconomico
transform(table(IA.Si$nse5f), 
          rel.freq=prop.table(Freq), 
          cum.freq=cumsum(prop.table(Freq)))

#Gráfica de observaciones con Inseguridad Alimentaria por Nivel Socioeconómico
ggplot(data = IA.Si, aes(x = nse5f)) +
  geom_bar(fill = "light blue", color = "dark blue")+
  xlab("Nivel Socioeconómico") + ylab("Frecuencia")+
  ggtitle("Inseguridad Alimentaria por Nivel Socioeconómico") +
  theme_minimal() +
  theme(axis.title.x = element_text(margin=margin(t=20)))

"La inseguridad alimentaria se presenta en todo los niveles socioeconómicos con la siguiente proporción:
26.18% pertenece a un Nivel Socioeconómico Bajo
23.67% a un Nivel Socioeconómico Medio Bajo
21.30% a un Nivel Socioeconómico Medio
17.47% a un Nivel Socioeconómico Medio Alto
11.36% a un Nivel Socioeconómico Alto. 
Claramente se puede observar que el porcentaje de Inseguridad Alimentaria disminuye mientras más alto sea 
el nivel socioeconómico."

# Propoción por area (Zona geografica)
transform(table(IA.Si$area), 
          rel.freq=prop.table(Freq), 
          cum.freq=cumsum(prop.table(Freq)))
"              Frecuencia    %
Zona Urbana     16217     61.10
Zona Rural      10324     38.89"

length(IA.Si$IA)/length(df.c$IA)

"Respecto a la zona geográfica donde existe IA, el 61.1% habita en Zona Urbana y el 38.9% habita en Zona
Rural.Teniendo en cuenta que el total de observaciones es de 35818 y que solo en 26541 se presenta IA,es 
decir, en el 74.09%, es posible que en 7 de cada 10 hogares exista inseguridad alimentaria."

# Creacion de df apoyo "refin.si"
refin.si <- df.c[df.c$refin ==  "Sí",]
# Propoción de los que reciben ingresos extras
transform(table(refin.si$IA), 
          rel.freq=prop.table(Freq), 
          cum.freq=cumsum(prop.table(Freq)))
"No presenta IA   Si presenta IA 
  0.1947461          0.8052539 
    1327               5487"

"De las familias que cuentan con ingresos extras (6814 obs), el 80.52% presenta inseguridad 
alimentaria y el 19.47% no presenta Inseguridad Alimentaria. Sabiendo que este ingreso extra al salario 
debe a algún tipo de apoyo económico, nos da una idea de la efectividad y alcance que tienen estos programas 
pudiendo tomar estos datos para encuestas futuras y evaluar el rendimiento de los programas de apoyo, 
comprobar si aumenta o disminuye este indicador."

#### Graficas extras de utilidad ####
#Gráfica de Ln de Gasto en Alimentos Saludables por Nivel Socioeconómico
ggplot(df.c, aes(x = nse5f, y = ln_als, color = nse5f)) +
  geom_boxplot() +
  xlab("Nivel Socioeconómico") +
  ylab("Gasto en Alimentos Saludables") +
  ggtitle("Gasto en Alimentos Saludables por Nivel Socioeconómico") +
  guides(fill = guide_legend(title = "Nivel\nSocioeconómico"),
         color = guide_legend(title = "Nivel\nSocioeconómico")) +
  theme_get() +
  theme(axis.title.x = element_text(margin=margin(t=10))) +
  theme(plot.title = element_text(hjust = 0.2))


#Gráfica de Ln de Gasto en Alimentos No Saludables por Nivel Socioeconómico
ggplot(df.c, aes(x = nse5f, y = ln_alns, color = nse5f)) +
  geom_boxplot() +
  xlab("Nivel Socioeconómico") +
  ylab("Gasto en Alimentos No Saludables") +
  ggtitle("Gasto en Alimentos No Saludables por N. Socioeconómico") +
  guides(fill = guide_legend(title = "Nivel\nSocioeconómico"),
         color = guide_legend(title = "Nivel\nSocioeconómico")) +
  theme_get() +
  theme(axis.title.x = element_text(margin=margin(t=10))) +
  theme(plot.title = element_text(hjust = 0.2))

"Volviendo a la muestra que contiene todos los casos, después de crear boxplots para observar el gasto de
alimentos saludables y no saludables para cada nivel socioeconómico, se observa como en el boxplot de 
Ln Gasto en Alimentos Saludables pareciera incrementar el gasto mientras más alto sea el Nivel 
Socioeconómico. Sin embargo, no es tan marcado este mismo patrón para Ln Gasto en Alimentos No Saludables."

#Gráfica de Gasto en Alimentos Saludables por Tipo de Localidad
ggplot(df.c, aes(x = ln_als, fill = area, color = area)) +
  geom_histogram(alpha = 0.5, position = "identity", bins = 50) +
  xlab("Gasto Alimentos Saludables") +
  ylab("Cantidad") +
  ggtitle("Gasto en A. Saludables por Zona") +
  guides(fill = guide_legend(title = "Zona"),
         colour = guide_legend(title = "Zona"))

"Y por último, al graficar por localidad de residencia, el porcentaje de consumidores de alimentos 
saludables parece ser mayor en localidades urbanas en comparación con las rurales."


#### 3. Calcula probabilidades que nos permitan entender el problema en México. ####

# ¿Cuál es la probabilidad de que el jefe de familia tenga más de 60 años?
prob.60 <- pnorm(q = 60, mean = 49, sd = 15.82, lower.tail=FALSE)
prob.60 #24.3426%

#¿Cuál es la probabilidad de que el jefe de familia tenga entre 30 y 50 años?"
prob.30y50 <- pnorm(q = 50, mean = 49, sd = 15.82) - pnorm(q = 30, mean = 49, sd = 15.82)
prob.30y50 #41.03%

#¿Cuál es la probabilidad de que el jefe de familia tenga al menos un grado universitario?"
prob.gradouniv <- pnorm(q=17, mean = 10.27, sd = 4.808, lower.tail=FALSE)
prob.gradouniv #8.07%

#### 4. Plantea hipótesis estadísticas y concluye sobre ellas para entender el problema en México. ####
attach(df.c)

"1. De acuerdo a la bibliografía, el ENSANUT 2012 señala que el promedio del número de habitantes por casa 
es igual a 3.89"

"Planteamiento de hipótesis
Ho: prom.ENSANUT.oficial = prom.numpeho
Ha:prom.ENSANUT.oficial != prom.numpeho"

t.test(x=df.c$numpeho, alternative = 'two.sided', mu=3.89)  # p-value = 0.1332

"Con un nivel de confianza del 95%, no se rechaza la hipótesis nula, por lo que el promedio calculado por
el ENSANUT del número de habitantes por hogar es igual al promedio del número de habitantes en esta muestra"


"2. El gasto en alimentos saludables es igual en los diferentes niveles socioeconómicos"

"Planteamiento de hipótesis:
Ho: prom_ln_als_nse5f1 = prom_ln_als_nse5f2 = prom_ln_als_nse5f3 = prom_ln_als_nse5f4 = prom_ln_als_nse5f5 
Ha: prom_ln_als_nse5f1 != prom_ln_als_nse5f2 != prom_ln_als_nse5f3 != prom_ln_als_nse5f4 != prom_ln_als_nse5f5"

anova.als <- aov(ln_als ~ nse5f,
                 data = df.c)
summary(anova.als)

"Con un NC del 95%, se rechaza H0, hay evidencia estadística de que el gasto en alimentos saludables
es diferente en al menos un nivel socioecnómico. Para determinar entre qué grupos hay diferencias 
se procede a realizar una prueba posthoc"

TukeyHSD(anova.als)
pairwise.t.test(ln_als,nse5f, data=df.c)

"La prueba posthoc nos permute concluir, con un nivel de confianza del 95%, que existe evidencia estadística
de que el gasto en alimentos saludables es diferente entre todos los niveles socioeconómicos"


"3. Evaluar si existe evidencia estadística para determinar si los hogares con menor nivel socioeconómico 
tienden a gastar más en productos no saludables que los hogares con mayores niveles socioeconómicos"

"Planteamiento de hipótesis de varianzas;
Ho: var.nse5f1.ln_alns = var.nse5f5.ln_alns
Ha: var.nse5f1.ln_alns != var.nse5f5.ln_alns"

var.test(df.c[df.c$nse5f == "Bajo", "ln_alns"], 
         df.c[df.c$nse5f == "Alto", "ln_alns"], 
         ratio = 1, alternative = "two.sided") # p = <2.2e-16
"Con un nivel de confianza del 95%, existe evidencia estadística para rechazar la hipótesis nula, por
lo que las varianzas son diferentes"

"Planteamiento de hipótesis:
Ho: prom.nse5f1.ln_alns = prom.nse5f5.ln_alns
Ha: prom.nse5f1.ln_alns != prom.nse5f5.ln_alns"

t.test(x = df.c[df.c$nse5f == "Bajo", "ln_alns"], 
       y = df.c[df.c$nse5f == "Alto", "ln_alns"],
       alternative = "two.sided",
       m = 0, var.equal = FALSE) #p = <2.2e-16

"Con un nivel de confianza del 95%, existe evidencia estadística para rechazar la hipótesis nula, por
lo que la evidencia parece indicar que el gasto en alimentos no saludables entre el nivel socioeconómico
bajo y alto son diferentes"

library(tidyverse)
medias  <- df.c %>%
  group_by(nse5f) %>% 
  summarise(ms = mean(ln_als),
            mns = mean(ln_alns))
medias

'Ho: prom.ln_alns.nse5f1(3.93) <= prom.ln_alns.nse5f5
Ha: prom.ln_alns.nse5f1(3.93) > prom.ln_alns.nse5f5'

t.test(x=df.c[df.c$nse5f == "Alto", "ln_alns"], alternative = 'greater', mu=3.93)#p = <2.2e-16

"Con un nivel de confianza del 95%, existe evidencia estadística para rechazar la hipótesis nula, por
lo que el promedio del gasto en alimentos no saludables en un nivel socioeconómico bajo es mayor que
en un nivel socioeconómico alto."

"4. El gasto en alimentos NO saludables es igual en los diferentes niveles socioeconómicos"

"Planteamiento de hipótesis:
Ho: prom_ln_alns_nse5f1 = prom_ln_alns_nse5f2 = prom_ln_alns_nse5f3 = prom_ln_alns_nse5f4 = prom_ln_alns_nse5f5 
Ha: prom_ln_alns_nse5f1 != prom_ln_alns_nse5f2 != prom_ln_alns_nse5f3 != prom_ln_alns_nse5f4 != prom_ln_alns_nse5f5"

anova.alns <- aov(ln_alns ~ nse5f,
                 data = df.c)
summary(anova.alns)

"Con un NC del 95%, se rechaza H0, hay evidencia estadística de que el gasto en alimentos NO saludables
es diferente en al menos un nivel socioecnómico. Para determinar entre qué grupos hay diferencias 
se procede a realizar una prueba posthoc"

TukeyHSD(anova.alns)
pairwise.t.test(ln_alns,nse5f)

"Con un nivel de confianza del 95%, existe evidencia estadística de que el gasto en alimentos no saludables
es diferente entre todos los niveles socioeconómicos"

#### 5. Estima un modelo de regresión, lineal o logístico, para identificiar los determinantes de la inseguridad alimentaria en México, ####
#### Modelos de regresión lineal ####

" Al ser la inseguridad alimentaria una variable categórica, se aplicará más adelante 
un modelo de regresión logística. Sin embargo, nos parece interesante analizar los factores que afectan
los gastos en alimentos saludables y no saludables (ambas variables continuas), mediante 
modelos de regresión lineal."

"Iniciamos con el cálculo de los coeficientes de correlación de Pearson entre 
variables cuantitativas"

attach(df.c)

df.select<-select(df.c,numpeho,edadjef,añosedu,ln_als,ln_alns)

m.cor <- round(cor(df.select),4)
m.cor

"numpeho edadjef añosedu  ln_als ln_alns
numpeho  1.0000 -0.2031  0.0155  0.3012  0.0599
edadjef -0.2031  1.0000 -0.3959 -0.1688 -0.0701
añosedu  0.0155 -0.3959  1.0000  0.2678  0.1600
ln_als   0.3012 -0.1688  0.2678  1.0000  0.2280
ln_alns  0.0599 -0.0701  0.1600  0.2280  1.0000"

"Otras maneras de observar la correlación:"

library(corrplot)

corrplot(m.cor, method="number", type="upper")

library(PerformanceAnalytics)

chart.Correlation(df.select, histogram = T, pch = 19)

"Según estos análisis 

El gasto en alimentos saludables parece determinado por:
- núm de personas en el hogar
- años de educación del jefe de familia
- gasto en alim no-saludable

El gasto en alimentación NO-saludable parece determinado por:
- años de educación del jefe de familia
- gasto en alim saludable"

"Prueba de modelos de regresión lineal para gasto en alim saludable
para las variables cuantitativas de mayor correlación"

lm.s <- lm(ln_als ~ numpeho + añosedu + ln_alns, df.c)
summary(lm.s) # R-cuad ajust = 0.189

"Vamos añadiendo variables categóricas"

m1 <- lm(ln_als ~ nse5f + area + numpeho + refin + edadjef + sexojef + añosedu + IA+ ln_alns)
summary(m1) # R cuad ajust = 0.2506, mejora

"se elimina sexo del jefe por no ser significativo"

m1.5 <- lm(ln_als ~ nse5f + area + numpeho + refin + edadjef + añosedu + IA+ ln_alns)
summary(m1.5) #0.2506, no cambia

"se toman interacciones entre variables"

"nivel socioeconómico con área"
m2 <- lm(ln_als ~ nse5f + nse5f:area + area + numpeho + refin + edadjef + sexojef + añosedu + IA+ ln_alns)
summary(m2) #0.2512, mejora

"nivel socioeconómico con número de personas en el hogar"
m3 <- lm(ln_als ~ nse5f + nse5f:numpeho + area + numpeho + refin + edadjef + sexojef + añosedu + IA+ ln_alns)
summary(m3) #0.2505, no mejora

"nivel socioeconómico con ingresos extras"
m4 <- lm(ln_als ~ nse5f + nse5f:refin + area + numpeho + refin + edadjef + sexojef + añosedu + IA+ ln_alns)
summary(m4) #0.2506, mejora muy poco

"nivel socioeconómico con edad del jefe de familia"
m5 <- lm(ln_als ~ nse5f + nse5f:edadjef + area + numpeho + refin + edadjef + sexojef + añosedu + IA+ ln_alns)
summary(m5) #0.2524, mejora
plot(m5)

"nivel socioeconómico con edad del jefe de familia, más edad del jefe de familia y su género"
m5.5 <- lm(ln_als ~ nse5f + nse5f:edadjef + area + numpeho + edadjef:sexojef+ refin + edadjef + sexojef + añosedu + IA+ ln_alns)
summary(m5.5) #0.2528, mejora aún más

"el nivel socioeconómico y el género del jefe de familia"
m6 <- lm(ln_als ~ nse5f + nse5f:sexojef + area + numpeho + refin + edadjef + sexojef + añosedu + IA+ ln_alns)
summary(m6) #0.2506, no mejora

" nivel socioeconómico y los años de educación"
m7 <- lm(ln_als ~ nse5f + nse5f:añosedu + area + numpeho + refin + edadjef + sexojef + añosedu + IA+ ln_alns)
summary(m7) #0.2507, no mejora mucho

"De los modelos de regresión lineal para el gasto en alimentos saludables,
se escoge el modelo m1.5 sin interacciones ya que el sexojef no fue significativo
pero al considerar interacciones se escoge el modelo m5.5, donde se consideran como
determinantes las siguientes interacciones: nse5f:edadjef, edadjef:sexojef"

StanRes2 <- rstandard(m1.5)

par(mfrow = c(2, 2))

plot(nse5f, StanRes2, ylab = "Residuales Estandarizados")
plot(area, StanRes2, ylab = "Residuales Estandarizados")
plot(numpeho, StanRes2, ylab = "Residuales Estandarizados")
plot(refin, StanRes2, ylab = "Residuales Estandarizados")

plot(edadjef, StanRes2, ylab = "Residuales Estandarizados")
plot(sexojef, StanRes2, ylab = "Residuales Estandarizados")
plot(añosedu, StanRes2, ylab = "Residuales Estandarizados")
plot(IA, StanRes2, ylab = "Residuales Estandarizados")

plot(ln_alns, StanRes2, ylab = "Residuales Estandarizados")

qqnorm(StanRes2)
qqline(StanRes2)

dev.off()

" Ahora repetimos el proceso para el gasto en alimentos no saludables"

"Variables cuantitativas de mayor correlación"

lm.ns <- lm(ln_alns ~ añosedu + ln_als, df.c)
summary(lm.ns) # R-cuad ajust = 0.06247

" Vamos añadiendo variables categóricas"

m8 <- lm(ln_alns ~ nse5f + refin + ln_als + IA)
summary(m8) #0.07963, mejora

m9 <- lm(ln_alns ~ nse5f + ln_als + IA)
summary(m9) #0.0797

m10 <- lm(ln_alns ~ nse5f + ln_als + IA + nse5f:ln_als)
summary(m10) #0.0852

m11 <- lm(ln_alns ~ nse5f + ln_als + IA + nse5f:ln_als + nse5f:IA)
summary(m11) #0.0854

m12 <- lm(ln_alns ~ nse5f + ln_als + IA + nse5f:ln_als + ln_als:IA)
summary(m12) #0.0852

" Se consideran solo las variables planteadas en la hipótesis original, donde
se observa en el modelo m8 que la variable refin no es significativa por lo que 
se escoge el modelo m9. Dentro de los modelos donde se consideran las interacciones,
se escoge el modelo lineal para gasto no saludables con las interacciones con 
el nivel socioeconómico (m11)"

StanRes3 <- rstandard(m11)

par(mfrow = c(2, 2))

plot(nse5f, StanRes3, ylab = "Residuales Estandarizados")
plot(area, StanRes3, ylab = "Residuales Estandarizados")
plot(numpeho, StanRes3, ylab = "Residuales Estandarizados")
plot(refin, StanRes3, ylab = "Residuales Estandarizados")

plot(edadjef, StanRes3, ylab = "Residuales Estandarizados")
plot(sexojef, StanRes3, ylab = "Residuales Estandarizados")
plot(añosedu, StanRes3, ylab = "Residuales Estandarizados")
plot(IA, StanRes3, ylab = "Residuales Estandarizados")

plot(ln_als, StanRes3, ylab = "Residuales Estandarizados")

qqnorm(StanRes3)
qqline(StanRes3)

dev.off()

#### Factores determinantes ####

"Para encontrar los factores determinantes de la Inseguridad Alimentario dentro
de esta muestra, se usó el método de regresión logística con un enfoque aditivo
para las interacciones"

logistic.1 <- glm(IA ~ nse5f, 
                  data = df.c, family = binomial)
summary(logistic.1) #AIC: 38087
pseudo_r2.1 <- (logistic.1$null.deviance - logistic.1$deviance)/logistic.1$null.deviance
pseudo_r2.1 #0.0708

logistic.2 <- glm(IA ~ nse5f + area, 
                  data = df.c, family = binomial)
summary(logistic.2) #AIC: 38086 
pseudo_r2.2 <- (logistic.2$null.deviance - logistic.2$deviance)/logistic.2$null.deviance
pseudo_r2.2 #0.07083

logistic.3 <- glm(IA ~ nse5f + numpeho, 
                  data = df.c, family = binomial)
summary(logistic.3) #AIC = 37591
pseudo_r2.3 <- (logistic.3$null.deviance - logistic.3$deviance)/logistic.3$null.deviance
pseudo_r2.3 #0.0829

logistic.4 <- glm(IA ~ nse5f + numpeho + refin, 
                  data = df.c, family = binomial)
summary(logistic.4) #AIC = 37481
pseudo_r2.4 <- (logistic.4$null.deviance - logistic.4$deviance)/logistic.4$null.deviance
pseudo_r2.4 #0.0856

logistic.5 <- glm(IA ~ nse5f + numpeho + refin + edadjef, 
                  data = df.c, family = binomial)
summary(logistic.5) #AIC = 37389
pseudo_r2.5 <- (logistic.5$null.deviance - logistic.5$deviance)/logistic.5$null.deviance
pseudo_r2.5 #0.088

logistic.6 <- glm(IA ~ nse5f + numpeho + refin + edadjef + sexojef, 
                  data = df.c, family = binomial)
summary(logistic.6) #AIC = 37347
pseudo_r2.6 <- (logistic.6$null.deviance - logistic.6$deviance)/logistic.6$null.deviance
pseudo_r2.6 #0.089

logistic.7 <- glm(IA ~ nse5f + numpeho + refin + edadjef + sexojef + añosedu, 
                  data = df.c, family = binomial)
summary(logistic.7) #AIC = 37101
pseudo_r2.7 <- (logistic.7$null.deviance - logistic.7$deviance)/logistic.7$null.deviance
pseudo_r2.7 #0.0951

#edadjef no fue significativo

logistic.8 <- glm(IA ~ nse5f + numpeho + refin + edadjef + sexojef + añosedu + ln_als + ln_alns, 
                  data = df.c, family = binomial)
summary(logistic.8) #AIC = 37020
pseudo_r2.8 <- (logistic.8$null.deviance - logistic.8$deviance)/logistic.8$null.deviance
pseudo_r2.8 #0.0972

logistic.9 <- glm(IA ~ nse5f + numpeho + refin + sexojef + añosedu + ln_als + ln_alns, 
                  data = df.c, family = binomial)
summary(logistic.9) #AIC = 37018
pseudo_r2.9 <- (logistic.9$null.deviance - logistic.9$deviance)/logistic.9$null.deviance
pseudo_r2.9 #0.0971

logistic.10 <- glm(IA ~ nse5f + numpeho + refin + edadjef:sexojef + sexojef + añosedu + ln_als + ln_alns, 
                   data = df.c, family = binomial)
summary(logistic.10) #AIC = 36991
pseudo_r2.10 <- (logistic.10$null.deviance - logistic.10$deviance)/logistic.10$null.deviance
pseudo_r2.10 #0.0979

logistic.11 <- glm(IA ~ nse5f:numpeho + nse5f + numpeho + refin + edadjef:sexojef + sexojef + añosedu + ln_als + ln_alns, 
                   data = df.c, family = binomial)
summary(logistic.11) #AIC = 36980
pseudo_r2.11 <- (logistic.11$null.deviance - logistic.11$deviance)/logistic.11$null.deviance
pseudo_r2.11 #0.0984

logistic.12 <- glm(IA ~ nse5f:numpeho + nse5f + nse5f:edadjef + numpeho + refin + edadjef:sexojef + sexojef + añosedu + ln_als + ln_alns, 
                   data = df.c, family = binomial)
summary(logistic.12) #AIC = 36943
pseudo_r2.12 <- (logistic.12$null.deviance - logistic.12$deviance)/logistic.12$null.deviance
pseudo_r2.12 #0.0995

logistic.13 <- glm(IA ~ nse5f:numpeho + nse5f + nse5f:edadjef + numpeho:añosedu + numpeho + refin + edadjef:sexojef + sexojef + añosedu + ln_als + ln_alns, 
                   data = df.c, family = binomial)
summary(logistic.13) #AIC = 36927
pseudo_r2.13 <- (logistic.13$null.deviance - logistic.13$deviance)/logistic.13$null.deviance
pseudo_r2.13 #0.0999

logistic.14 <- glm(IA ~ nse5f:numpeho + nse5f + nse5f:edadjef + numpeho:añosedu + numpeho:ln_als+ numpeho + refin + edadjef:sexojef + sexojef + añosedu + ln_als + ln_alns, 
                   data = df.c, family = binomial)
summary(logistic.14) #AIC = 36911
pseudo_r2.14 <- (logistic.14$null.deviance - logistic.14$deviance)/logistic.14$null.deviance
pseudo_r2.14 #0.1003

logistic.15 <- glm(IA ~ nse5f:numpeho + nse5f + nse5f:edadjef + numpeho:añosedu + numpeho:ln_als+ numpeho:ln_alns + numpeho + refin + edadjef:sexojef + sexojef + añosedu + ln_als + ln_alns, 
                   data = df.c, family = binomial)
summary(logistic.15) #AIC = 36913

logistic.16 <- glm(IA ~ nse5f:numpeho + nse5f + nse5f:edadjef + numpeho:añosedu + numpeho:ln_als+ numpeho + refin + refin:edadjef + edadjef:sexojef + sexojef + añosedu + ln_als + ln_alns, 
                   data = df.c, family = binomial)
summary(logistic.16) #AIC = 36913

logistic.17 <- glm(IA ~ nse5f:numpeho + nse5f + nse5f:edadjef + numpeho:añosedu + numpeho:ln_als+ numpeho + refin + refin:sexojef + edadjef:sexojef + sexojef + añosedu + ln_als + ln_alns, 
                   data = df.c, family = binomial)
summary(logistic.17) #AIC = 36913

logistic.18 <- glm(IA ~ nse5f:numpeho + nse5f + nse5f:edadjef + numpeho:añosedu + numpeho:ln_als+ numpeho + refin + refin:añosedu + edadjef:sexojef + sexojef + añosedu + ln_als + ln_alns, 
                   data = df.c, family = binomial)
summary(logistic.18) #AIC = 36913

logistic.19 <- glm(IA ~ nse5f:numpeho + nse5f + nse5f:edadjef + numpeho:añosedu + numpeho:ln_als+ numpeho + refin + refin:ln_als + edadjef:sexojef + sexojef + añosedu + ln_als + ln_alns, 
                   data = df.c, family = binomial)
summary(logistic.19) #AIC = 36913

logistic.20 <- glm(IA ~ nse5f:numpeho + nse5f + nse5f:edadjef + numpeho:añosedu + numpeho:ln_als+ numpeho + refin + refin:ln_alns + edadjef:sexojef + sexojef + añosedu + ln_als + ln_alns, 
                   data = df.c, family = binomial)
summary(logistic.20) #AIC = 36912

logistic.21 <- glm(IA ~ nse5f:numpeho + nse5f + nse5f:edadjef + numpeho:añosedu + numpeho:ln_als+ numpeho + refin + edadjef:sexojef + edadjef + sexojef + añosedu + ln_als + ln_alns, 
                   data = df.c, family = binomial)
summary(logistic.21) #AIC = 36911
pseudo_r2.21 <- (logistic.21$null.deviance - logistic.21$deviance)/logistic.21$null.deviance
pseudo_r2.21 #0.1003

logistic.22 <- glm(IA ~ nse5f:numpeho + nse5f + nse5f:edadjef + numpeho:añosedu + numpeho:ln_als+ numpeho + refin + edadjef:sexojef + edadjef + numpeho:edadjef + sexojef + añosedu + ln_als + ln_alns, 
                   data = df.c, family = binomial)
summary(logistic.22) #AIC = 36911

logistic.23 <- glm(IA ~ nse5f:numpeho + nse5f + nse5f:edadjef + numpeho:añosedu + numpeho:ln_als+ numpeho + refin + edadjef:sexojef + edadjef + refin:edadjef + sexojef + añosedu + ln_als + ln_alns, 
                   data = df.c, family = binomial)
summary(logistic.23) #AIC = 36913

logistic.24 <- glm(IA ~ nse5f:numpeho + nse5f + nse5f:edadjef + numpeho:añosedu + numpeho:ln_als+ numpeho + refin + edadjef:sexojef + edadjef + sexojef:añosedu + sexojef + añosedu + ln_als + ln_alns, 
                   data = df.c, family = binomial)
summary(logistic.24) #AIC = 36909
pseudo_r2.24 <- (logistic.21$null.deviance - logistic.21$deviance)/logistic.21$null.deviance
pseudo_r2.24 #0.1003

logistic.25 <- glm(IA ~ nse5f:numpeho + nse5f + nse5f:edadjef + numpeho:añosedu + numpeho:ln_als+ numpeho + refin + edadjef:sexojef + edadjef + sexojef:ln_als + sexojef + añosedu + ln_als + ln_alns, 
                   data = df.c, family = binomial)
summary(logistic.25) #AIC = 36913

logistic.26 <- glm(IA ~ nse5f:numpeho + nse5f + nse5f:edadjef + numpeho:añosedu + numpeho:ln_als+ numpeho + refin + edadjef:sexojef + edadjef + sexojef:ln_alns + sexojef + añosedu + ln_als + ln_alns, 
                   data = df.c, family = binomial)
summary(logistic.26) #AIC = 36913

logistic.27 <- glm(IA ~ nse5f:numpeho + nse5f + nse5f:edadjef + numpeho:añosedu + numpeho:ln_als+ numpeho + refin + edadjef:sexojef + edadjef + sexojef + añosedu:ln_als + ln_als + ln_alns, 
                   data = df.c, family = binomial)
summary(logistic.27) #AIC = 36899
pseudo_r2.27 <- (logistic.21$null.deviance - logistic.21$deviance)/logistic.21$null.deviance
pseudo_r2.27 #0.1003

logistic.28 <- glm(IA ~ nse5f:numpeho + nse5f + nse5f:edadjef + numpeho:añosedu + numpeho:ln_als+ numpeho + refin + edadjef:sexojef + edadjef + añosedu:ln_alns + sexojef + añosedu + ln_als + ln_alns, 
                   data = df.c, family = binomial)
summary(logistic.28) #AIC = 36909

logistic.29 <- glm(IA ~ nse5f:numpeho + nse5f + nse5f:edadjef + numpeho:añosedu + numpeho:ln_als+ numpeho + refin + edadjef:sexojef + edadjef + sexojef:añosedu + sexojef + añosedu + ln_als + ln_alns, 
                   data = df.c, family = binomial)
summary(logistic.24) #AIC = 36909

logistic.30 <- glm(IA ~ nse5f:numpeho + nse5f + nse5f:edadjef + numpeho:añosedu + numpeho:ln_als+ numpeho + refin + edadjef:sexojef + edadjef + sexojef + añosedu + ln_als:ln_alns + ln_als + ln_alns, 
                   data = df.c, family = binomial)
summary(logistic.30) #AIC = 36913

"Tras evaluar los distintos modelos, se eligen los siguientes para evaluar:"

logistic.8 <- glm(IA ~ nse5f + numpeho + refin + edadjef + sexojef + añosedu + ln_als + ln_alns, 
                  data = df.c, family = binomial)
summary(logistic.8) #AIC = 37020
pseudo_r2.8 <- (logistic.8$null.deviance - logistic.8$deviance)/logistic.8$null.deviance
pseudo_r2.8 #0.0972


"Se tomaron en cuenta como determinantes todas las variables sin interacciones, 
donde se encontró que, por sí sola, la variable edadjef no es una determinante
significativa, por lo que se elaboró un modelo sin ella:"

logistic.9 <- glm(IA ~ nse5f + numpeho + refin + sexojef + añosedu + ln_als + ln_alns, 
                  data = df.c, family = binomial)
summary(logistic.9) #AIC = 37018
pseudo_r2.9 <- (logistic.9$null.deviance - logistic.9$deviance)/logistic.9$null.deviance
pseudo_r2.9 #0.0971

"Sin considerar edadjef, el resto de las variables permanecen significativas, y 
el Pseudo R2 permanece casi igual"

logistic.14 <- glm(IA ~ nse5f:numpeho + nse5f + nse5f:edadjef + numpeho:añosedu + numpeho:ln_als+ numpeho + refin + edadjef:sexojef + sexojef + añosedu + ln_als + ln_alns, 
                   data = df.c, family = binomial)
summary(logistic.14) #AIC = 36911
pseudo_r2.14 <- (logistic.14$null.deviance - logistic.14$deviance)/logistic.14$null.deviance
pseudo_r2.14 #0.1003

"También se consideró la posibilidad de interacciones entre las variables, donde se encontró
que las más importantes fueron: nse5f:numpeho, nse5f:edadjef,  numpeho:añosedu,
numpeho:ln_als, edadjef:sexojef"
