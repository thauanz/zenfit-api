module Api
  class ZentimesController < ApiController
    before_action :authorize_zentime, only: [:index, :create]
    before_action :set_zentime, only: [:show, :update, :destroy]

    def index
      @zentimes = ZentimePolicy::Scope.new(current_user, Zentime).resolve
    end

    def show; end

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
      @zentime = Zentime.where(id: params[:id]).first!
      authorize @zentime
    end

    def zentime_params
      params.require(:zentime).permit(:date_record, :time_record)
    end

    def authorize_zentime
      authorize Zentime
    end
  end
end
