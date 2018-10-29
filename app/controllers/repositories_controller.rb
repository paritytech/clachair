# frozen_string_literal: true

class RepositoriesController < ApplicationController
  def show
    @repository = authorize Repository.find(params[:id])
    @organization = authorize Organization.find(@repository.organization_id)
  end
end
