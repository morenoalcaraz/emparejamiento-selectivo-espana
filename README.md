# Paquete de replicación para "El Impacto del Emparejamiento Selectivo sobre los Diferenciales Salariales Intra-Parejas"

## Resumen

El código en este paquete de replicación permite obtener todos los resultados del trabajo de fin de grado "El Impacto del Emparejamiento Selectivo sobre los Diferenciales Salariales Intra-Parejas", desde la preparación de los datos hasta los resultados finales. Se puede acceder a los datos necesarios para obtener el código fácilmente, como se describirá a continuación. El código completo tarda en correr varias horas, principalmente por `01_data_prep_over_time.do`.

## Declaraciones de Disponibilidad y Procedencia de los Datos

### Declaración de derechos

- [x] Certifico que el(los) autor(es) del manuscrito tiene(n) acceso legítimo y permiso para utilizar los datos empleados en este trabajo.

### Resumen de disponibilidad

- [x] Todos los datos **están** disponibles públicamente.
- [ ] Algunos datos **no pueden hacerse** disponibles públicamente.
- [ ] **Ningún dato puede hacerse** disponible públicamente.

### Detalles sobre las Fuentes de Datos

#### Encuesta de Condiciomes de Vida (fuente: INE)

Se obtienen los microdatos de la Encuesta de Condiciones de Vida (ECV) publicada por el Instituto Nacional de Estadística (INE) para cada año disponible desde 2008. Los datos anuales de la ECV se pueden obtener en [INE ECV](https://www.ine.es/dyngs/INEbase/es/operacion.htm?c=Estadistica_C&cid=1254736176807&menu=resultados&idp=1254735976608#_tabs-1254736195153). Se tiene que guradar en el repositorio con el nombre de descarga en las carpetas correspondientes para cada año `data/raw`.

#### Índice de Precios al Consumidor (fuente: INE)

Se obtiene el Índice de Precios al Consumidor (IPC) anual del INE. Estos datos se pueden descargar en [INE IPC desde 2008]([https://usa.ipums.org/usa/](https://www.ine.es/jaxiT3/Datos.htm?t=50934)) y se usan para deflactar las variables monetarias de cada año con 2021 como año base. Deben ser guardados en el repositorio como `data/CPI.dta`. 

## Requisitos de computación

### Requisitos de Software

- Se usa Stata 17, pero versiones más recientes pueden ser compatibles.

### Aleatoriedad Controlada

Se configuran semillas aleatorias en `03_random_couples_data_prep.do` para crear la muestra de emparejamiento aleatorio.

### Requisitos de Memoria y Tiempo de Ejecución

#### Resumen

El tiempo aproximado necesario para reproducir los análisis en una máquina de escritorio estándar de 2024 es:

- [ ] <10 minutos
- [ ] 10-60 minutos
- [x] 1-8 horas
- [ ] 8-24 horas
- [ ] 1-3 días
- [ ] 3-14 días
- [ ] > 14 días
- [ ] No es factible ejecutarlo en una máquina de escritorio, como se describe a continuación.

#### Detalles

El código se ejecutó por última vez en un (portátil Intel Core i5 de doble núcleo a 2,3 GHz con 8 GB de RAM, ejecutando MacOS versión 13.3.1). La computación tardó de 3 a 6 horas.

## Descripción de los programas/código

Se debe crear una carpeta llamada `ECV`. Dentro de esta se deben crear otras 4 carpetas para replicar correctamente el código: `data`, `do`, `graphs` y `log`

- La carpeta `data` recoge las bases de datos utilizadas en el trabajo y contiene otras dos carpetas: `raw` y `temp`.
  - La carpeta `raw` contiene 16 carpetas adicionales, una para cada año desde 2008 hasta 2023 incluidos. Aquí se tienen que guardar los datos sin procesar descargados de la ECV para cada año, con el nombre de descarga que viene por defecto.
  - La carpeta `temp` recoge las muestras intermedias que se crean para luego juntarlas y crear las bases de datos finales.
- La carpeta `do` contiene los códigos.
  - El código nombrado `00_master_do_file.do` corre todo el código de seguido.
  - El código nombrado `01_data_prep_over_time.do` limpia y prepara las bases de datos sacadas de la ECV del INE y usa el IPC para deflactar las variables monetarias.
  - El código nombrado `02_descriptive_stats.do` produce los estadísticos descriptivos.
  - El código nombrado `03_random_couples_data_prep.do` crea la base de datos bajo emparejamiento aleatorio.
  - El código nombrado `04_assortative_mating_over_time.do` crea las medidas de emparejamiento selectivo y su evolución a lo largo del tiempo.
  - El código nombrado `05_stand_cont_tables.do` estandariza la primera medida de emparejamiento selectivo para tener en cuenta las dinámicas temporales de nivel de estudios.
  - El código nombrado `06_brecha_salarial.do` lleva a cabo las regresiones del trabajo.
- La carpeta `graphs` contiene todas las figuras generadas por el código.
- La carpeta `log` contiene el único archivo .log generado por el código.

### Licencia para el Código

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

El código tiene licencia [GNU v3](https://www.gnu.org/licenses/gpl-3.0.html). Ver [LICENSE.txt](LICENSE.txt) para más detalles.

## Instrucciones para replicadores

- Crear las 4 carpetas necesarias (`data`, `do`, `graphs` y `log`).
- Editar el directorio de trabajo en cada archivo `.do` para que lleve a la carpeta indicada al final de cada directorio original.
- Correr el archivo `00_master_do_file.do`.

## Lista de tablas y programas

El código proporcionado reproduce

- [x] Todos los números proporcionados en el texto del trabajo.
- [x] Todas las tablas y figuras del trabajo.
- [ ] Tablas y figuras seleccionadas en el trabajo, como se explica y justifica a continuación.

Se señala que los archivos de código están en `do` y las figuras están en `graphs`.

| Figura/Tabla #         | Archivo .do                        |
|------------------------|------------------------------------|
| Figura 1a              | 04_assortative_mating_over_time.do |
| Figura 1b              | 05_stand_cont_tables.do            |
| Figura 1c              | 04_assortative_mating_over_time.do |
| Figura 1d              | 04_assortative_mating_over_time.do |
| Tabla 1                | 06_brecha_salarial.do              |
| Tabla 2                | 06_brecha_salarial.do              |
| Tabla 3                | 06_brecha_salarial.do              |
| Tabla 4 (Apéndice A)   | 02_descriptive_stats.do            |
| Tabla 5 (Apéndice B)   | 06_brecha_salarial.do              |
| Tabla 6 (Apéndice B)   | 06_brecha_salarial.do              |
| Tabla 7 (Apéndice C)   | 06_brecha_salarial.do              |
| Tabla 8 (Apéndice C)   | 06_brecha_salarial.do              |
| Tabla 9 (Apéndice C)   | 06_brecha_salarial.do              |
| Tabla 10 (Apéndice C)  | 06_brecha_salarial.do              |
| Figura 2a (Apéndice D) | 06_brecha_salarial.do              |
| Figura 2b (Apéndice D) | 06_brecha_salarial.do              |
| Figura 2c (Apéndice D) | 06_brecha_salarial.do              |
| Figura 2d (Apéndice D) | 06_brecha_salarial.do              |
| Figura 3a (Apéndice D) | 06_brecha_salarial.do              |
| Figura 3b (Apéndice D) | 06_brecha_salarial.do              |
