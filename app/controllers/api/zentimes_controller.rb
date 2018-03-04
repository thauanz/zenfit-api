module Api
  class ZentimesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_zentime, only: [:show, :update, :destroy]

    def index
      @zentimes = current_user.zentimes.all
    end

    def show
    end

    def create
      @zentime = current_user.zentimes.build(zentime_params)

      if @zentime.save
        render :show, status: :created, location: [:api, @zentime]
      else
        render_errors(@zentime)
      end
    end

    def update
      if @zentime.update(zentime_params)
        render :show, status: :ok, location: [:api, @zentime]
      else
        render_errors(@zentime)
      end
    end

    def destroy
      @zentime.destroy
    end

    private

    def set_zentime
      @zentime = current_user.zentimes.find(params[:id])
    end

    def zentime_params
      params.require(:zentime).permit(:date_record, :time_record)
    end
  end
end
