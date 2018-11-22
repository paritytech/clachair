# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery
  rescue_from Pundit::NotAuthorizedError, with: :pundishing_user

  before_action :store_user_location, if: :storable_location?

  def after_sign_in_path_for(resource_or_scope)
    stored_location_for(resource_or_scope) || super
  end

  private

  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  def store_user_location
    store_location_for(:user, request.fullpath)
  end

  def pundishing_user
    flash[:alert] = "You are not authorized for this action"
    redirect_to root_path
  end
end
