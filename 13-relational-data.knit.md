
# Datos relacionales

## Introducción

Es raro que un análisis de datos involucre una única tabla de datos. Típicamente tienes muchas tablas de datos y debes combinarlas para responder las preguntas de tu interés. Colectivamente, múltiples tablas de datos se llaman _datos relacionales_ debido a que sus relacionales, no sólo los conjuntos de datos individuales, son importantes.

Las relaciones siempre se definen sobre un par de tablas. Todas las otras relaciones se construyen sobre esta idea simple: las relaciones entre tres o más tablas son siempre una propiedad de las relaciones entre cada par. ¡A veces ambos elementos de un par pueden ser la misma tabla! Esto se necesita si, por ejemplo, tienes una tabla de personas y cada persona tiene una referencia a sus padres.

Para trabajar con datos relacionales necesitas verbos para trabajar con pares de tablas. Existen tres familias de verbos diseñadas para trabajar con datos relacionales:

* __Uniones de transformación__ (del inglés _transforming join_), que agregan nuevas variables a un *data frame* a partir de las observaciones coincidentes en otra tabla.

* __Uniones de filtro__ (del inglés _filtering join_), que filtran observaciones en un *data frame* con base en si coinciden con las observaciones en otra tabla.

* __Operaciones de conjuntos__ (del inglés _set operations_), que tratan las observaciones como eleentos de un conjunto.

El lugar más común para encontrar datos relacionales es en un sistema _relacional_ de administración de bases de datos (*Relational Data Base Management System* en inglés), un concepto que abarca casi todas las bases de datos modernas. Si has usado una base de datos con anterioridad, casi seguramente usaste SQL. Si es así, los conceptos de este capítulo debiesen ser familiares, aunque su expresión en dplyr es ligeramente distinta. Generalmente, dplyr es un poco más fácil de usar que SQL ya que dplyr se especializa en el análisis de datos: facilita las operaciones habituales de análisis de datos, a expensas de dificultar otras operaciones que no se requieren a menudo para el análisis.

### Prerequisitos

Vamos a explorar datos relacionales de `datos` usando los verbos de dos tablas de dplyr.


```r
library(tidyverse)
library(datos)
```

## datos {#nycflights13-relational}

Usaremos el paquete datos^[NdT. El texto original se refiere al paquete nycflights13 cuya traducción se incluye en el paquete datos.] para aprender de los datos relacionales. datos contiene cuatro tablas que se relacionan con la tabla `vuelos` que se usó en [data transformation]:

* `aerolineas` permite observar el nombre completo de la aerolínea a partir de su código abreviado:

 
 ```r
 aerolineas
 #> # A tibble: 16 x 2
 #>   aerolinea nombre                  
 #>   <chr>     <chr>                   
 #> 1 9E        Endeavor Air Inc.       
 #> 2 AA        American Airlines Inc.  
 #> 3 AS        Alaska Airlines Inc.    
 #> 4 B6        JetBlue Airways         
 #> 5 DL        Delta Air Lines Inc.    
 #> 6 EV        ExpressJet Airlines Inc.
 #> # … with 10 more rows
 ```

* `aeropuertos` entrega información de cada aeropuerto, identificado por su código de aeropuerto:

 
 ```r
 aeropuertos
 #> # A tibble: 1,458 x 8
 #>   codigo_aeropuer… nombre latitud longitud altura zona_horaria
 #>   <chr>            <chr>    <dbl>    <dbl>  <int>        <dbl>
 #> 1 04G              Lansd…    41.1    -80.6   1044           -5
 #> 2 06A              Moton…    32.5    -85.7    264           -6
 #> 3 06C              Schau…    42.0    -88.1    801           -6
 #> 4 06N              Randa…    41.4    -74.4    523           -5
 #> 5 09J              Jekyl…    31.1    -81.4     11           -5
 #> 6 0A9              Eliza…    36.4    -82.2   1593           -5
 #> # … with 1,452 more rows, and 2 more variables: horario_verano <chr>,
 #> #   zona_horaria_iana <chr>
 ```

