# frozen_string_literal: true

class ClasController < ApplicationController
  before_action :set_cla, only: %i[show edit update]

  def index
    @clas = authorize Cla.all
  end

  def show
    @cla_version = if params[:version]
                     @cla.versions.find(params[:version])
                   else
                     @cla.current_version
                   end
  end

  def display_for_signing
    @cla = Organization.find_by(login: params[:organization]).repositories.find_by(name: params[:repository]).cla
  end

  def new
    @cla = authorize Cla.new
  end

  def create
    @cla = authorize Cla.new(cla_params)
    if @cla.save
      new_cla_version(@cla.id, params[:cla][:cla_version][:license_text])
      redirect_to @cla
      flash[:notice] = "CLA has been created!"
    else
      render :new
    end
  end

  def edit; end

  def update
    if @cla.update(cla_params)
      new_cla_version(@cla.id, params[:cla][:cla_version][:license_text])
      redirect_to @cla
      flash[:notice] = "CLA has been updated!"
    else
      render :edit
    end
  end

  private

  def new_cla_version(cla_id, license_text)
    cla_version = ClaVersion.new(cla_id: cla_id, license_text: license_text)
    cla_version.save!
  end

  def cla_params
    params.require(:cla).permit(:name)
  end

  def set_cla
    @cla = authorize Cla.find(params[:id])
  end
end
