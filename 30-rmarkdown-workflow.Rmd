# Flujo de trabajo en R Markdown


Anteriormente discutimos un flujo de trabajo básico para capturar tu código de R en el que trabajas interactivamente en la  _consola_ y luego capuras los que funciona en el _editor de script_. R Markdown une la _consola_ y el _editor de script_, desdibujando los límites entre exploración interactiva y captura de código a largo plazo. Puedes iterar rápidamente dentro un bloque, editando y re-ejecutando con Cmd/Ctrl + Shift + Enter. Cuando estés conforme, puedes seguir adelante e iniciar un nuevo bloque.


R Markdown es importante también ya que integra de manera estrecha prosa y código. Esto hace que sea un gran __cuaderno de análisis__, porque permite desarrollar código y registrar tus pensamientos. Un cuaderno de análisis comparte muchos de los mismos objetivos que tiene un cuaderno de laboratorio clásico en las ciencias físicas. Puede:

*   Registrar qué se hizo y por qué se hizo. Independientemente de cuán buena sea tu        memoria, si no registras lo que haces llegará un momento en que habrás olvidado        detalles importantes.

*   Apoyar el pensamiento riguroso. Es mas probable que logres un análisis sólido si       registras tus pensamientos mientras avanzas y continuas reflexionando sobre           ellos. Esto también te ahorra tiempo cuando eventualmente escribas tu análisis para compartir con otros.

*   Ayudar a que otras personas comprendan tu trabajo. Es raro hacer un análisis de datos por sola/o; con frecuencia trabajarás como parte de un equipo. Un cuaderno de        laboratorio ayuda a que compartas no solo lo que has hecho, sino también por qué lo hiciste con tus colegas.    


Muchos de estos buenos consejos sobre el uso efectivo de cuadernos de laboratorio pueden también ser aplicados a los cuadernos de análisis. Hemos extraído de nuestras propias experiencias y los consejos de Colin Purrington sobre cuadernos de laboratorio (<http://colinpurrington.com/tips/lab-notebooks>) para sugerir los siguientes consejos:

*   Asegúrate de que cada cuaderno tenga un título descriptivo, un nombre de archivo     evocativo y un primer párrafo que describa brevemente los objetivos del análisis.

*   Utiliza el campo para fecha del encabezado YAML para registrar la fecha en la que      comienzas a trabajar en el cuaderno:     

    ```yaml
    date: 2016-08-23
    ```
    Utiliza el formato ISO8601 AAAA-MM-DD para que no haya ambiguedad. ¡Utilízalo          incluso si no escribes normalmente fechas de ese modo!
    
*   Si pasas mucho tiempo en una idea de análisis y resulta ser un callejón sin            salida, ¡no la elimines!  Escribe una nota breve sobre por qué falló y déjala en       el cuaderno. Esto te ayudará a evitar ir por el mismo callejón sin salida cuando     regreses a ese análisis  en el futuro.    

*   Generalmente, es mejor que hagas la entrada de datos fuera de R. Pero si necesitas     registrar un pequeño bloque de datos, establécelo de modo claro usando                 `tibble::tribble()`.    

*   Si descubres un error en un archivo de datos, nunca lo modifiques directamente,  
    sino que escribe código para corregir el valor. Explica por qué lo corregiste.    

*   Antes de concluir el día, asgúrate de que puedes hacer *knit* en archivo (si          utilizas **cacheo**, asegúrate de limpiar los cachés). Esto te permitirá corregir           cualquier problema mientras el código está todavía fresco en tu mente.       

*   Si quieres que tu código sea reproducible a largo plazo (es decir, que        puedas regresar a ejecutarlo el mes próximo o el año próximo), necesitarás            registrar las versiones de los paquetes que tu código usa. Un enfoque riguroso es     usar __packrat__, <http://rstudio.github.io/packrat/>, el cual almacena paquetes      en tu directorio de proyecto, o __checkpoint__,                                     <https://github.com/RevolutionAnalytics/checkpoint>, el que reinstala paquetes        disponibles en una fecha determinada.  Un truco rápido es incluir un bloque que ejecute `sessionInfo()` --- , esto no te permitirá recrear fácilmente tus paquetes tal y como están hoy, pero por lo menos sabrás cuales eran.    

*   Crearás muchos, muchos, muchos cuadernos de análisis a lo largo de tu carrera.      ¿Cómo puedes organizarlos de modo tal que puedas encontrarlos otra vez en el          futuro? Recomendamos almacenarlos en proyectos individuales y tener un buen            esquema para nombrarlos.     
