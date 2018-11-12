# frozen_string_literal: true

class Cla < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :cla_versions
end
