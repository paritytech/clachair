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
    ActiveRecord::Base.transaction do
      @cla = authorize Cla.new(cla_params)
      @cla.save!
      @cla.versions.create!(license_text: params[:cla][:cla_version][:license_text])
      redirect_to @cla, notice: "CLA has been created!"
    end
  rescue ActiveRecord::RecordInvalid => error
    flash[:alert] = error.message
    render :new
  end

  def edit; end

  def update
    license_text = params[:cla][:cla_version][:license_text]
    authorize @cla
    @cla.name = params[:cla][:name]
    @cla.save! if @cla.changed?
    @cla.versions.create!(license_text: license_text) if license_text != @cla.current_version.license_text
    redirect_to @cla, notice: "CLA has been updated!"
  rescue ActiveRecord::RecordInvalid => error
    flash[:alert] = error.message
    render :edit
  end

  private

  def cla_params
    params.require(:cla).permit(:name)
  end

  def set_cla
    @cla = authorize Cla.find(params[:id])
  end
end
