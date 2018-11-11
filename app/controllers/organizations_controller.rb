# frozen_string_literal: true

class OrganizationsController < ApplicationController
  def index
    @organizations = authorize Organization.all
  end

  def show
    @organization = authorize Organization.find(params[:id])
  end

  def trigger_refresh
    authorize LoadOrganizationsJob.perform_later
    redirect_to organizations_path
    flash[:notice] = 'Loading organizations and repositories...'
  end
end
