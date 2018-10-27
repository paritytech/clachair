require 'rails_helper'

feature 'User visited the home page' do
  context 'with role: whitelisted_user' do
    given(:user) { create(:user, role: :admin) }

    background do
      logged_in_as user
      visit cla_path(organisation: 'paritytech', repository: 'parity-bitcoin')
    end

    scenario 'and saw greeting' do
      expect(page).to have_content("Hello, #{user.name}")
    end
  end

  context 'with role: user' do
    given(:user) { create(:user) }

    background do
      logged_in_as user
      visit cla_path(organisation: 'paritytech', repository: 'parity-bitcoin')
    end

    scenario 'and clicked CLA link' do
      expect(page).to have_content("Hello, #{user.name}, please read:")
      expect(page).to have_content("Contributor's License Agreement")
      expect(page).to have_button("Please sign")
    end
  end

  context 'without registration' do
    given(:user) { build(:user) }

    scenario 'and saw sign in link' do
      visit cla_path(organisation: 'paritytech', repository: 'parity-bitcoin')
      expect(page).to have_content("Contributor's License Agreement")
    end
  end
end
