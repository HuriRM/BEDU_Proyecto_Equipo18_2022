# Postwork Sesión 1.

#### Objetivo

"El Postwork tiene como objetivo que practiques los comandos básicos aprendidos 
durante la sesión, de tal modo que sirvan para reafirmar el conocimiento. Recuerda 
que la programación es como un deporte en el que se debe practicar, habrá caídas, 
pero lo importante es levantarse y seguir adelante. Éxito"

#### Requisitos
#- Concluir los retos
#- Haber estudiado los ejemplos durante la sesión

#### Desarrollo

"El siguiente postwork, te servirá para ir desarrollando habilidades como si se 
tratara de un proyecto que evidencie el progreso del aprendizaje durante el módulo, 
sesión a sesión se irá desarrollando.
A continuación aparecen una serie de objetivos que deberás cumplir, es un ejemplo 
real de aplicación y tiene que ver con datos referentes a equipos de la liga española 
de fútbol (recuerda que los datos provienen siempre de diversas naturalezas), en 
este caso se cuenta con muchos datos que se pueden aprovechar, explotarlos y generar 
análisis interesantes que se pueden aplicar a otras áreas. Siendo así damos paso a las instrucciones:" 

#1. Del siguiente enlace, descarga los datos de soccer de la temporada 2019/2020 de la primera división de la liga española: https://www.football-data.co.uk/spainm.php

#2. Importa los datos a R como un Dataframe. NOTA: No olvides cambiar tu dirección de trabajo a la ruta donde descargaste tu archivo
sp1 <- read.csv("https://raw.githubusercontent.com/HuriRM/BEDU_Proyecto_Equipo18_2022/main/Sesion01/SP1.csv")
class(sp1)
#3. Del dataframe que resulta de importar los datos a `R`, extrae las columnas que contienen los números de goles anotados por los equipos que jugaron en casa (FTHG) y los goles anotados por los equipos que jugaron como visitante (FTAG); guárdalos en vectores separados
goles_en_casa <- sp1$FTHG
goles_visitante <- sp1$FTAG
#4. Consulta cómo funciona la función `table` en `R`. Para ello, puedes ingresar los comandos `help("table")` o `?table` para leer la documentación.
?table()
?count
#5. Responde a las siguientes preguntas:
#  a) ¿Cuántos goles tuvo el partido con mayor empate? El partido con mayor empate fue 4-4, en una ocasión.

mas.goles.empate <- table(max(sp1$FTHG[sp1$FTHG == sp1$FTAG]))
print(mas.goles.empate)
#  b) ¿En cuántos partidos ambos equipos empataron 0 a 0? R.- 33 partidos cero a cero.
library(dplyr)
empates.cero.a.cero <- count(sp1, wt=sp1$FTHG==sp1$FTAG&sp1$FTHG==0)
print(empates.cero.a.cero)
#  c) ¿En cuántos partidos el equipo local (HG) tuvo la mayor goleada sin dejar que el equipo visitante (AG) metiera un solo gol?
# R.- 1 partido HG = 6 & AG = 0.
mayor.goleada.local <- count(sp1, wt=sp1$FTHG==6 & sp1$FTAG==0)
print(mayor.goleada.local)
#  __Notas para los datos de soccer:__ https://www.football-data.co.uk/notes.txt
