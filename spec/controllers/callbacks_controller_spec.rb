require 'rails_helper'

describe CallbacksController, :omniauth do
  describe '#create' do
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

      context 'with valid token and not in whitelisted organisation' do
        before do
          stub_const("CallbacksController::WHITELISTED_ORGS", [])
        end

        it "doesn't create a new User object" do
          expect { post :github }.to change{ User.count }.by(0)
        end

        it "doesn't creates a session" do
          expect(session).to be_empty

          expect { post :github }

          expect(session).to be_empty
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

      context 'with valid token and not in whitelisted organisation' do
        before do
          stub_const("CallbacksController::WHITELISTED_ORGS", [])
        end

        it "doesn't create a new User object" do
          expect { post :github }.to change{ User.count }.by(0)
        end

        it "doesn't creates a session" do
          expect(session).to be_empty

          expect { post :github }

          expect(session).to be_empty
        end
      end
    end
  end
end