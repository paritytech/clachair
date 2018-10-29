# frozen_string_literal: true

class RepositoriesController < ApplicationController
  def show
    @repository = Repository.find(params[:id])
  end
end
