# frozen_string_literal: true

class ClaSignaturesController < ApplicationController
  before_action :set_repository, set_repository: %i[create]

  def create
    message =
      begin
        authorize ClaSignature.create!(cla_signtaure_params)
        { notice: "CLA has been signed as #{params[:cla_signature][:real_name]}!" }
      rescue ActiveRecord::RecordInvalid => error
        { alert: error.message }
      end

    redirect_to cla_repository_path(@repository.organization.login, @repository.name), message
  end

  private

  def set_repository
    @repository = authorize Repository.find(params[:cla_signature][:repository_id])
  end

  def cla_signtaure_params
    params.require(:cla_signature).permit(:real_name, :repository_id, :cla_version_id, :user_id)
  end
end
