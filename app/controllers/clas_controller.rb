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
    @repository     = Organization.find_by(login: params[:organization]).repositories.find_by(name: params[:repository])
    @cla_signature  = ClaSignature.new
  end

  def cla_version
    @cla = authorize Cla.find(params[:cla])
    @cla_version = @cla.versions.find(params[:version])
  end

  def new
    @cla = authorize Cla.new
  end

  def create
    ActiveRecord::Base.transaction do
      @cla = authorize Cla.new(cla_params)
      # We can't use `create!` here, since we need @cla initialized even in case of failed validations
      @cla.save!
      redirect_to @cla, notice: "CLA has been created!"
    end
  rescue ActiveRecord::RecordInvalid => error
    flash[:alert] = error.message
    render :new
  end

  def edit; end

  def update
    @cla.assign_attributes(cla_params)
    @cla.save!
    redirect_to @cla, notice: "CLA has been updated!"
  rescue ActiveRecord::RecordInvalid => error
    flash[:alert] = error.message
    render :edit
  end

  private

  def cla_params
    params.require(:cla).permit(:name, :license_text)
  end

  def set_cla
    @cla = authorize Cla.find(params[:id])
  end
end
