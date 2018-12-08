# frozen_string_literal: true

class ClaVersion < ApplicationRecord
  belongs_to :cla
  has_many :cla_signatures

  validates :license_text, presence: true
end
