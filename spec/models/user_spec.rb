require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :uid }
  it { should validate_presence_of :login }
  it { should validate_presence_of :email }
  it { should validate_uniqueness_of(:uid) }
  it { should validate_uniqueness_of(:login) }
  it { should have_many(:cla_signatures) }

  describe 'from_omniauth' do
    context 'the user already in the DB' do
      let!(:user) { create :user }
      let(:auth) { mock_auth user }

      it "doesn't create a new User record" do
        expect{ User.from_omniauth(auth) }.to_not change{ User.count }
      end
    end
  end
end
