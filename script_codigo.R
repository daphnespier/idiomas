library(stringr)
library(tm)
library(dplyr)
library(e1071)



# Função para extrair características de um conjunto de texto
extrair_caracteristicas <- function(texto) {
  # Carregar as listas de stopwords dos idiomas
  stopwords_frances <- stopwords("fr")
  stopwords_ingles <- stopwords("en")
  stopwords_alemao <- stopwords("de")
  stopwords_italiano <- stopwords("it")
  stopwords_espanhol <- stopwords("es")
  stopwords_portugues <- stopwords("pt")
  
  dados <- data.frame(
    texto = numeric(length(texto)),
    tamanho_medio_palavras = numeric(length(texto)),
    freq_palavras_terminadas_n = numeric(length(texto)),
    freq_palavras_terminadas_t = numeric(length(texto)),
    freq_caracteres_seguidos_mp = numeric(length(texto)),
    freq_caracteres_seguidos_mb = numeric(length(texto)),
    freq_caracteres_especiais = numeric(length(texto)),
    freq_pontuacao = numeric(length(texto)), 
    quantidade_vogais = numeric(length(texto)),
    quantidade_a = numeric(length(texto)),
    quantidade_e = numeric(length(texto)),
    quantidade_i = numeric(length(texto)),
    quantidade_o = numeric(length(texto)),
    quantidade_u = numeric(length(texto)),
    proporcao_vogais_consoantes = numeric(length(texto)),
    stpw_frances = numeric(length(texto)), 
    stpw_ingles = numeric(length(texto)),
    stpw_alemao = numeric(length(texto)), 
    stpw_italiano = numeric(length(texto)),
    stpw_espanhol = numeric(length(texto)),
    stpw_portugues = numeric(length(texto)),
    stringsAsFactors = FALSE)
  
  for (i in 1:length(texto)) {
    texto_atual <- texto[i]
    texto_limpo <- gsub("[^[:alnum:][:space:]]", "", iconv(texto_atual, to = "ASCII//TRANSLIT"))
    freq_caracteres_seguidos_mp <- sum(str_detect(tolower(texto_atual), "mp"))
    freq_caracteres_seguidos_mb <- sum(str_detect(tolower(texto_atual), "mb"))
    padrao <- "[áéíóúÁÉÍÓÚâêîôûÂÊÎÔÛàèìòùÀÈÌÒÙãõñÃÕÑäëïöüÄËÏÖÜÇç[:punct:]]"
    freq_caracteres_especiais <- str_count(texto_atual, padrao)
    freq_pontuacao <- sum(str_count(texto_atual, "[[:punct:]]"))
    
    texto_limpo <- gsub("[^[:alnum:][:space:]]", "", iconv(texto_atual, to = "ASCII//TRANSLIT"))
    tamanho_medio_palavras <- mean(str_length(str_split(texto_limpo, "\\s+")[[1]]))
    freq_palavras_terminadas_n <- sum(str_detect(str_split(texto_limpo, "\\s+")[[1]], "n$"))
    freq_palavras_terminadas_t <- sum(str_detect(str_split(texto_limpo, "\\s+")[[1]], "t$"))
    quantidade_vogais <- str_count(tolower(texto_limpo), "[aeiou]")
    quantidade_a <- str_count(tolower(texto_limpo), "a")
    quantidade_e <- str_count(tolower(texto_limpo), "e")
    quantidade_i <- str_count(tolower(texto_limpo), "i")
    quantidade_o <- str_count(tolower(texto_limpo), "o")
    quantidade_u <- str_count(tolower(texto_limpo), "u")
    proporcao_vogais_consoantes <- quantidade_vogais / (str_count(tolower(texto_atual), "[a-z]") - quantidade_vogais)
    
    # Função para calcular a interseção do texto com as stopwords de um idioma específico
    calcular_stopwords <- function(texto, stopwords) {
      palavras_texto <- unlist(strsplit(tolower(texto), " "))
      palavras_stopwords <- unlist(strsplit(tolower(stopwords), " "))
      palavras_comuns <- intersect(palavras_texto, palavras_stopwords)
      return(length(palavras_comuns))
    }
    
    # Calcular a interseção com as stopwords para cada idioma
    proporcao_intersecao_stopwords_frances <- calcular_stopwords(texto_atual, stopwords_frances)
    proporcao_intersecao_stopwords_ingles <- calcular_stopwords(texto_atual, stopwords_ingles)
    proporcao_intersecao_stopwords_alemao <- calcular_stopwords(texto_atual, stopwords_alemao)
    proporcao_intersecao_stopwords_italiano <- calcular_stopwords(texto_atual, stopwords_italiano)
    proporcao_intersecao_stopwords_espanhol <- calcular_stopwords(texto_atual, stopwords_espanhol)
    proporcao_intersecao_stopwords_portugues <- calcular_stopwords(texto_atual, stopwords_portugues)
    
    dados[i, "texto"] <- texto_atual
    dados[i, "tamanho_medio_palavras"] <- tamanho_medio_palavras
    dados[i, "freq_palavras_terminadas_n"] <- freq_palavras_terminadas_n
    dados[i, "freq_palavras_terminadas_t"] <- freq_palavras_terminadas_t
    dados[i, "freq_caracteres_seguidos_mp"] <- freq_caracteres_seguidos_mp
    dados[i, "freq_caracteres_seguidos_mb"] <- freq_caracteres_seguidos_mb
    dados[i, "freq_caracteres_especiais"] <- freq_caracteres_especiais
    dados[i, "freq_pontuacao"] <- freq_pontuacao
    dados[i, "quantidade_vogais"] <- quantidade_vogais
    dados[i, "quantidade_a"] <- quantidade_a
    dados[i, "quantidade_e"] <- quantidade_e
    dados[i, "quantidade_i"] <- quantidade_i
    dados[i, "quantidade_o"] <- quantidade_o
    dados[i, "quantidade_u"] <- quantidade_u
    dados[i, "proporcao_vogais_consoantes"] <- proporcao_vogais_consoantes
    dados[i, "stpw_frances"] <- proporcao_intersecao_stopwords_frances
    dados[i, "stpw_ingles"] <- proporcao_intersecao_stopwords_ingles
    dados[i, "stpw_alemao"] <- proporcao_intersecao_stopwords_alemao
    dados[i, "stpw_italiano"] <- proporcao_intersecao_stopwords_italiano
    dados[i, "stpw_espanhol"] <- proporcao_intersecao_stopwords_espanhol
    dados[i, "stpw_portugues"] <- proporcao_intersecao_stopwords_portugues
    
  }
  
  return(dados)
}



