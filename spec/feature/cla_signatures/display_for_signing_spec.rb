require "rails_helper"

feature "User visits the CLA page for a repo" do
  given(:cla) { create(:cla) }
  given!(:cla_version) { create(:cla_version, cla: cla, license_text: "#First\n\n##Second") }
  given(:organization) { create(:organization) }
  given(:repository) { create(:repository, cla: cla, organization_id: organization.id) }

  scenario "and sees a rendered CLA and sign in message" do
    visit cla_repository_path(organization.login, repository.name)

    expect(page).to have_content("Hello, please read and sign:")
    expect(page).to have_content(cla.name)
    expect(page).to have_selector("h1", text: "First")
    expect(page).to have_selector("h2", text: "Second")
    expect(page).to have_content("Please, sign in (GitHub), to Sign this CLA")
  end

  context "user have admin privileges" do
    given(:user) { create(:user, role: :admin) }

    background do
      logged_in_as user
      visit cla_repository_path(organization.login, repository.name)
    end

    scenario "and sees a rendered CLA" do
      expect(page).to have_content("Hello, please read and sign:")
      expect(page).to have_content(cla.name)
      expect(page).to have_selector("h1", text: "First")
      expect(page).to have_selector("h2", text: "Second")
      expect(page).to have_no_button "Submit", disabled: true
    end
  end

  context "user have user privileges" do
    given(:user) { create(:user, role: :user) }

    background do
      logged_in_as user
      visit cla_repository_path(organization.login, repository.name)
    end

    scenario "and sees a rendered repo with his name an disabled Sign button" do
      expect(page).to have_content("Hello, please read and sign:")
      expect(page).to have_content(cla.name)
      expect(page).to have_selector("h1", text: "First")
      expect(page).to have_selector("h2", text: "Second")
      expect(page).to have_unchecked_field("accept")
      expect(page).to have_button "Submit", disabled: true
      expect(page).to have_field "cla_signature_real_name", with: user.real_name
    end

    scenario "the button is enabled when the checkbox is checked", js: true do
      expect(page).to have_no_button "Submit", disabled: false
      page.find(:css, "#accept").set(true)
      expect(page).to have_button "Submit", disabled: false
    end

    scenario "and signed CLA", js: true do
      page.find(:css, "#accept").set(true)
      click_on("Submit")

      cla_signature = ClaSignature.find_by(user: user, cla_version: cla.current_version)

      expect(page).to have_content "CLA has been signed!"
      expect(page).to have_content "You have already signed this CLA at: #{decorate_date(cla_signature.created_at)}"
    end

    scenario "and signed CLA with empty name", js: true do
      fill_in "cla_signature_real_name", with: ""
      page.find(:css, "#accept").set(true)
      click_on("Submit")

      expect(page).to have_content "Validation failed: Real name can't be blank"
    end

    context "already signed previous CLA version" do
      given!(:new_cla) { create(:cla) }
      given!(:cla_signature) { create(:cla_signature, user: user, cla_version: cla.versions.last, repository: repository, real_name: "Real Name") }

      scenario "and sees a rendered repo with his name an disabled Sign button" do
        expect(page).to have_content("Hello, please read and sign:")
        expect(page).to have_content(cla.name)
        expect(page).to have_content(cla.name)
        expect(page).to have_selector("h1", text: "First")
        expect(page).to have_selector("h2", text: "Second")
        expect(page).to have_unchecked_field("accept")
        expect(page).to have_button "Submit", disabled: true
        expect(page).to have_field "cla_signature_real_name", with: user.real_name
      end
    end
  end
end
