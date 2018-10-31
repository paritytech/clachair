require 'rails_helper'

RSpec.describe Repository, type: :model do
  it { should validate_presence_of :uid }
  it { should validate_uniqueness_of(:uid) }

  describe 'load_repositories' do
    context 'creates new repo' do
      let(:organization) { create :organization, login: 'test-organization'  }

      before do
        Repository.load_repositories(organization)
      end

      it 'create a new Repository record' do
        organization.repositories.each do |repository|
          expect(repository.organization_id).to eq organization.id
        end
      end

      it 'changed count repositories after create' do
        expect(Repository.count).to eq organization.repositories.count
      end
    end
  end
end
