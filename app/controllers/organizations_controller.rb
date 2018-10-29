# frozen_string_literal: true

class OrganizationsController < ApplicationController
  def index
    @organizations = authorize Organization.all
  end

  def show
    @organization = authorize Organization.find(params[:id])
  end
end
