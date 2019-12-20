# API Cashback

Sistema para revendedores(as) cadastrarem
suas compras e acompanharem o retorno de cashback de cada compra.

## Demo e Documentação

https://app.swaggerhub.com/apis-docs/apicashback7/api_cash_back/1.0.0-oas3

## URL heroku

https://apicashback.herokuapp.com

## Development server

Instalar `ruby 2.6.2` ou versão superior à `ruby 2.5`

Instalar `rails ~> 5.2.3` 

Criar o banco de dados `rake db:create`, postgresql, dados de acesso em config/database.yml 

Rodar as migrations `rake db:migrate` 

Executar a seed: `rake db:seed`  para carregar a tabela de faixas de cashback

Subir o server: `rails s`
