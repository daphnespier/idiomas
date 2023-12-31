
require(pacman)
pacman::p_load(stringr, tm, dplyr, e1071, shiny, caret, DT)

# Função para extrair características de um conjunto de texto
extrair_caracteristicas <- function(texto, selecionadas) {
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
    proporcao_palavras_terminadas_n = numeric(length(texto)),
    proporcao_palavras_terminadas_t = numeric(length(texto)),
    proporcao_caracteres_seguidos_mp = numeric(length(texto)),
    proporcao_caracteres_seguidos_mb = numeric(length(texto)),
    proporcao_caracteres_especiais = numeric(length(texto)),
    proporcao_pontuacao = numeric(length(texto)), 
    proporcao_quantidade_vogais = numeric(length(texto)),
    proporcao_quantidade_a = numeric(length(texto)),
    proporcao_quantidade_e = numeric(length(texto)),
    proporcao_quantidade_i = numeric(length(texto)),
    proporcao_quantidade_o = numeric(length(texto)),
    proporcao_quantidade_u = numeric(length(texto)),
    proporcao_vogais_consoantes = numeric(length(texto)),
    proporcao_intersecao_stopwords_frances = numeric(length(texto)), 
    proporcao_intersecao_stopwords_ingles = numeric(length(texto)),
    proporcao_intersecao_stopwords_alemao = numeric(length(texto)), 
    proporcao_intersecao_stopwords_italiano = numeric(length(texto)),
    proporcao_intersecao_stopwords_espanhol = numeric(length(texto)),
    proporcao_intersecao_stopwords_portugues = numeric(length(texto)),
    stringsAsFactors = FALSE)
  
  for (i in 1:length(texto)) {
    texto_atual <- texto[i]
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
      return(length(palavras_comuns) / length(palavras_texto))
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
    dados[i, "proporcao_palavras_terminadas_n"] <- freq_palavras_terminadas_n / length(str_split(texto_limpo, "\\s+")[[1]])
    dados[i, "proporcao_palavras_terminadas_t"] <- freq_palavras_terminadas_t / length(str_split(texto_limpo, "\\s+")[[1]])
    dados[i, "proporcao_caracteres_seguidos_mp"] <- freq_caracteres_seguidos_mp / str_count(tolower(texto_atual), "[a-z]")
    dados[i, "proporcao_caracteres_seguidos_mb"] <- freq_caracteres_seguidos_mb / str_count(tolower(texto_atual), "[a-z]")
    dados[i, "proporcao_caracteres_especiais"] <- freq_caracteres_especiais / str_count(tolower(texto_atual), "[a-z]")
    dados[i, "proporcao_pontuacao"] <- freq_pontuacao / str_count(tolower(texto_atual), "[a-z]")
    dados[i, "proporcao_quantidade_vogais"] <- quantidade_vogais / length(str_split(texto_limpo, "\\s+")[[1]])
    dados[i, "proporcao_quantidade_a"] <- quantidade_a / length(str_split(texto_limpo, "\\s+")[[1]])
    dados[i, "proporcao_quantidade_e"] <- quantidade_e / length(str_split(texto_limpo, "\\s+")[[1]])
    dados[i, "proporcao_quantidade_i"] <- quantidade_i / length(str_split(texto_limpo, "\\s+")[[1]])
    dados[i, "proporcao_quantidade_o"] <- quantidade_o / length(str_split(texto_limpo, "\\s+")[[1]])
    dados[i, "proporcao_quantidade_u"] <- quantidade_u / length(str_split(texto_limpo, "\\s+")[[1]])
    dados[i, "proporcao_vogais_consoantes"] <- proporcao_vogais_consoantes
    dados[i, "proporcao_intersecao_stopwords_frances"] <- proporcao_intersecao_stopwords_frances
    dados[i, "proporcao_intersecao_stopwords_ingles"] <- proporcao_intersecao_stopwords_ingles
    dados[i, "proporcao_intersecao_stopwords_alemao"] <- proporcao_intersecao_stopwords_alemao
    dados[i, "proporcao_intersecao_stopwords_italiano"] <- proporcao_intersecao_stopwords_italiano
    dados[i, "proporcao_intersecao_stopwords_espanhol"] <- proporcao_intersecao_stopwords_espanhol
    dados[i, "proporcao_intersecao_stopwords_portugues"] <- proporcao_intersecao_stopwords_portugues
  }
  
  dados <- select(dados, all_of(selecionadas))
  
  return(dados)
}
split_data <- function(dados, classes, proporcao_treino) {
  library(caret)
  
  # Realizar a amostragem estratificada
  indices_treino <- createDataPartition(dados[[classes]], p = proporcao_treino, list = FALSE)
  
  # Dividir os dados em conjunto de treinamento e teste com base nos índices obtidos
  dados_treino <- dados[indices_treino, ]
  dados_teste <- dados[-indices_treino, ]
  
  # Retornar os dados divididos
  return(list(train = dados_treino, test = dados_teste))
}


