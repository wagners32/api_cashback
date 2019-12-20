class HomeController < ApplicationController
  def index
    render json: {message: 'API CashBack ( https://app.swaggerhub.com/apis-docs/apicashback7/api_cash_back/1.0.0-oas3 )'}
  end
end