require "rails_helper"

feature "Admin user visits a CLA management page" do
  given(:user) { create(:user, role: :admin) }
  given(:cla) { create(:cla) }
  given(:organization) { create(:organization) }
  given(:repository) { create(:repository, cla: cla, organization_id: organization.id) }

  background do
    logged_in_as user
    visit cla_path(cla)
  end

  scenario "and sees CLA title and contents" do
    expect(page).to have_content(cla.name)
    expect(page).to have_content(cla.current_version.license_text)
  end

  context "for an older CLA version" do
    given(:cla_version) { cla.versions.last }
    before do
      visit cla_path(cla, version: cla_version)
    end

    scenario "and sees older CLA contents" do
      expect(page).to_not have_content(cla.current_version.license_text)
      expect(page).to have_content(cla_version.license_text)
    end
  end
end
