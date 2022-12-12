# Postwork Sesión 3

#### Objetivo

#- Realizar un análisis descriptivo de las variables de un dataframe

#### Requisitos

#1. R, RStudio
#2. Haber realizado el prework y seguir el curso de los ejemplos de la sesión
#3. Curiosidad por investigar nuevos tópicos y funciones de R

#### Desarrollo

"Utilizando el dataframe `boxp.csv` realiza el siguiente análisis descriptivo. No olvides excluir los missing values y transformar las variables a su
tipo y escala correspondiente."
df <- read.csv("https://raw.githubusercontent.com/beduExpert/Programacion-R-Santander-2022/main/Sesion-03/Data/boxp.csv")
View(df)
complete.cases(df) #Se encontraron observacions incompletas
df.2 <- na.omit(df) #Se omitieron las observaciones incompletas, quedando 591 observaciones
dim(df.2)
df.2$Grupo <- as.logical(df.2$Grupo)
df.2$Categoria <- factor(df.2$Categoria)


#1) Calcula e interpreta las medidas de tendencia central de la variable `Mediciones`

promedio.mediciones <- mean(df.2$Mediciones) #62.88
library(DescTools)
moda.mediciones <- Mode(df.2$Mediciones) #23.3
moda.mediciones
mediana.mediciones <- median(df.2$Mediciones) #49.3

"R =  La media y la mediana son considerablemente más grandes que la moda, por lo que,
la distribución pareciera tener un sesgo a la derecho con varios 'outliers' "

#2) Con base en tu resultado anterior, ¿qué se puede concluir respecto al sesgo de
#`Mediciones`? 

"R = Tiene un sesgo a la derecha."

"3) Calcula e interpreta la desviación estándar y los cuartiles de la distribución de
`Mediciones'

R = De acuerdo a la desviación estandar los datos se encuentran dispersos a
comparación con la media. La diferencia entre el cuartil 1,2 y 3 es similar entre ellos, 
por lo que es probable que la mayoría de los datos que causan el sesgo (outliers) se encuentren
en el 25% superior."

de.mediciones <- sd(df.2$Mediciones) #53.77
cuartiles.mediciones <- quantile(df.2$Mediciones, probs = c(0.25,0.5, 0.75))
"Q1 23.4, Q2 49.3, Q3 82.8"

"4) Con ggplot, realiza un histograma separando la distribución de `Mediciones` por 
`Categoría` ¿Consideras que sólo una categoría está generando el sesgo?

R = Aunque las 3 categorías están sesgadas la que más ocasiona sesgo es C3" 

hist.mediciones <- ggplot(df.2, aes(x = df.2$Mediciones, fill = df.2$Categoria)) +
  geom_histogram(alpha = 0.5, position = "identity")
hist.mediciones <- hist.mediciones + labs(fill = "Categorías", title = "Distribución de Mediciones por Categoría", x = "Mediciones", y = "Cantidad")
hist.mediciones

"5) Con ggplot, realiza un boxplot separando la distribución de `Mediciones`
por `Categoría` y por `Grupo` dentro de cada categoría. ¿Consideras que hay 
diferencias entre categorías?¿Los grupos al interior de cada categoría podrían
estar generando el sesgo? 

R= Sí hay diferencias, la categoría 1 presenta menor
sesgo a la derecha debido a que para ambos grupos se concentran los datos hacia
las medidas de tendencia central más que en las otras categorías. Sin embargo,
los que no tienen grupo, en las categorias C2 y C3 'jalan' los datos hacia la
derecha, al igual que los outliers de todas las categorías"

boxplot.mediciones <- ggplot(df.2, aes(x = df.2$Categoria, y = df.2$Mediciones, fill = df.2$Grupo)) +
  geom_boxplot() +
  labs(fill = "Grupo", title = "Mediciones por Categoría y Grupo", x = "Categorías", y = "Mediciones") +
  scale_fill_discrete(labels = c("Sin grupo", "Con grupo"))
boxplot.mediciones
