require 'rails_helper'

feature 'User signed in' do
  let(:whitelisted_organisations) { ['test_organisation'] }
  before do
    allow_any_instance_of(CallbacksController).to receive(:whitelisted_orgs).and_return(whitelisted_organisations)
  end

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
      let(:whitelisted_organisations) { ['google', 'facebook'] }

      scenario 'try to sign in' do
        visit root_path
        mock_auth user

        click_link_or_button 'sign in (GitHub)'

        expect(page).to have_content 'You are not in any of the allowed organisations.'
        expect(page.status_code).to eq 401
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
      let(:whitelisted_organisations) { ['google', 'facebook'] }

      scenario 'try to sign in' do
        visit root_path
        mock_auth user

        click_link_or_button 'sign in (GitHub)'

        expect(page).to have_content 'You are not in any of the allowed organisations.'
        expect(page.status_code).to eq 401
      end
    end
  end
end
