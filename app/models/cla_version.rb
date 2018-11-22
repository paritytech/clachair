# frozen_string_literal: true

class ClaVersion < ApplicationRecord
  belongs_to :cla

  validates :license_text, presence: true
end