# Define a UI do Shiny App
ui <- fluidPage(
  titlePanel("Classificação de Idiomas"),
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Importar arquivo CSV"),
      selectInput("features", "Selecionar características:", choices = c(
        "texto",
        "tamanho_medio_palavras",
        "proporcao_palavras_terminadas_n",
        "proporcao_palavras_terminadas_t",
        "proporcao_caracteres_seguidos_mp",
        "proporcao_caracteres_seguidos_mb",
        "proporcao_caracteres_especiais",
        "proporcao_pontuacao",
        "proporcao_quantidade_vogais",
        "proporcao_quantidade_a",
        "proporcao_quantidade_e",
        "proporcao_quantidade_i",
        "proporcao_quantidade_o",
        "proporcao_quantidade_u",
        "proporcao_vogais_consoantes",
        "proporcao_intersecao_stopwords_frances",
        "proporcao_intersecao_stopwords_ingles",
        "proporcao_intersecao_stopwords_alemao",
        "proporcao_intersecao_stopwords_italiano",
        "proporcao_intersecao_stopwords_espanhol",
        "proporcao_intersecao_stopwords_portugues"
      ), multiple = TRUE),
      sliderInput("proportion", "Proporção de divisão dos dados:", min = 0, max = 1, value = 0.67, step = 0.01),
      actionButton("trainButton", "Treinar modelo"),
      textAreaInput("textInput", "Texto a ser classificado:")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Dados", dataTableOutput("dataTable")),
        tabPanel("Características_extraídas", dataTableOutput("featuresTable")),
        tabPanel("Dados Treino", dataTableOutput("dadosTreinoTesteTable")),
        tabPanel("Métricas de avaliação", dataTableOutput("metricsTable")),
        tabPanel("Matriz de confusão", dataTableOutput("confusionMatrixTable")),
        tabPanel("Classificação de texto", verbatimTextOutput("classificationResult"), dataTableOutput("caracTexto")),
        tabPanel("Stopwords", dataTableOutput("stopw")),
      )
    )
  )
)

