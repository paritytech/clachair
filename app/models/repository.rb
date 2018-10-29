# frozen_string_literal: true

class Repository < ApplicationRecord
  validates :uid, presence: true, uniqueness: true

  scope :without_license, -> { where(license_name: nil) }

  def self.from_github_api(id, repo)
    repository            = where(organization_id: id, uid: repo.id).first_or_initialize
    repository.name       = repo.name
    repository.desc       = repo.description
    repository.github_url = repo.html_url
    license               = repo.license

    if license
      repository.license_spdx_id  = license.spdx_id
      repository.license_name     = license.name
    end

    repository
  end
end
