class ApplicationController < ActionController::API
  include Concerns::ErrorHandler

  before_action :configure_permitted_parameters, if: :devise_controller?

  respond_to :json

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :role])
  end

  private

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore
    message = I18n.t("#{policy_name}.#{exception.query}", scope: 'pundit', default: :default)
    render_errors(Errors.new(message), :forbidden)
  end

  def not_found(exception)
    render_errors(Errors.new(I18n.t('not_found')), :not_found)
  end
end
