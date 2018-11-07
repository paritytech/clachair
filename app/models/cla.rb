# frozen_string_literal: true

class Cla < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
