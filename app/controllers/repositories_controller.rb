# frozen_string_literal: true

class RepositoriesController < ApplicationController
  before_action :set_repository, only: %i[show update]

  def show
    @organization = authorize Organization.find(@repository.organization_id)

    cla_id = @repository.cla_id
    @cla = authorize Cla.find(cla_id) if cla_id
  end

  def update
    @repository.update(cla_id: params[:repository][:cla_id])
    redirect_to @repository
  end

  private

  def set_repository
    @repository = authorize Repository.find(params[:id])
  end
end
