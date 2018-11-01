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
        organization = create :organization, login: 'test-organization'

        Repository.load_repositories(organization)

        repository = Organization.find_by_login('test-organization').repositories.first
        repository.name = 'old_name'
        repository.github_url = 'https://github.com/old_repository_url'
        repository.desc = 'old_description'
        repository.license_spdx_id = 'old_license_spdx_id'
        repository.license_name = 'old_license_name'
        repository.save!

        Repository.load_repositories(organization)
        updated_repository = Organization.find_by_login('test-organization').repositories.first

        expect{ repository.reload }.to change { repository.name }
                                         .from('old_name')
                                         .to(updated_repository.name)
                                         .and change { repository.github_url }
                                                .from('https://github.com/old_repository_url')
                                                .to(updated_repository.github_url)
                                                .and change { repository.desc }
                                                       .from('old_description')
                                                       .to(updated_repository.desc)
                                                       .and change { repository.license_spdx_id }
                                                              .from('old_license_spdx_id')
                                                              .to(updated_repository.license_spdx_id)
                                                              .and change { repository.license_name }
                                                                     .from('old_license_name')
                                                                     .to(updated_repository.license_name)
      end
    end
  end
end
