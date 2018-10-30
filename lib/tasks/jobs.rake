# frozen_string_literal: true

namespace :jobs do
  desc 'load organizations from github'
  task load_organizations: :environment do
    LoadOrganizationsJob.new.perform_later
  end
end
