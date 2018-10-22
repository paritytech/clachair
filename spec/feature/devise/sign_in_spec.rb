require 'rails_helper'

feature 'User signed in' do
  context 'new user' do
    given(:user) { build(:user) }

    context 'from whitelisted organisation' do
      scenario 'try to sign in' do
        visit root_path
        mock_auth user
        click_link_or_button 'sign in (GitHub)'

        expect(page).to have_content 'Signed in successfully.'
        expect(current_path).to eq root_path
      end
    end

    context 'not from whitelisted organisation' do
      scenario 'try to sign in' do
        visit root_path
        mock_auth user

        click_link_or_button 'sign in (GitHub)'

        expect(page).to have_content 'You are not in an organization!'
        expect(current_path).to eq root_path
      end
    end
  end

  context 'existed user' do
    given(:user) { create(:user) }

    context 'from whitelisted organisation' do
      scenario 'try to sign in' do
        visit root_path
        mock_auth user
        click_link_or_button 'sign in (GitHub)'

        expect(page).to have_content 'Signed in successfully.'
        expect(current_path).to eq root_path
      end
    end

    context 'not from whitelisted organisation' do
      scenario 'try to sign in' do
        visit root_path
        mock_auth user

        click_link_or_button 'sign in (GitHub)'

        expect(page).to have_content 'You are not in an organization!'
        expect(current_path).to eq root_path
      end
    end
  end
end

