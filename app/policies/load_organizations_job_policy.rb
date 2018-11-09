# frozen_string_literal: true

class LoadOrganizationsJobPolicy
  attr_reader :current_user, :organization

  def initialize(current_user, organization)
    @current_user = current_user
    @organization = organization
  end

  def load_organizations?
    admin?
  end

  private

  def admin?
    @current_user&.admin?
  end
end
