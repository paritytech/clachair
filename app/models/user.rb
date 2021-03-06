# frozen_string_literal: true

class User < ApplicationRecord
  devise :rememberable, :omniauthable, omniauth_providers: [:github]
  enum role: { user: 0, admin: 100 }

  validates :login, :email, :uid, presence: true, uniqueness: true

  has_many :cla_signatures

  def real_name
    cla_signatures.order(created_at: :desc).first&.real_name || name
  end

  def current_signed_cla_version(repository)
    cla_signatures.find_by(cla_version: repository.cla.current_version, repository: repository)
  end

  def all_signed_cla_versions(repository)
    ClaVersion.joins(:cla_signatures).where(cla_signatures: { repository: repository, user: self })
  end

  def self.from_omniauth(auth)
    user = where(provider: auth.provider, uid: auth.uid).first_or_initialize(
      email: auth.info.email,
      name: auth.info.name,
      login: auth.extra.raw_info.login
    )
    user.token = auth.credentials.token
    user.role = role_for user
    user
  end

  # if the user doesn't have any organization, github API will response empty array:
  # -> user.orgs.list
  # => #<Github::ResponseWrapper @body="[]">
  def organisations
    user = Github.new oauth_token: token, auto_pagination: true
    user.orgs.list.body.map { |org| org[:login]&.downcase }.compact
  end

  def self.role_for(user)
    (user.organisations & Organization.whitelisted_orgs).any? ? :admin : :user
  end
end
