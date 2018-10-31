require 'rails_helper'

RSpec.describe Organization, type: :model do
  it { should have_many(:repositories).dependent(:destroy) }
  it { should validate_presence_of :uid }
  it { should validate_presence_of :login }
  it { should validate_uniqueness_of(:uid) }
  it { should validate_uniqueness_of(:login) }

  describe 'load_organizations' do
    context 'creates new organization' do
      let(:whitelisted_organisations) { ['test-organization'] }

      before do
        stub_const("Organization::WHITELISTED_ORGS", whitelisted_organisations)
      end

      it 'create a new Organization record' do
        expect { Organization.load_organizations }.to change{ Organization.count }.by(1)
      end
    end
  end
end
