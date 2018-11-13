# frozen_string_literal: true

class Repository < ApplicationRecord
  validates :uid, presence: true, uniqueness: true

  scope :without_license, -> { where(license_spdx_id: nil) }

  belongs_to :cla, optional: true
  belongs_to :organization

  def self.load_repositories(organization)
    org_repos = Github.new.repos.list user: organization.login
    return if org_repos.body.empty?

    org_repos.each do |repo|
      create_repository(organization.id, repo)
    end
  end

  def self.create_repository(organization_id, repo)
    repository = where(organization_id: organization_id, uid: repo.id).first_or_initialize
    repository.name       = repo.name
    repository.desc       = repo.description
    repository.github_url = repo.html_url
    license               = repo.license

    if license
      repository.license_spdx_id  = license.spdx_id
      repository.license_name     = license.name
    end

    repository.save!
  end
end
