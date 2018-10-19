# frozen_string_literal: true

class User < ApplicationRecord
  devise :rememberable, :omniauthable, omniauth_providers: [:github]

  validates :login, :uid, presence: true, uniqueness: true
  validates :email, :uid, presence: true, uniqueness: true

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize(
      email:  auth.info.email,
      name:   auth.info.name,
      login:  auth.extra.raw_info.login,
      token:  auth.credentials.token
    )
  end

  def organisations
    user = Github.new oauth_token: token, auto_pagination: true
    user.orgs.list.body.map { |org| org[:login]&.downcase }.compact
  end
end
