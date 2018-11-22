# frozen_string_literal: true

class ClaPolicy
  attr_reader :current_user, :cla

  def initialize(current_user, cla)
    @current_user = current_user
    @cla = cla
  end

  def index?
    admin?
  end

  def show?
    admin?
  end

  def display?
    admin?
  end

  def new?
    admin?
  end

  def create?
    admin?
  end

  def edit?
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
