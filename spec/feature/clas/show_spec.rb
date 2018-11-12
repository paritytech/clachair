require 'rails_helper'

feature 'User visited the show page' do
  context 'all users can see CLA' do
    given(:cla) { create(:cla, :with_cla_versions, count: 5) }
    given(:organization) { create(:organization) }
    given(:repository) { create(:repository, cla: cla, organization_id: organization.id) }

    background do
      visit cla_repository_path(repository.organization_id, repository)
    end

    scenario 'and saw CLA name' do
      expect(page).to have_content('Hello, please read and sign:')
      expect(page).to have_content(cla.name)
      expect(page).to have_content(cla.cla_versions.last.license_text)
      expect(page).to have_button('Sign this CLA')
    end
  end
end
