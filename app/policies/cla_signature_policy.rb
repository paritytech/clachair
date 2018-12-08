# frozen_string_literal: true

class ClaSignaturePolicy
  attr_reader :current_user, :cla_signature

  def initialize(current_user, cla_signature)
    @current_user = current_user
    @cla_signature = cla_signature
  end

  def create?
    user?
  end

  private

  def user?
    @current_user&.user?
  end
end