# Define o server do Shiny App
server <- function(input, output) {
  
  # Função para ler o arquivo CSV e atualizar os dados
 
  
  dados <- reactive({
    if (is.null(input$file)) {
      # Lê a planilha "dados.csv" diretamente
      read.csv2("dados.csv")
    } else {
      # Lê o arquivo carregado pelo usuário
      read.csv2(input$file$datapath)
    }
  })
  
  # Renderiza a tabela com os dados importados
  output$dataTable <- renderDataTable({
    dados()
  })
  
  # Extrai as características dos dados selecionados
  dadosCaracteristicas <- reactive({
    req(dados())
    req(input$features)
    carac<-extrair_caracteristicas(dados()$texto, selecionadas = input$features)
    cbind(carac, idioma = dados()$idioma)
  })
  
  # Renderiza a tabela com as características extraídas
  output$featuresTable <- renderDataTable({
    dadosCaracteristicas()
  })
  
  # Divide os dados em treino e teste com a proporção selecionada
  dadosTreinoTeste <- reactive({
    req(dados())
    req(input$features)
    req(input$proportion)
    carac <- select(dadosCaracteristicas(), -texto)
    carac$idioma <- as.factor(carac$idioma)
    split_data(carac, "idioma", input$proportion)
    
  })
  
  # Renderiza a tabela dadosTreinoTeste
  output$dadosTreinoTesteTable <- renderDataTable({
    dadosTreinoTeste()$train
  })
  
  # Treina o modelo SVM
  modeloSVM <- eventReactive(input$trainButton, {
    req(dadosTreinoTeste())
    svm(idioma ~ ., data = dadosTreinoTeste()$train)
  })
  
  # Faz previsões no conjunto de teste
  previsoes <- eventReactive(input$trainButton, {
    req(dadosTreinoTeste(), modeloSVM())
    predict(modeloSVM(), newdata = dadosTreinoTeste()$test)
  })
  
  # Calcula a matriz de confusão
  matrizConfusao <- eventReactive(input$trainButton, {
    req(dadosTreinoTeste(), previsoes())
    table(Real = dadosTreinoTeste()$test$idioma, Predito = previsoes())
  })
  
  # Converte a matriz de confusão em data frame
  dfMatrizConfusao <- reactive({
    as.data.frame.matrix(matrizConfusao())
  })
  
  # Calcula as métricas de avaliação
  metricas <- eventReactive(input$trainButton, {
    req(matrizConfusao())
    Precision <- diag(matrizConfusao()) / colSums(matrizConfusao())
    Recall <- diag(matrizConfusao()) / rowSums(matrizConfusao())
    F1Score <- 2 * (Precision * Recall) / (Precision + Recall)
    accuracy <- sum(diag(matrizConfusao())) / sum(matrizConfusao())
    data.frame( Precision, Recall, F1Score, accuracy)
  })
  
  # Renderiza a tabela com as métricas de avaliação
  output$metricsTable <- renderDataTable({
    metricas()
  })
  
  # Renderiza a tabela com a matriz de confusão
  output$confusionMatrixTable <- renderDataTable({
    dfMatrizConfusao()
  })
  
  # Classifica o texto inserido pelo usuário
  
  caracTexto <- eventReactive(input$trainButton, {
    req(input$textInput, modeloSVM())
    texto <- data.frame(texto = input$textInput)
    extrair_caracteristicas(texto$texto, selecionadas = input$features)
  })
  
  classificacaoTexto <- eventReactive(input$trainButton, {
    req(input$textInput, modeloSVM(), caracTexto())
    texto <- data.frame(texto = input$textInput)
    caracteristicas <- extrair_caracteristicas(texto$texto, selecionadas = input$features)
    predict(modeloSVM(), newdata = caracteristicas)
  })
  
  # Renderiza o resultado da classificação do texto
  output$classificationResult <- renderPrint({
    classificacaoTexto()
  })
  
  stopw <- reactive({
    bind_rows(data.frame(Stopwords =  stopwords("fr"), Idioma = "francês"),
    data.frame(Stopwords =  stopwords("en"), Idioma = "inglês"),
    data.frame(Stopwords =  stopwords("de"), Idioma = "alemão"),
    data.frame(Stopwords =  stopwords("it"), Idioma = "italiano"),
    data.frame(Stopwords =  stopwords("es"), Idioma = "espanhol"),
    data.frame(Stopwords =  stopwords("pt"), Idioma = "português"))
  })
  
  # Renderiza a tabela com as características extraídas
  output$caracTexto <- renderDataTable({
    req(input$textInput, modeloSVM(), caracTexto())
    texto <- data.frame(texto = input$textInput)
    t(caracTexto())
  })
  
  # Renderiza a tabela com as stopwords
  output$stopw <- renderDataTable({
    stopw()
  })

}

# Roda o Shiny App
shinyApp(ui = ui, server = server)
