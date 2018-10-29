# frozen_string_literal: true

class LoadOrganizationsJob < ApplicationJob
  queue_as :default

  def perform
    load_organizations
  end

  def load_organizations
    User.whitelisted_orgs.each do |org|
      organization = Organization.from_github_api(Github.new.orgs.get(org))
      organization.save!

      LoadRepositoriesJob.perform_later(organization)
    end
  end
end
