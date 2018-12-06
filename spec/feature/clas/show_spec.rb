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
    expect(page.html).to include(markdown(cla.current_version.license_text))
  end

  context "for an older CLA version" do
    given(:cla_version) { create :cla_version, cla: cla, license_text: "Something _completely_ different", created_at: 1.hour.ago }
    before do
      visit cla_path(cla, version: cla_version)
    end

    scenario "and sees older CLA contents" do
      expect(page.html).to_not include(markdown(cla.current_version.license_text))
      expect(page.html).to include(markdown(cla_version.license_text))
    end
  end
end