* `aviones` entrega información de cada aeropuerto, identificado por su `codigo_cola`:

 
 ```r
 aviones
 #> # A tibble: 3,322 x 9
 #>   codigo_cola  anio tipo  fabricante modelo motores asientos velocidad
 #>   <chr>       <int> <chr> <chr>      <chr>    <int>    <int>     <int>
 #> 1 N10156       2004 Fixe… EMBRAER    EMB-1…       2       55        NA
 #> 2 N102UW       1998 Fixe… AIRBUS IN… A320-…       2      182        NA
 #> 3 N103US       1999 Fixe… AIRBUS IN… A320-…       2      182        NA
 #> 4 N104UW       1999 Fixe… AIRBUS IN… A320-…       2      182        NA
 #> 5 N10575       2002 Fixe… EMBRAER    EMB-1…       2       55        NA
 #> 6 N105UW       1999 Fixe… AIRBUS IN… A320-…       2      182        NA
 #> # … with 3,316 more rows, and 1 more variable: tipo_motor <chr>
 ```

* `clima` entrega información para cada hora respecto del clima en cada aeropuerto de Nueva York:

 
 ```r
 clima
 #> # A tibble: 26,115 x 15
 #>   origen  anio   mes   dia  hora temperatura punto_rocio humedad
 #>   <chr>  <dbl> <dbl> <int> <int>       <dbl>       <dbl>   <dbl>
 #> 1 EWR     2013     1     1     1        39.0        26.1    59.4
 #> 2 EWR     2013     1     1     2        39.0        27.0    61.6
 #> 3 EWR     2013     1     1     3        39.0        28.0    64.4
 #> 4 EWR     2013     1     1     4        39.9        28.0    62.2
 #> 5 EWR     2013     1     1     5        39.0        28.0    64.4
 #> 6 EWR     2013     1     1     6        37.9        28.0    67.2
 #> # … with 2.611e+04 more rows, and 7 more variables:
 #> #   direccion_viento <dbl>, velocidad_viento <dbl>,
 #> #   velocidad_rafaga <dbl>, precipitacion <dbl>, presion <dbl>,
 #> #   visibilidad <dbl>, fecha_hora <dttm>
 ```

Una forma de mostrar las relaciones entre las diferentes tablas es mediante un diagrama:

<img src="diagrams_w_text_as_path/es/relational-nycflights.svg" width="70%" style="display: block; margin: auto;" />

Este diagrama es un poco sobrecogedor, ¡pero es simple comparado con algunos que verás en el exterior! La clave para entender estos diagramas es recordar que cada relación siempre involucra un par de tablas. No necesitas entender todo el diagrama, necesitas entender la cadena de relaciones entre las tablas que te interesan.

Para datos:

* `vuelos` se connecta con `aviones` a través de la variable `codigo_cola`.
 
* `vuelos` se connecta con `aerolineas` a través de la variable `codigo_carrier`.

* `vuelos` se connecta con `aeropuertos` de dos formas: a través de las variables `origen` y
 `destino`.

* `vuelos` se connecta con `clima` a través de las variables `origen` (ubicación), 
 `anio`, `mes`, `dia` y `hora` (tiempo).

### Ejercicios

1. Imagina que necesitas dibujas (aproximadamente) la ruta que cada avión vuela desde su origen
   hasta el destino. ¿Qué variables necesitas? ¿Qué tablas necesitas combinar?

1. Olvidamos incluir la relación entre `clima` y `aeropuertos`. ¿Cuál es la relación y cómo debe
   aparecer en el diagrama?

1. `clima` únicamente contiene información de los aeropuertos de origen (Nueva York).
    Si contuviera registros para todos los aeropuertos de EEUU, ¿Qué relación tendría con `vuelos`?

1. Sabemos que hay días "especiales" en el año y pocas personas vuelan esos días.
   ¿Cómo se representarían en un data frame? ¿Cuáles serían las llaves primarias de esa tabla?
   ¿Cómo se conectaría con las tablas existentes?

## Llaves

Las variables usadas para conectar cada par de variables se llaman _llaves_ (del inglés _key_). Una llave es una variable (o un conjunto de variables) que identifican de manera única una observación. En casos simples, una sóla variable es suficiente para identificar una observación. Por ejemplo, cada avión está identificado de forma única por su `codigo_cola`. En otros casos, se pueden necesitar múltiples variables. Por ejemplo, para identificar una observación en `clima` se necesitan cinco variables:  `anio`, `mes`, `dia`, `hora` y `origen`.
to identify an observation in `weather` you need five variables: `year`, `month`, `day`, `hour`, and `origin`.

Existen dos tipos de llaves:

