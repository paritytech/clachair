# frozen_string_literal: true

class LoadRepositoriesJob < ApplicationJob
  queue_as :default

  def perform(organization)
    load_repositories(organization)
  end

  private

  def load_repositories(organization)
    org_repos = Github.new.repos.list user: organization.login
    return if org_repos.body.empty?

    org_repos.each do |repo|
      repository = Repository.from_github_api(organization.id, repo)
      repository.save!
    end
  end
end
