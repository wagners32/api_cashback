class UsersController < ApplicationController
  before_action :authorize_request, except: :create
  before_action :find_user, except: %i[create]
  before_action :require_authorization!, only: [:show, :destroy]
 
  # GET /users/{username}
  def show
    render json: @user, status: :ok
  end

  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
      render json: { errors: @user.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  private

    def find_user
      @user = User.find_by_username!(params[:_username])
    rescue ActiveRecord::RecordNotFound
        render json: { errors: 'User not found' }, status: :not_found
    end

    def user_params
      params.permit(
        :name, :username, :cpf, :email, :password, :password_confirmation
      )
    end

    def require_authorization!
      unless @current_user == @user
        render json: {message: 'Acesso não autorizado'}, status: :forbidden
      end
    end
end
