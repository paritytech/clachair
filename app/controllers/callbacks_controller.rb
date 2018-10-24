# frozen_string_literal: true

class CallbacksController < Devise::OmniauthCallbacksController
  WHITELISTED_ORGS = (ENV['ORGANIZATIONS'] || '').split(',').map(&:downcase).freeze

  def github
    user = User.from_omniauth(request.env['omniauth.auth'])

    if (user.organisations & whitelisted_orgs).any?
      user.save!
      sign_in_and_redirect user
      flash[:notice] = 'Signed in successfully.'
    else
      flash[:alert] = 'You are not in any of the allowed organisations.'
      render file: 'public/401', status: :unauthorized
    end
  end

  def destroy
    reset_session
    redirect_to root_path
    flash[:notice] = 'Signed out successfully.'
  end

  private def whitelisted_orgs
    WHITELISTED_ORGS
  end
end
