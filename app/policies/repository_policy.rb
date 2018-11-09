# frozen_string_literal: true

class RepositoryPolicy
  attr_reader :current_user, :repository

  def initialize(current_user, repository)
    @current_user = current_user
    @repository = repository
  end

  def show?
    admin?
  end

  def update?
    admin?
  end

  private

  def admin?
    @current_user&.admin?
  end
end
