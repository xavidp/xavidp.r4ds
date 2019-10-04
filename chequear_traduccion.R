# paquetes ----------------------------------------------------------------
library(tidyverse)
library(hunspell)
library(tidytext)


# fix fun -----------------------------------------------------------------
obtener_diccionario <- function() {
  message("obtener_diccionario...")

  dir_temp <- tempdir()

  url1 <- "https://raw.githubusercontent.com/titoBouzout/Dictionaries/master/Spanish.aff"
  url2 <- "https://raw.githubusercontent.com/titoBouzout/Dictionaries/master/Spanish.dic"

  destfile1 <- file.path(dir_temp, basename(url1))
  destfile2 <- file.path(dir_temp, basename(url2))

  download.file(url = url1, destfile = destfile1)
  download.file(url = url2, destfile = destfile2)

  dict <- dictionary(destfile1 %>% str_remove("\\.aff"))

  dict
}

obtener_stopwords <- function() {

  message("obtener_stopwords...")

  data_stopwords <- data_frame(
    palabra = read_lines("https://raw.githubusercontent.com/stopwords-iso/stopwords-es/master/stopwords-es.txt")
  )

  data_stopwords

}

obtener_funciones <- function() {
  message("obtener_funciones...")

  paquetes <- tidyverse:::tidyverse_packages()
  paquetes <- c(paquetes, "base", "stats")

  data_funciones <- paquetes %>%
    map(~ try(ls(paste0("package:", .x)))) %>%
    unlist() %>%
    c(paquetes, "tidyverse") %>%
    data_frame(palabra = .) %>%
    distinct(palabra) %>%
    filter(!str_detect(palabra, "Error"))

  data_funciones
}

dict_eng <- dictionary(lang = "en_US")

dict_esp <- obtener_diccionario()

stop_words_df <- obtener_stopwords()

palabras_reservadas_df <- data_frame(
  palabra = c("r4ds",
              # nombres
              "hadley", "wickham",
              "garrett", "grolemund",
              "yihui", "xie",
              "colin", "fay",
              "nathaniel", "venn",
              "jeroen", "ooms",
              "trevor", "hastie",
              "robert", "tibshirani",
              "leeper",
              # paises/ciudasdes
              "detroid", "auckland", "america", "copenhagen", "michigan", "bogota", "paris",
              # empresas/instituciones
              "amzn", "github", "rstudio", "cran", "stata", "sas", "reddit", "linux",
              # variables
              "key", "val", "x1", "x2", "x3", "x4", "y1", "y2", "y3", "nycflights", "vuelos2",
              "df1", "df2", "df3", "t1", "t2", "na", "d1", "d2", "d3", "d4", "d5",
              "mod1", "mod2", "mod3",
              # extensiones
              "s3", "svg", "xml", "fwf", "csv", "tsv", "rds", "html", "json", "htm", "pdf",
              # parametros/funciones
              "delim", "colour", "datetime", "utc", "str", "eval", "chartoraw", "utf",
              "latin1", "latin2", "ascii", "boxplot", "dev", "log", "log2", "lm", "util",
              "diamantes2", "sep", "grey50", "resid", "ymd", "yintercept", "wday", "ns",
              "rlm", "pred", "mdy", "tz", "posixct", "dttm", "difftimes", "setwd", "getwd", "gmt",
              "ctrl", "cmd", "shift", "hjust", "vjust"
              # programas
              "sql", "sqlite", "rpostgresql",
              # sin cat
              "tibbles", "#>", "<-", "", "anio", "eeuu", "backend", "iso8601", "iso",
              "nz", "http", "https", "www", "nyc")
)

# espacios, coma espacio, punto y coma espacio , dos puntos espacio, rmd links, y/o
separadores <- c(
  " ",
  ",",
  ";",
  "-",
  "\\*",
  ":",
  "/",
  "\"",
  "\\(",
  "\\)",
  "\\[",
  "\\]",
  "\\{",
  "\\}",
  "\\.",
  "\\¿",
  "\\?",
  "¡",
  "!",
  ":",
  "-",
  "—",
  "_",
  "\\#",
  "<",
  ">",
  "%",
  "\\^",
  "\\$",
  "~",
  "=",
  "\\|",
  "\\+",
  "'",
  "\n"
)


palabras_funciones_df <- obtener_funciones()

# others fun --------------------------------------------------------------
chequear_traduccion <- function(x = "09-wrangle.Rmd") {

  message(toupper(x))

  chequear_knitr(x)

  data <- obtener_data(x)

  # data <- limpiar_data(data)

  data_palabras <- chequear_palabras(data)

  data_titulos <- chequear_titulos(data)

  list(
    data_palabras,
    data_titulos
  )
}

