# frozen_string_literal: true

class Cla < ApplicationRecord
  attr_accessor :license_text
  after_find :load_license_text
  after_save :update_license_text

  validates :name, presence: true, uniqueness: true
  has_many :versions, -> { order(created_at: :desc) }, class_name: "ClaVersion"

  def current_version
    versions.first
  end

  private

  def load_license_text
    self.license_text = current_version.license_text if current_version
  end

  def update_license_text
    return if current_version && license_text == current_version.license_text

    versions.create!(license_text: license_text)
  end
end
