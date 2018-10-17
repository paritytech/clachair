require 'rails_helper'

feature 'User signed out' do
  given(:user) { create(:user) }
  background do
    logged_in_as user
  end

  scenario 'User try to sign out' do
    visit root_path
    click_link_or_button 'sign out'

    expect(page).to have_content 'Signed out successfully.'
    expect(current_path).to eq root_path
  end
end