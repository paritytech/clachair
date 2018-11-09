require 'rails_helper'

feature 'User visited the show page' do
  context 'all users can see CLA' do
    given(:cla) { create(:cla) }
    given(:repository) { create(:repository, cla: cla) }

    background do
      visit cla_repository_path(repository, repository.cla_id)
    end

    scenario 'and saw CLA name' do
      expect(page).to have_content('Hello, please read and sign:')
      expect(page).to have_content(cla.name)
      expect(page).to have_button('Please sign')
    end
  end
end
