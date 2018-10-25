require 'rails_helper'

describe CallbacksController, :omniauth do
  describe '#create' do
    let(:whitelisted_organisations) { ['test_organisation'] }
    before do
      stub_const("User::WHITELISTED_ORGS", whitelisted_organisations)
    end

    context 'existing user' do
      let(:user) { create :user }

      before do
        request.env['omniauth.auth'] = mock_auth(user)
        request.env['devise.mapping'] = Devise.mappings[:user]
      end

      context 'with valid token' do
        it "doesn't create a new User object" do
          expect { post :github }.to_not change{ User.count }
        end

        it 'creates a session' do
          expect(session).to be_empty
          post :github
          expect(session).not_to be_empty
        end
      end
    end

    context 'new user' do
      let(:user) { build :user }

      before do
        request.env['omniauth.auth'] = mock_auth(user)
        request.env['devise.mapping'] = Devise.mappings[:user]
      end

      context 'with valid token' do
        it 'creates a new User object' do
          expect { post :github }.to change{ User.count }.by(1)
        end

        it 'creates a session' do
          expect(session).to be_empty
          post :github
          expect(session).not_to be_empty
        end
      end
    end
  end
end