# frozen_string_literal: true

class LoadOrganizationsJob < ApplicationJob
  queue_as :default

  def perform
    Organization.load_organizations
  end
end
