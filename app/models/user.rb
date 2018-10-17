# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable, :registerable, and :omniauthable
  devise :rememberable, :omniauthable, omniauth_providers: [:github]

  validates :login, :uid, presence: true, uniqueness: true
  validates :email, :uid, presence: true, uniqueness: true

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create(
      email:    auth.info.email,
      name:     auth.info.name,
      login:    auth.extra.raw_info.login
    )
  end
end
