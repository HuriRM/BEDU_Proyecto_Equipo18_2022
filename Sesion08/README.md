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
