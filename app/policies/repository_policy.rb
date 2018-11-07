# frozen_string_literal: true

class RepositoryPolicy
  attr_reader :current_user, :repository

  def initialize(current_user, repository)
    @current_user = current_user
    @repository = repository
  end

  def show?
    @current_user&.admin?
  end

  def update?
    @current_user&.admin?
  end
end
