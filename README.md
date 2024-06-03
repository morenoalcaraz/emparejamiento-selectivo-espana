# Paquete de replicación para << El Impacto del Emparejamiento Selectivo sobre los Diferenciales Salariales Intra-Parejas >>

## Resumen

El código en este paquete de replicación permite obtener todos los resultados del trabajo de fin de grado << El Impacto del Emparejamiento Selectivo sobre los Diferenciales Salariales Intra-Parejas >>, desde la preparación de los datos hasta los resultados finales. Se puede acceder a los datos necesarios para obtener el código fácilmente, como se describirá a continuación. El código completo tarda en correr varias horas, principalmente por `01_data_prep_over_time.do`.

## Declaraciones de Disponibilidad y Procedencia de los Datos

### Declaración de derechos

- [x] Certifico que el(los) autor(es) del manuscrito tiene(n) acceso legítimo y permiso para utilizar los datos empleados en este trabajo.

### Resumen de disponibilidad

- [x] Todos los datos **están** disponibles públicamente.
- [ ] Algunos datos **no pueden hacerse** disponibles públicamente.
- [ ] **Ningún dato puede hacerse** disponible públicamente.

### Detalles sobre las Fuentes de Datos

#### Encuesta de Condiciomes de Vida (fuente: INE)

Se sacan los microdatos de la Encuesta de Condiciones de Vida (ECV) publicada por el Instituto Nacional de Estadística (INE) para cada año disponible desde 2008. Los datos anuales de la ECV se pueden obtener en [INE ECV](https://www.ine.es/dyngs/INEbase/es/operacion.htm?c=Estadistica_C&cid=1254736176807&menu=resultados&idp=1254735976608#_tabs-1254736195153). Se tiene que guradar en el repositorio con el nombre de descarga en las carpetas correspondientes para cada año `data/raw`.

#### Índice de Precios al Consumidor (fuente: INE)

Se obtiene el Índice de Precios al Consumidor (IPC) anual del INE. Estos datos se pueden descargar en [INE IPC desde 2008]([https://usa.ipums.org/usa/](https://www.ine.es/jaxiT3/Datos.htm?t=50934)) y se usan para deflactar las variables monetarias de cada año con 2021 como año base. Deben ser guardados en el repositorio como `data/CPI.dta`. 

