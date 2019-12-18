class PurchasesController < ApplicationController
  before_action :authorize_request
  before_action :find_purchase, except: %i[create index]
  before_action :require_authorization!, only: [:show, :update, :destroy]

  # GET /purchases
  def index
    @purchases = Purchase.where(user: @current_user).all.order(purchase_date: :desc)

    if @purchases.nil?
      render json: { errors: @purchase.errors.full_messages },
             status: :unprocessable_entity
    else
      render json: @purchases.as_json
    end
  end

  # POST /purchases
  def create
    @purchase = Purchase.new(purchase_params)
    @purchase.user = @current_user
    @purchase.original_value = purchase_params[:value]
   
    if @purchase.save
      render json: {message: 'Compra registrada com sucesso'}, status: :created
    else
      render json: { errors: @purchase.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  # PUT /purchases/1
  def update
    @purchase.original_value = purchase_params[:value]
   
    if @purchase.update(purchase_params)
      render json: {message: 'Compra atualizada com sucesso'}
    else
      render json: { errors: @purchase.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  # DELETE /purchases/1
  def destroy
    if @purchase.destroy
      render json: {message: 'Compra excluída com sucesso'}
    else
      render json: { errors: @purchase.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  private
   
    def find_purchase
      @purchase = Purchase.find_by_id(params[:id])
      if @purchase.nil?
        render json: { errors: 'Compra não encontrada' }, status: :not_found
      end
    end

    def purchase_params
      params.permit(
        :cpf, :code, :value, :original_value, :purchase_date
      )
    end

    def require_authorization!
      unless @current_user == @purchase.user
        render json: {message: 'Acesso não autorizado'}, status: :forbidden
      end
    end

    def format_cpf
      purchase_params[:cpf]
    end

    def cpf_validation!
      unless @current_user.cpf != format_cpf
        render json: {message: 'Acesso não autorizado'}, status: :forbidden
      end
    end

end
