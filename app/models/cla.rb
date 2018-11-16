# frozen_string_literal: true

class Cla < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :versions, -> { order(created_at: :desc) }, class_name: "ClaVersion"

  def current_version
    versions.first
  end
end
