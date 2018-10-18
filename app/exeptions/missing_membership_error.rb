# frozen_string_literal: true

class MissingMembershipError < StandardError
  def message
    'You are not in an organization!'
  end
end
