# frozen_string_literal: true

class AuthenticationError < StandardError
  def message
    'You are not in an organization!'
  end
end
