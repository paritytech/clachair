# frozen_string_literal: true

namespace :jobs do
  desc 'load organizations from github'
  task load_organizations: :environment do
    LoadOrganizationsJob.perform_later
  end
end