* Una _llave primaria_  únicamente identifica una observación en su propia tabla.
  Por ejemplo, `aviones$codigo_cola` es una llave primaria ya que identifica de
  manera única cada avión en la tabla `aviones`.

* Una _llave foránea_ únicamente identifica una observación en otra tabla.
  Por ejemplo, `vuelos$codigo_cola` es una llave foránea ya que aparece en la
  tabla `vuelos`, donde une cada vuelo con un único avión.

Una variable puede ser llave primaria _y_  llave foránea a la vez. Por ejemplo, `origen` es parte de la llave primaria `clima` y también una llave foránea de `aeropuertos`.

Una vez que identificas las llaves primarias en tus tablas, es una buena práctica verificar que identifican de forma única cada observación. Una forma de hacerlo es usar `count()` con las llaves primarias y buscar las entradas con `n` mayor a uno:


```r
aviones %>%
  count(codigo_cola) %>%
  filter(n > 1)
#> # A tibble: 0 x 2
#> # … with 2 variables: codigo_cola <chr>, n <int>

clima %>%
  count(anio, mes, dia, hora, origen) %>%
  filter(n > 1)
#> # A tibble: 3 x 6
#>    anio   mes   dia  hora origen     n
#>   <dbl> <dbl> <int> <int> <chr>  <int>
#> 1  2013    11     3     1 EWR        2
#> 2  2013    11     3     1 JFK        2
#> 3  2013    11     3     1 LGA        2
```

A veces una tabla puede no tener una llave primaria explícita: cada fila es una observación, pero no existe una combinación de variables que la identifique de forma confiable. Por ejemplo, ¿Cuál es la llave primaria en la tabla `vuelos`? Podrás pensar que podría ser la fecha más el vuelo o el código de cola, pero ninguna de esas variables es única:


```r
vuelos %>%
  count(anio, mes, dia, vuelo) %>%
  filter(n > 1)
#> # A tibble: 29,768 x 5
#>    anio   mes   dia vuelo     n
#>   <int> <int> <int> <int> <int>
#> 1  2013     1     1     1     2
#> 2  2013     1     1     3     2
#> 3  2013     1     1     4     2
#> 4  2013     1     1    11     3
#> 5  2013     1     1    15     2
#> 6  2013     1     1    21     2
#> # … with 2.976e+04 more rows

vuelos %>%
  count(anio, mes, dia, codigo_cola) %>%
  filter(n > 1)
#> # A tibble: 64,928 x 5
#>    anio   mes   dia codigo_cola     n
#>   <int> <int> <int> <chr>       <int>
#> 1  2013     1     1 N0EGMQ          2
#> 2  2013     1     1 N11189          2
#> 3  2013     1     1 N11536          2
#> 4  2013     1     1 N11544          3
#> 5  2013     1     1 N11551          2
#> 6  2013     1     1 N12540          2
#> # … with 6.492e+04 more rows
```

Al comenzar a trabajar con estos datos, ingenuamente asumimos que cada número de vuelo se usaría una vez al día: eso haría mucho más simples los problemas de comunicación con un vuelo en específico. ¡Desafortunadamente no es el caso! Si una tabla no tiene una llave primaria, a veces es útil incluir una con `mutate()` y `row_number()`. Eso simplifica unir observaciones una vez que haz hecho algunos filtros y quieres volver a verificar con los datos originales. Esto se llama _llave sustituta_.

Una llave primaria y su correspondiente llave foránea en otra tabla forman una _relación_. Las relaciones son típicamente uno a muchos. Por ejemplo, cada vuelo tiene un avión, pero cada avión tiene muchos vuelos. En otros datos, ocasionalmente verás relaciones uno a uno. Puedes pensar esto como un caso especial de uno a muchos. Puedes modelar relaciones muchos a muchos como relaciones de la forma muchos a uno y uno a muchos. Por ejemplo, en estos datos existe una relación muchos a muchos entre aeroplíneas y aeropuertos: cada aerolínea vuela a muchos aeropuertos, cada aeropuerto recibe a muchas aerolíneas.

### Ejercicios

1. Agrega una llave sustituta a `vuelos`.

1. Identifica las llaves en los siguientes conjuntos de datos

 1. `datos::bateadores`
 1. `datos::nombres`
 1. `datos::atmosfera`
 1. `datos::vehiculos`
 1. `datos::diamantes`
  
 (Puede que necesites leer un poco de documentación.)

