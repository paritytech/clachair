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

    context 'creates new organization' do
      it 'create a new Organization record' do
        expect { Organization.load_organizations }.to change{ Organization.count }.by(1)
      end
    end

    context 'updates organization' do
      it 'updates fields if they were changed' do
        Organization.load_organizations
        organization = Organization.find_by_login('test-organization')
        organization.name = 'old_name'
        organization.github_url = 'https://github.com/old_organization_url'
        organization.save!
        Organization.load_organizations
        updated_organization = Organization.find_by_login('test-organization')

        expect{ organization.reload }.to change { organization.name }
                                           .from('old_name')
                                           .to(updated_organization.name)
                                           .and change { organization.github_url }
                                                  .from('https://github.com/old_organization_url')
                                                  .to(updated_organization.github_url)
      end
    end

    context 'call LoadRepositoriesJob after create organization' do
      let(:organization){ create(:organization, :with_repositories, count: 5) }
      subject(:job) { LoadRepositoriesJob.perform_later(organization.repositories.count) }

      it 'call LoadRepositoriesJob' do
        expect { job }.to have_enqueued_job(LoadRepositoriesJob).with(organization.repositories.count).on_queue('default')
      end
    end
  end
end
