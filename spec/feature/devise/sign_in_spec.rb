require 'rails_helper'

feature 'User signed in' do
  given(:user) { build(:user) }
  scenario 'User try to sign in' do
    visit root_path
    mock_auth user
    click_link_or_button 'sign in (GitHub)'

    expect(page).to have_content 'Signed in successfully.'
    expect(current_path).to eq root_path
  end
end

