# frozen_string_literal: true

class OrganizationPolicy
  attr_reader :current_user, :organization

  def initialize(current_user, organization)
    @current_user = current_user
    @organization = organization
  end

  def index?
    @current_user&.admin?
  end

  def show?
    @current_user&.admin?
  end
end
