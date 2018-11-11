# frozen_string_literal: true

class ClasController < ApplicationController
  before_action :set_cla, only: [:show]

  def index
    @clas = authorize Cla.all
  end

  def show; end

  def new
    @cla = authorize Cla.new
  end

  def create
    @cla = authorize Cla.new(cla_params)
    if @cla.save
      redirect_to @cla
      flash[:notice] = 'CLA has been created!'
    else
      render :new
    end
  end

  def display
    @cla = Repository.find_by(organization_id: params[:organization], id: params[:repository]).cla
  end

  private

  def cla_params
    params.require(:cla).permit(:name)
  end

  def set_cla
    @cla = authorize Cla.find(params[:id])
  end
end
