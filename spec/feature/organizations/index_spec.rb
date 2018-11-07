require 'rails_helper'

feature 'User visited the home page' do
  given(:organization) { create(:organization, :with_repositories, count: 5) }

  context 'with role: whitelisted_user' do
    given(:user) { create(:user, role: :admin) }

    background do
      logged_in_as user
    end

    scenario 'and saw organisation link' do
      organization
      visit organizations_path
      expect(page).to have_button('Update organizations')
      expect(page).to have_link(organization.name)
      expect(page).to have_css('.badge.badge-primary', text: 5)
    end
  end

  context 'with role: user' do
    given(:user) { create(:user) }

    background do
      logged_in_as user
    end

    scenario 'and does not saw any organisations links' do
      organization
      visit organizations_path
      expect(page).not_to have_link(organization.name)
      expect(page).not_to have_button('Update organizations')
      expect(page).to have_content('You are not authorized for this action')
    end
  end

  context 'without registration' do
    scenario 'and saw sign in link' do
      organization
      visit organizations_path
      expect(page).not_to have_link(organization.name)
      expect(page).not_to have_button('Update organizations')
      expect(page).to have_content('You are not authorized for this action')
    end
  end
end