1. Dibuja un diagrama que ilustre las conexiones entre las tablas `bateadores`,
  `personas` y `salarios` en el paquete datos. Dibuja otro diagrama que muestre la
  relación entre `personas`, `capitanes` y `premios_capitanes`.

  ¿Cómo caracterizarías las relación entre `bateadores`, `lanzadores` y `jardineros`?

## Uniones de transformación {#mutating-joins}

La primera herramienta que miraremos para combinar pares de variables es la _unión de transformación_. Una unión de transformación te permite combinar variables a partir de dos tablas. Primero une observaciones de acuerdo a sus llaves, luego copia las variables de una tabla en la otra.

Tal como `mutate()`, las funciones de unión incluyen variables por la derecha, por lo que si tienes muchas variables inicialmente, las nuevas variables no se imprimirán. Para estos ejemplos, facilitaremos la vista de lo que ocurre con los ejemplos creando un conjunto de datos más angosto:


```r
vuelos2 <- vuelos %>%
  select(anio:dia, hora, origen, destino, codigo_cola, aerolinea)
vuelos2
#> # A tibble: 336,776 x 8
#>    anio   mes   dia  hora origen destino codigo_cola aerolinea
#>   <int> <int> <int> <dbl> <chr>  <chr>   <chr>       <chr>    
#> 1  2013     1     1     5 EWR    IAH     N14228      UA       
#> 2  2013     1     1     5 LGA    IAH     N24211      UA       
#> 3  2013     1     1     5 JFK    MIA     N619AA      AA       
#> 4  2013     1     1     5 JFK    BQN     N804JB      B6       
#> 5  2013     1     1     6 LGA    ATL     N668DN      DL       
#> 6  2013     1     1     5 EWR    ORD     N39463      UA       
#> # … with 3.368e+05 more rows
```

(Recuerda que en RStudio puedes usar `View()` para evitar este problema.)s problem.)

Imagina que quieres incluir el nombre completo de la aerolínea en `vuelos2`. Puede combinar los datos de `aerolinas` y `vuelos2` mediante `left_join()`:


```r
vuelos2 %>%
  select(-origen, -destino) %>%
  left_join(aerolineas, by = "aerolinea")
#> # A tibble: 336,776 x 7
#>    anio   mes   dia  hora codigo_cola aerolinea nombre                
#>   <int> <int> <int> <dbl> <chr>       <chr>     <chr>                 
#> 1  2013     1     1     5 N14228      UA        United Air Lines Inc. 
#> 2  2013     1     1     5 N24211      UA        United Air Lines Inc. 
#> 3  2013     1     1     5 N619AA      AA        American Airlines Inc.
#> 4  2013     1     1     5 N804JB      B6        JetBlue Airways       
#> 5  2013     1     1     6 N668DN      DL        Delta Air Lines Inc.  
#> 6  2013     1     1     5 N39463      UA        United Air Lines Inc. 
#> # … with 3.368e+05 more rows
```

El resultado de unir aerolíneas y vuelos2 incluye una variable adicional: `nombre`. Esto es por qué llamamos unión de transformación a este tipo de unión. En este caso, puedes obtener el mismo resultado usando `mutate()` junto a las operaciones de filtro de R base:


```r
vuelos2 %>%
  select(-origen, -destino) %>%
  mutate(nombre = aerolineas$nombre[match(aerolinea, aerolineas$aerolinea)])
#> # A tibble: 336,776 x 7
#>    anio   mes   dia  hora codigo_cola aerolinea nombre                
#>   <int> <int> <int> <dbl> <chr>       <chr>     <chr>                 
#> 1  2013     1     1     5 N14228      UA        United Air Lines Inc. 
#> 2  2013     1     1     5 N24211      UA        United Air Lines Inc. 
#> 3  2013     1     1     5 N619AA      AA        American Airlines Inc.
#> 4  2013     1     1     5 N804JB      B6        JetBlue Airways       
#> 5  2013     1     1     6 N668DN      DL        Delta Air Lines Inc.  
#> 6  2013     1     1     5 N39463      UA        United Air Lines Inc. 
#> # … with 3.368e+05 more rows
```

Sin embargo, esto último es difícil de generalizar cuando necesitas unir varias variables y dificulta la lectura para entender lo que se queire hacer.

