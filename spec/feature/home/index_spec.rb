require 'rails_helper'

feature 'User visited the home page' do
  context 'with role: whitelisted_user' do
    given(:user) { create(:user, role: :admin) }

    background do
      logged_in_as user
      visit root_path
    end

    scenario 'and saw greeting' do
      expect(page).to have_content("Hello, #{user.name}")
    end

    scenario 'and saw admin interface' do
      expect(page).to have_link('Organizations')
      expect(page).to have_link('sign out')
    end
  end

  context 'with role: user' do
    given(:user) { create(:user) }

    background do
      logged_in_as user
      visit root_path
    end

    scenario 'and saw greeting' do
      expect(page).to have_content("Hello, #{user.name}")
      expect(page).to have_link('sign out')
    end

    scenario 'and does not saw admin interface' do
      expect(page).not_to have_link('Organizations')
    end
  end

  context 'without registration' do
    scenario 'and saw sign in link' do
      visit root_path
      expect(page).to have_link('sign in (GitHub)')
    end
  end
end
