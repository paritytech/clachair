module OmniauthMacros
  def mock_auth(user)
    credentials = {
      provider:     user.provider,
      uid:          user.uid,
      info:         { email: user.email, name: user.name },
      extra:        { raw_info: { login: user.login }},
      credentials:  { token: 'test_token' }
    }

    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(credentials)
  end
end