require 'rails_helper'

feature 'User visited the home page' do
  given(:cla) { create(:cla) }

  context 'with role: whitelisted_user' do
    given(:user) { create(:user, role: :admin) }

    background do
      logged_in_as user
    end

    scenario 'and saw cla link' do
      cla
      visit clas_path
      expect(page).to have_link('Create new CLA')
      expect(page).to have_link(cla.name)
    end
  end

  context 'with role: user' do
    given(:user) { create(:user) }

    background do
      logged_in_as user
    end

    scenario 'and does not saw any clas links' do
      cla
      visit clas_path
      expect(page).not_to have_link(cla.name)
      expect(page).not_to have_link('Create new CLA')
      expect(page).to have_content('You are not authorized for this action')
    end
  end

  context 'without registration' do
    scenario 'and saw sign in link' do
      cla
      visit clas_path
      expect(page).not_to have_link(cla.name)
      expect(page).not_to have_button('Create new CLA')
      expect(page).to have_content('You are not authorized for this action')
    end
  end
end