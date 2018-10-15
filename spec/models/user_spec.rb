require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :uid }
  it { should validate_presence_of :login }
  it { should validate_presence_of :email }
  it { should validate_uniqueness_of(:uid) }
  it { should validate_uniqueness_of(:login) }

  describe 'from_omniauth' do
    context 'the user already in the DB' do
      let!(:user) { create :user }
      let(:auth) { mock_auth user }

      it 'user logging in' do
        expect{ User.from_omniauth(auth) }.to_not change{ User.count }
      end
    end

    context 'the user is not exist' do
      let(:user) { build :user }
      let(:auth) { mock_auth user }

      it 'create new user' do
        expect{ User.from_omniauth(auth) }.to change{ User.count }.by(1)
      end
    end
  end
end
