# frozen_string_literal: true

require "rails_helper"

feature "Edit Cla" do
  let(:user) { create(:user, role: :admin) }
  let(:cla)  { create(:cla, :with_cla_versions) }

  background do
    logged_in_as user
    visit cla_path(cla)
    click_on "Add new"
  end

  scenario "with valid field" do
    fill_in "cla_name", with: "UDATED CLA NAME"
    fill_in "cla_cla_version_license_text", with: "UPDATED CLA LICENSE TEXT"
    click_on "Create CLA"

    expect(page).to have_content("CLA has been updated!")
    expect(page).to have_content("UDATED CLA NAME")
    expect(page).to have_content("UPDATED CLA LICENSE TEXT")
  end

  scenario "with both empty fields" do
    fill_in "cla_name", with: ""
    fill_in "cla_cla_version_license_text", with: "UPDATED CLA LICENSE TEXT"
    click_on "Create CLA"

    expect(page).to have_content("Name can't be blank")
  end

  scenario "with empty license_text field" do
    fill_in "cla_name", with: "UDATED CLA NAME"
    fill_in "cla_cla_version_license_text", with: ""
    click_on "Create CLA"

    expect(page).to have_content("License text can't be blank")
  end
end
