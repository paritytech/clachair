require 'rails_helper'

feature 'User visited the organisations page' do
  given(:organization){ create(:organization, :with_repositories, count: 5) }

  context 'with role: whitelisted_user' do
    given(:user) { create(:user, role: :admin) }

    background do
      logged_in_as user
    end

    scenario 'and saw repository information' do
      repository = organization.repositories.third
      visit repository_path(repository)

      expect(page).to have_content(repository.name)
      expect(page).to have_content(repository.desc)
      expect(page).to have_content(repository.license_name)
      expect(page).to have_content(repository.spdx_id)
    end
  end

  context 'with role: user' do
    given(:user) { create(:user) }

    background do
      logged_in_as user
      visit organization_path(organization)
    end

    scenario 'and does not saw repository information' do
      repository = organization.repositories.fifth
      visit repository_path(repository)

      expect(page).to_not have_content(repository.name)
      expect(page).to_not have_content(repository.desc)
      expect(page).to_not have_content(repository.license_name)
      expect(page).to_not have_content(repository.spdx_id)
      expect(page).to have_content('You are not authorized for this action')
    end
  end

  context 'without registration' do
    background do
      visit organization_path(organization)
    end

    scenario 'and does not saw repository information' do
      expect(page).to_not have_link(organization.repositories.first.name)
      expect(page).to_not have_link(organization.repositories.fifth.name)
      expect(page).to have_content('You are not authorized for this action')
    end
  end
end