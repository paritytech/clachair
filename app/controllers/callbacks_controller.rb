# frozen_string_literal: true

class CallbacksController < Devise::OmniauthCallbacksController
  WHITELISTED_ORGS = ENV['ORGANIZATIONS'].split(',').map(&:downcase).freeze

  def github
    auth = request.env['omniauth.auth']

    user = User.from_omniauth(auth)
    user.update(token: auth.credentials.token)

    raise MissingMembershipError unless (user.organisations & WHITELISTED_ORGS).any?

    user.save!
    sign_in_and_redirect user
    flash[:notice] = 'Signed in successfully.'
  end

  def destroy
    reset_session
    redirect_to root_path
    flash[:notice] = 'Signed out successfully.'
  end
end
