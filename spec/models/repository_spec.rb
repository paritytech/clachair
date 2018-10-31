require 'rails_helper'

RSpec.describe Repository, type: :model do
  it { should validate_presence_of :uid }
  it { should validate_uniqueness_of(:uid) }

  describe 'load_repositories' do
    context 'creates new repo' do
      let(:organization) { create :organization, login: 'test-organization' }

      subject { Repository.load_repositories(organization) }

      it 'creates a new Repository record' do
        expect{ subject }.to change{ Repository.count }.by(1)
      end
    end
  end
end
