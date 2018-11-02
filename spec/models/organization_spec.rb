require 'rails_helper'

RSpec.describe Organization, type: :model do
  it { should have_many(:repositories).dependent(:destroy) }
  it { should validate_presence_of :uid }
  it { should validate_presence_of :login }
  it { should validate_uniqueness_of(:uid) }
  it { should validate_uniqueness_of(:login) }

  describe 'load_organizations' do
    let(:whitelisted_organisations) { ['test-organization'] }
    before do
      stub_const("Organization::WHITELISTED_ORGS", whitelisted_organisations)
    end

    it 'create a new Organization record' do
      expect { Organization.load_organizations }.to change{ Organization.count }.by(1)
    end

    it 'updates fields if they were changed' do
      create(:organization,
             login: 'test-organization',
             uid: '12345678',
             name: 'old_name',
             github_url: 'https://github.com/old_organization_url')

      Organization.load_organizations
      expect(Organization.count).to eq(1)
      organization = Organization.first

      expect(organization.login).to eq('test-organization')
      expect(organization.uid).to eq('12345678')
      expect(organization.name).to eq('New Organization Name')
      expect(organization.github_url).to eq('https://github.com/test-organization')
    end

    it 'queues the job' do
      expect {
        Organization.load_organizations
      }.to have_enqueued_job(LoadRepositoriesJob).with(Organization.first)
    end
  end
end
