class HomeController < ApplicationController
  def index
    render json: {message: 'API CashBack'}
  end
end