En las siguientes secciones explicaremos, en detalle, como las uniones de transformación funcionan. Comenzarás aprendiendo una representación visual útil de las uniones. Luego usaremos eso para explicar las cuatro uniones de transformación: unión interior y tres uniones exteriores. Cuando trabajes con datos reales, las llaves no siempre identifican a las observaciones de forma única, por lo que a continuación hablaremos de lo que ocurre cuando no existe una coincidencia única. Finalmente, aprenderás como instruir a dplyr cuales variables son las llaves para una unión dada.

### Entendiendo las uniones

Para ayudarte a entender las uniones, usaremos representaciones gráficas:

<img src="diagrams_w_text_as_path/es/join-setup.svg" style="display: block; margin: auto;" />

```r
x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  3, "x3"
)
y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2",
  4, "y3"
)
```

La columna coloreada representa la variable "llave": estas se usan para unir filas entre las tablas. La columa gris representa la columna "valor" que se usa en todo el proceso. En estos ejemplos te mostraremos una única llave, pero la idea es generalizable de manera directa a múltiples llaves y múltiples valores.

Una unión es una forma de conectar cada fila en `x` con cero, una o más filas en `y`. El siguiente diagrama muestra la coincidencia potencial como la intersección de pares de líneas.

<img src="diagrams_w_text_as_path/es/join-setup2.svg" style="display: block; margin: auto;" />

(Si observas detenidamente, te darás cuenta de que hemos cambiado el orden de las columnas llave y valor en `x`. Esto es para enfatizar que las uniones encuentran coincidencias con base en las llaves, el valor se traslada durante el proceso.)

En la unión que mostramos, las coincidencias se indican con puntos. El número de puntos es igual al numero de coincidencias y al número de filas en la salida.

<img src="diagrams_w_text_as_path/es/join-inner.svg" style="display: block; margin: auto;" />

### Unión interior {#inner-join}

La forma más simple de unión es la _unión interior_ (del inglés _inner join_). Una unión interior une pares de observaciones cualquiera dado que sus llaves son iguales:

<img src="diagrams_w_text_as_path/es/join-inner.svg" style="display: block; margin: auto;" />

(Para ser precisos, esto corresponde a una _equiunión_ interior debido a que las llaves se unen usando el operador de igualdad. Dado que muchas uniones son equiuniones, por lo general omitimos esa especificación)

La salida de una unión interior es un nuevo data frame que contiene la llave, los valores de x y los valores de y. Usamos `by` (significa *por*) para indicar a dplyr cual variable es la llave:


```r
x %>%
  inner_join(y, by = "key")
#> # A tibble: 2 x 3
#>     key val_x val_y
#>   <dbl> <chr> <chr>
#> 1     1 x1    y1   
#> 2     2 x2    y2
```

La propiedad más importante de una unión interior es que las filas no coincidentes no se incluyen en el resultado. Esto significa que generalmente las uniones interiores no son apropiadas para su uso en el análisis de datos dado que es muy fácil perder observaciones.

### Unión exterior {#outer-join}

Una unión interior mantiene las observaciones que aparecen en ambas tablas.  Una _unión exterior_ mantiene las observaciones que aparecen en al menos una de las tablas. Existen tres tipos de unión exterior:

* Una _unión izquierda_ (del inglés _left join_) mantiene todas las observaciones en `x`.
* Una _unión derecha_ (del inglés _right join_) mantiene todas las observaciones en `y`.
* Una _unión completa_ (del inglés _full join_) mantiene todas las observaciones en `x` e `y`.

Estas uniones funcionan agregando una observación "virtual" adicional a cada tabla. Esta observación tiene una llave que siempre coincide (de no haber otras llaves coincidentes) y su valor es `NA`.

Gráficamente corresponde a lo siguiente:

<img src="diagrams_w_text_as_path/es/join-outer.svg" style="display: block; margin: auto;" />

La unión que más frecuentemente se usa es la unión izquierda: úsala cuando necesites buscar datos adicionales en otra tabla, dado que preserva las observaciones originales incluso cuando no hay coincidencias. La unión izquierda debiera ser tu unión por defeecto a menos que tengas un motivo importante para preferir otro tipo.

Otra forma de ilustrar diferentes tipos de uniones es mediante un diagrama de Venn:

<img src="diagrams_w_text_as_path/es/join-venn.svg" style="display: block; margin: auto;" />

Sin embargo, esta no es una buena representación. Puede ayudar a recordar cuales observaciones preservan las observaciones en cual tabla pero esto tiene una limitante importante: un diagrama de Venn no puede mostrar que ocurre con las llaves que no identifican de manera única una observación.

