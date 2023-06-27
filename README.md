# Shiny App para classificação de idiomas

## [Link do Github](https://github.com/daphnespier/idiomas)
## [Link do App](https://8h163l-daphne-spier.shinyapps.io/traducao/)

**Objetivo:** classificação de textos em 6 idiomas: português, espanhol, italiano, alemão, francês e inglês. 

**Modelo:** SVM (Support Vector Machine)

**Dados fornecidos:** 30 textos para cada idioma

**Funcionalidades:**
- Importar planilha .csv com duas colunas: **texto** e **idioma** para treinar o modelo ou utilizar os dados carregados no app: ([*dados.csv*](https://github.com/daphnespier/idiomas/blob/main/dados.csv) - disponível no GitHub)
- Escolher a proporção de dados de treino e teste
- Selecionar quais características serão utilizadas para ajustar o modelo
- Visualizar:
1) dados carregados
2) características extraídas dos dados
3) dados de treino
4) métricas de avaliação
5) matriz de confusão
6) classificação do novo texto e características extraídas dele
7) listas de stopwords utilizadas


[código em R - *script_codigo.R*](https://github.com/daphnespier/idiomas/blob/main/script_codigo.R)


[código em shiny - *app.R*](https://github.com/daphnespier/idiomas/blob/main/app.R)

