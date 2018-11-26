# frozen_string_literal: true

class ClaSignature < ApplicationRecord
  belongs_to :user
  belongs_to :cla
  belongs_to :cla_version
  belongs_to :repository

  validates :real_name, presence: true
end
