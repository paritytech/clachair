require 'rails_helper'

feature 'User visited the show page' do
  context 'all users can see CLA' do
    given(:cla) { create(:cla) }

    background do
      visit cla_path(cla)
    end

    scenario 'and saw CLA name' do
      expect(page).to have_content('Hello, please read and sign:')
      expect(page).to have_content(cla.name)
      expect(page).to have_button('Please sign')
    end
  end
end