chequear_knitr <- function(x = "09-wrangle.Rmd") {

  message("chequear_knitr...")

  archivo_temp <- x

  knitr::knit(input = archivo_temp, quiet = TRUE, envir = new.env())

  try(x %>%
        str_replace("Rmd$", "md") %>%
        fs::file_create())

  TRUE

}

obtener_data <- function(x = "09-wrangle.Rmd") {

  message("obtener_data...")

  message("\tleyendo líneas")

  lineas <- read_lines(x)

  message("\tconstruyendo data_frame")

  data <- tibble(
    linea = 1:length(lineas),
    texto = lineas
  )

  data
}

chequear_palabras <- function(data) {

  message("chequear_palabras...")

  message("\tremoviendo líneas vacías")
  data <- filter(data, !str_detect(texto, "^\\s*$"))

  message("\tunnest_tokens")
  separadoresc <- paste0(separadores, collapse = "|")

  data_palabras <- unnest_tokens(data, palabra, texto, token = stringr::str_split, pattern = separadoresc, to_lower = FALSE)

  data_palabras <- data_palabras %>% mutate(palabra2 = tolower(palabra))

  # data_palabras <- data_palabras %>% mutate(palabra2 = str_remove_all(palabra2, caracteres_inicales_finales))

  data_palabras <- data_palabras %>%
    filter(palabra2 != "")

  message("\tremoviendo stopwords")
  data_palabras <- anti_join(
    data_palabras,
    stop_words_df,
    by = c("palabra2" = "palabra")
    )

  message("\tremoviendo funciones tidyverse")
  data_palabras <- data_palabras %>%
    anti_join(palabras_funciones_df, by = c("palabra2" = "palabra"))

  message("\tremoviendo palabras reservadas")
  data_palabras <- data_palabras %>%
      anti_join(palabras_reservadas_df, by = c("palabra2" = "palabra"))

  message("\tremoviendo nombre paquetes")
  data_palabras <- data_palabras %>%
    filter(!palabra2 %in% rownames(installed.packages()))

  message("\tremoviendo url simples")
  data_palabras <- data_palabras %>%
    filter(!str_detect(palabra2, "^.*\\.com$"))

  message("\tremoviendo `codigo`, algunos elementos md, urls")
  data_palabras <- data_palabras %>%
    filter(!str_detect(palabra2, "^`") & !str_detect(palabra2, "`$")) %>%
    filter(!palabra2 %in% c("*", "=")) %>%
    filter(!str_detect(palabra2, "^https:|^http:"))

  data_palabras <- data_palabras %>%
    mutate(
      check_esp = hunspell_check(palabra2, dict = dict_esp),
      check_eng = hunspell_check(palabra2, dict = dict_eng)
    )

  # remuevo palabras que se detectan del español
  data_palabras <- data_palabras %>%
    filter(!check_esp)

  # remuevo palabras que se detectan del inglés
  data_palabras <- data_palabras %>%
    filter(!check_eng)

  # data_palabras <- data_palabras %>%
  #   select(-check_esp, -check_eng)

  data_palabras

}

chequear_titulos <- function(data) {
  message("chequear_titulos...")

  data_titulos1 <- data %>%
    filter(str_detect(texto, "^#+")) %>%
    mutate(
      clase = str_extract(texto, "^#+\\s+"),
      titulo = str_remove(texto, "^#+\\s+"),
      titulo_corregido = stringi::stri_trans_totitle(titulo, opts_brkiter = stringi::stri_opts_brkiter(type = "sentence"))
    ) %>%
    filter(titulo != titulo_corregido) %>%
    unite(texto_corregido, clase, titulo_corregido, sep = "") %>%
    select(-titulo)

  data_titulos2 <- data %>%
    filter(str_detect(texto, "^#+\\s+Ejercicio\\s*$")) %>%
    mutate(texto_corregido = str_replace(texto, "Ejercicio", "Ejercicios"))


  data_titulos <- list(
    data_titulos1,
    data_titulos2
  ) %>%
    reduce(bind_rows) %>%
    arrange(linea)

  data_titulos
}

# CHECK -------------------------------------------------------------------
fs <- dir(pattern = "[0-9]{2}.*\\.Rmd$")
fs <- str_subset(fs, "01", negate = TRUE)
# fs <- sample(fs, size = 4)

res <- map(
  fs,
  chequear_traduccion
)

names(res) <- fs

res

res %>%
  map(1) %>%
  enframe() %>%
  unnest() %>%
  # filter(palabra palabra2) %>%
  View()
