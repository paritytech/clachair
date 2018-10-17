# frozen_string_literal: true

class User < ApplicationRecord
  devise :rememberable, :omniauthable, omniauth_providers: [:github]

  validates :login, :uid, presence: true, uniqueness: true
  validates :email, :uid, presence: true, uniqueness: true

  def self.from_omniauth(auth)
    User.where(provider: auth.provider, uid: auth.uid).first_or_create(
      email:  auth.info.email,
      name:   auth.info.name,
      login:  auth.extra.raw_info.login
    )
  end

  def self.organisations(token)
    uri                       = URI.parse('https://api.github.com/user/orgs')
    request                   = Net::HTTP::Get.new(uri)
    request['Authorization']  = "token #{token}"
    req_options               = { use_ssl: uri.scheme == 'https' }
    response                  = Net::HTTP.start(uri.hostname, uri.port, req_options) { |http| http.request(request) }
    response.code == '403' ? [] : JSON.parse(response.body).map { |a| a['login'].downcase }
  end
end