### Llaves duplicadas {#join-matches}

Hasta ahora todos los diagramas han asumido que las llaves son únicas. Pero ese no es siempre el caso. Esta sección explica que ocurre cuando las llaves no son únicas. Existen dos posibilidades:

1. Una tabla tiene llaves duplicadas. Esto es útil cuando quieres agregar información 
  adicional dado que típicamente existe una relación uno a muchos.

 <img src="diagrams_w_text_as_path/es/join-one-to-many.svg" style="display: block; margin: auto;" />
  
  Nota que hemos puesto la columna llave en una posición ligeramente distinta en la salida.
  Esto refleja que la llave es una llave primaria en `y` y una llave foránea en `x`.

 
 ```r
 x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  2, "x3",
  1, "x4"
 )
 y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2"
 )
 left_join(x, y, by = "key")
 #> # A tibble: 4 x 3
 #>     key val_x val_y
 #>   <dbl> <chr> <chr>
 #> 1     1 x1    y1   
 #> 2     2 x2    y2   
 #> 3     2 x3    y2   
 #> 4     1 x4    y1
 ```

1. Ambas tablas tienen llaves duplicadas. Esto es usualmente un error debido a que 
  en ninguna de las tablas las llaves identifican de manera única una observación.
  Cuando unes llaves duplicadas, se obtienen todas las posibles combinaciones, lo que
  corresponde al producto cartesiano:

 <img src="diagrams_w_text_as_path/es/join-many-to-many.svg" style="display: block; margin: auto;" />

 
 ```r
 x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  2, "x3",
  3, "x4"
 )
 y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2",
  2, "y3",
  3, "y4"
 )
 left_join(x, y, by = "key")
 #> # A tibble: 6 x 3
 #>     key val_x val_y
 #>   <dbl> <chr> <chr>
 #> 1     1 x1    y1   
 #> 2     2 x2    y2   
 #> 3     2 x2    y3   
 #> 4     2 x3    y2   
 #> 5     2 x3    y3   
 #> 6     3 x4    y4
 ```

### Definiendo las columnas llave {#join-by}

Hasta ahora, los pares de tablas siempre se han unido de acuerdo a una única variable y esa variable tiene el mismo nombre en ambas tablas. Esta restricción se expresa de la forma `by = "key"`. Puedes usar otros valores de `by` para conectar las tablas de otras maneras:

  * Por defecto, `by = NULL`, usa todas las variables que aparecen en ambas tablas, 
    lo que se conoce como unión _natural_. Por ejemplo, las tablas vuelos y clima 
    coinciden en sus variables comunes: `anio`, `mes`, `dia`, `hora` y `origen`.

 
 ```r
 vuelos2 %>%
  left_join(clima)
 #> Joining, by = c("anio", "mes", "dia", "hora", "origen")
 #> # A tibble: 336,776 x 18
 #>    anio   mes   dia  hora origen destino codigo_cola aerolinea temperatura
 #>   <dbl> <dbl> <int> <dbl> <chr>  <chr>   <chr>       <chr>           <dbl>
 #> 1  2013     1     1     5 EWR    IAH     N14228      UA               39.0
 #> 2  2013     1     1     5 LGA    IAH     N24211      UA               39.9
 #> 3  2013     1     1     5 JFK    MIA     N619AA      AA               39.0
 #> 4  2013     1     1     5 JFK    BQN     N804JB      B6               39.0
 #> 5  2013     1     1     6 LGA    ATL     N668DN      DL               39.9
 #> 6  2013     1     1     5 EWR    ORD     N39463      UA               39.0
 #> # … with 3.368e+05 more rows, and 9 more variables: punto_rocio <dbl>,
 #> #   humedad <dbl>, direccion_viento <dbl>, velocidad_viento <dbl>,
 #> #   velocidad_rafaga <dbl>, precipitacion <dbl>, presion <dbl>,
 #> #   visibilidad <dbl>, fecha_hora <dttm>
 ```

  * Un vector de caracteres, `by = "x"`. Esto es similar a una unión natural, 
    pero usa algunas de las variables comunes. Por ejemplo, `vuelos` y `aviones` 
    tienen la variable `anio`, pero significa cosas distintas en cada tabla 
    por lo que queremos unir por `codigo_cola`.




























