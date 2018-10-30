# frozen_string_literal: true

class Repository < ApplicationRecord
  validates :uid, presence: true, uniqueness: true

  scope :without_license, -> { where(spdx_id: nil) }

  def self.load_repositories(organization)
    org_repos = Github.new.repos.list user: organization.login
    return if org_repos.body.empty?

    org_repos.each do |repo|
      repository            = where(organization_id: organization.id, uid: repo.id).first_or_initialize
      repository.name       = repo.name
      repository.desc       = repo.description
      repository.github_url = repo.html_url
      license               = repo.license

      if license
        repository.spdx_id      = license.spdx_id
        repository.license_name = license.name
      end

      repository.save!
    end
  end
end
