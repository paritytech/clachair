require "rails_helper"

feature "User visits the CLA page for a repo" do
  given(:cla) { create(:cla, :with_cla_versions, count: 5) }
  given!(:cla_version) { create(:cla_version, cla: cla, license_text: "#First\n\n##Second") }
  given(:organization) { create(:organization) }
  given(:repository) { create(:repository, cla: cla, organization_id: organization.id) }

  background do
    visit cla_repository_path(organization.login, repository.name)
  end

  scenario "and sees a rendered CLA" do
    expect(page).to have_content("Hello, please read and sign:")
    expect(page).to have_content(cla.name)
    expect(page).to have_selector("h1", text: "First")
    expect(page).to have_selector("h2", text: "Second")
    expect(page).to have_content("Please, sign in (GitHub), to Sign this CLA")
  end
end
