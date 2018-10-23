require 'rails_helper'

feature 'User signed in' do
  context 'new user' do
    context 'from whitelisted organisation' do
      given(:user) { build(:user) }
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
        user = build(:user)
        allow(user).to receive(:organisations).and_return([])

        visit root_path
        mock_auth user

        click_link_or_button 'sign in (GitHub)'

        expect(page).to have_content 'You are not in any of the allowed organisations.'
        expect(page.status_code).to eq 401
      end
    end
  end

  context 'existed user' do
    context 'from whitelisted organisation' do
      given(:user) { create(:user) }
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
        user = create(:user)
        allow(user).to receive(:organisations).and_return([])
        visit root_path
        mock_auth user

        click_link_or_button 'sign in (GitHub)'

        expect(page).to have_content 'You are not in any of the allowed organisations.'
        expect(page.status_code).to eq 401
      end
    end
  end
end

