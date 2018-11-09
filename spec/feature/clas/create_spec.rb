require 'rails_helper'

feature 'Whitelisted user creates CLA' do
  given(:user) { create(:user, role: :admin) }

  background do
    logged_in_as user
    visit clas_path
    click_on 'Create new CLA'
  end

  scenario 'with valid field' do
    fill_in 'cla_name', with: 'TEST CLA NAME'
    click_on 'Create CLA'

    expect(page).to have_content('CLA has been created!')
    expect(page).to have_content('TEST CLA NAME')
  end

  scenario 'with empty field' do
    click_on 'Create CLA'

    expect(page).to have_content("Name can't be blank")
  end
end