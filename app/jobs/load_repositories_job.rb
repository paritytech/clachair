# frozen_string_literal: true

class LoadRepositoriesJob < ApplicationJob
  queue_as :default

  def perform(organization)
    Repository.load_repositories(organization)
  end
end
