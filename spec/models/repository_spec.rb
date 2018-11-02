require 'rails_helper'

RSpec.describe Repository, type: :model do
  it { should validate_presence_of :uid }
  it { should validate_uniqueness_of(:uid) }

  describe 'load_repositories' do

    context 'creates new repo' do
      let(:organization) { build :organization, login: 'test-organization' }

      it 'creates a new Repository record' do
        expect{ Repository.load_repositories(organization) }.to change{ Repository.count }.by(1)
      end
    end

    context 'updates repository' do
      it 'updates fields if they were changed' do
        organization = create(:organization,
                              login: 'test-organization',
                              uid: '12345678',
                              name: 'old_name',
                              github_url: 'https://github.com/old_organization_url')

        create(:repository,
               organization_id: organization.id,
               uid: '87654321',
               name: 'old_name',
               github_url: 'https://github.com/old_repository_url',
               desc: 'old_description',
               license_spdx_id: nil,
               license_name: nil)

        Repository.load_repositories(organization)
        expect(organization.repositories.count).to eq(1)

        repository = organization.repositories.first

        expect(repository.organization_id).to eq(organization.id)
        expect(repository.uid).to eq('87654321')
        expect(repository.name).to eq('test-repo')
        expect(repository.github_url).to eq('https://github.com/Test-Organization/test-repo')
        expect(repository.desc).to eq(nil)
        expect(repository.license_spdx_id).to eq('test_license')
        expect(repository.license_name).to eq('Test License')
      end
    end
  end
end
