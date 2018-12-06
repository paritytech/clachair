# frozen_string_literal: true

require "rails_helper"

feature "Edit Cla" do
  let(:user) { create(:user, role: :admin) }
  let(:cla) { create(:cla) }

  background do
    logged_in_as user
    visit cla_path(cla)
    click_on "Add new"
  end

  scenario "with updated valid fiels" do
    fill_in "cla_name", with: "UDATED CLA NAME"
    fill_in "cla_license_text", with: "UPDATED CLA LICENSE TEXT"
    click_on "Update CLA"

    expect(page).to have_content("CLA has been updated!")
    expect(page).to have_content("UDATED CLA NAME")
    expect(page).to have_content("UPDATED CLA LICENSE TEXT")
  end

  scenario "with updated cla_name and same text" do
    expect do
      fill_in "cla_name", with: "UDATED CLA NAME"
      click_on "Update CLA"
    end.to change { cla.versions.count }.by(0)

    expect(page).to have_content("CLA has been updated!")
  end

  scenario "with empty cla_name field" do
    fill_in "cla_name", with: ""
    fill_in "cla_license_text", with: "UPDATED CLA LICENSE TEXT"
    click_on "Update CLA"

    expect(page).to have_content("Validation failed: Name can't be blank")
  end

  scenario "with empty license_text field" do
    fill_in "cla_license_text", with: ""
    click_on "Update CLA"

    expect(page).to have_content("Validation failed: License text can't be blank")
  end
end
