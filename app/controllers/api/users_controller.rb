module Api
  class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user, only: [:show, :update, :destroy]

    def index
      @users = User.all
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
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :password)
    end
  end
end
