require 'rails_helper'

feature 'User visited the repository page' do
  given(:organization) { create(:organization, :with_repositories, count: 5) }
  given(:repository) { organization.repositories.fifth }

  context 'as whitelisted user' do
    given(:user) { create(:user, role: :admin) }

    background do
      logged_in_as user
      visit repository_path(repository)
    end

    scenario 'and saw repository information' do
      expect(page).to have_content(repository.name)
      expect(page).to have_content(repository.desc)
      expect(page).to have_content(repository.license_name)
      expect(page).to have_content(repository.license_spdx_id)
    end

    scenario 'and saw cla dropdown and update button' do
      cla         = create(:cla, name: 'cla')
      another_cla = create(:cla, name: 'another_cla')

      visit repository_path(repository)
      expect(page).to have_select 'repository_cla_id', with_options: [cla.name, another_cla.name]
      expect(page).to have_button('Update Repository')
    end
  end

  context 'as non-whitelisted user' do
    given(:user) { create(:user) }

    background do
      logged_in_as user
    end

    scenario 'and does not saw repository information' do
      visit repository_path(repository)

      expect(page).to_not have_content(repository.name)
      expect(page).to_not have_content(repository.desc)
      expect(page).to_not have_content(repository.license_name)
      expect(page).to_not have_content(repository.license_spdx_id)
      expect(page).to have_content('You are not authorized for this action')
    end
  end

  context 'without registration' do
    scenario 'and does not saw repository information' do
      visit repository_path(repository)

      expect(page).to_not have_link(organization.repositories.first.name)
      expect(page).to_not have_link(organization.repositories.fifth.name)
      expect(page).to have_content('You are not authorized for this action')
    end
  end
end