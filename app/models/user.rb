# frozen_string_literal: true

class User < ApplicationRecord
  GITHUB_ORGS_QUERY_URL = URI.parse('https://api.github.com/user/orgs')

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
    request = Net::HTTP::Get.new(GITHUB_ORGS_QUERY_URL)
    request['Authorization'] = "token #{token}"
    req_options = { use_ssl: GITHUB_ORGS_QUERY_URL.scheme == 'https' }

    response = Net::HTTP.start(GITHUB_ORGS_QUERY_URL.hostname, GITHUB_ORGS_QUERY_URL.port, req_options) do |http|
      http.request(request)
    end

    response.code == '200' ? JSON.parse(response.body).map { |a| a['login'].downcase } : []
  end
end
