# frozen_string_literal: true

class Organization < ApplicationRecord
  validates :login, :uid, presence: true, uniqueness: true

  has_many :repositories, dependent: :destroy

  def self.from_github_api(org)
    organization = where(uid: org.id, login: org.login).first_or_initialize
    organization.github_url = org.html_url
    organization.name       = org.name
    organization
  end
end
