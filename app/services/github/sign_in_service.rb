# frozen_string_literal: true

module Github
  class SignInService
    WHITELISTED_ORGS = ENV['ORGANIZATIONS'].split(',').map(&:downcase).freeze

    def call(auth)
      if (WHITELISTED_ORGS & User.organisations(auth.credentials.token)).any?
        User.from_omniauth(auth)
      else
        raise AuthenticationError
      end
    end
  end
end
