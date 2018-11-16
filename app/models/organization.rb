# frozen_string_literal: true

class Organization < ApplicationRecord
  WHITELISTED_ORGS = (ENV["ORGANIZATIONS"] || "").split(",").map(&:downcase).freeze

  validates :login, :uid, presence: true, uniqueness: true

  has_many :repositories, dependent: :destroy

  def self.load_organizations
    whitelisted_orgs.each do |whitelisted_org|
      org = Github.new.orgs.get(whitelisted_org)

      organization = where(uid: org.id, login: org.login).first_or_initialize
      organization.github_url = org.html_url
      organization.name       = org.name
      organization.save!

      LoadRepositoriesJob.perform_later(organization)
    end
  end

  def self.whitelisted_orgs
    WHITELISTED_ORGS
  end
end
