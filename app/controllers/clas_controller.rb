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
      @cla = Cla.new(cla_params)

      if @cla.save
        cla_version = create_cla_version(@cla.id, params[:cla][:cla_version][:license_text])
        if cla_version.save
          redirect_to @cla
          flash[:notice] = "CLA has been created!"
        else
          @cla.errors.merge!(cla_version.errors)
          render :new
          raise ActiveRecord::Rollback
        end
      else
        render :new
        raise ActiveRecord::Rollback
      end
    end
  end

  def edit; end

  def update
    if @cla.update(cla_params)
      cla_version = create_cla_version(@cla.id, params[:cla][:cla_version][:license_text])
      if cla_version.save
        redirect_to @cla
        flash[:notice] = "CLA has been updated!"
      else
        @cla.errors.merge!(cla_version.errors)
        render :edit
      end
    else
      render :edit
    end
  end

  private

  def create_cla_version(cla_id, license_text)
    ClaVersion.new(cla_id: cla_id, license_text: license_text)
  end

  def cla_params
    params.require(:cla).permit(:name)
  end

  def set_cla
    @cla = authorize Cla.find(params[:id])
  end
end
