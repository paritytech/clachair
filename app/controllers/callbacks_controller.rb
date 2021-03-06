# frozen_string_literal: true

class CallbacksController < Devise::OmniauthCallbacksController
  def github
    user = User.from_omniauth(request.env["omniauth.auth"])
    user.save!

    sign_in_and_redirect user
    flash[:notice] = "Signed in successfully."
  end

  def destroy
    reset_session
    redirect_to root_path, notice: "Signed out successfully."
  end
end
