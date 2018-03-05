module Api
  class UsersController < ApiController
    before_action :authorize_user, only: [:index, :create]
    before_action :set_user, only: [:show, :update, :destroy]

    def index
      @users = UserPolicy::Scope.new(current_user, User).resolve
    end

    def show; end

    def create
      @user = User.new(user_params)

      if @user.save
        render :show, status: :created, location: [:api, @user]
      else
        render_errors(@user)
      end
    end

    def update
      if @user.update(user_params)
        render :show, status: :ok, location: [:api, @user]
      else
        render_errors(@user)
      end
    end

    def destroy
      @user.destroy
    end

    private

    def set_user
      @user = User.where(id: params[:id]).first!
      authorize @user
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :role)
    end

    def authorize_user
      authorize User
    end
  end
end