# Extrair características dos dados
dados <- read.csv2("dados.csv")
carac<- extrair_caracteristicas(dados$texto)
carac <- select(carac, -texto)
dados<-cbind(carac, idioma = dados$idioma)
# Converter a coluna "idioma" em um fator
dados$idioma <- as.factor(dados$idioma)



# Criar uma função para dividir os dados em treino e teste com proporção específica

split_data <- function(dados, classes, proporcao_treino) {
  library(caret)
  
  # Realizar a amostragem estratificada
  indices_treino <- createDataPartition(dados[[classes]], times = 1, p = proporcao_treino, list = FALSE)
  
  # Dividir os dados em conjunto de treinamento e teste com base nos índices obtidos
  dados_treino <- dados[indices_treino, ]
  dados_teste <- dados[-indices_treino, ]
  
  # Retornar os dados divididos
  return(list(train = dados_treino, test = dados_teste))
}

# Dividir os dados em conjunto de treinamento e teste ,com 2/3 de cada categoria
set.seed(123)  # Definir a semente para reprodutibilidade
data_split <- split_data(dados, "idioma", 2/3)
dados_treino <- data_split$train
dados_teste <- data_split$test

# Treinar o modelo SVM
modelo_svm <- svm(idioma ~ ., data = dados_treino)

# Fazer previsões no conjunto de teste
previsoes <- predict(modelo_svm, newdata = dados_teste)

# Calcular a matriz de confusão
matriz_confusao <- table(Real = dados_teste$idioma, Predito = previsoes)

# Calcular as métricas de avaliação
acuracia <- sum(diag(matriz_confusao)) / sum(matriz_confusao)
precisao <- diag(matriz_confusao) / colSums(matriz_confusao)
recall <- diag(matriz_confusao) / rowSums(matriz_confusao)
f1_score <- 2 * (precisao * recall) / (precisao + recall)

# Imprimir a matriz de confusão e as métricas de avaliação
print(matriz_confusao)
print(acuracia)
print(precisao)
print(recall)
print(f1_score)

# teste do modelo
texto<-"Mi madre camina por la playa"

dados_texto <- extrair_caracteristicas(texto)
dados_texto
idioma_previsto <- predict(modelo_svm, newdata = dados_texto)
idioma_previsto
