module Api
  class ApiController < ApplicationController
    include Pundit

    before_action :authenticate_user!
  end
end
