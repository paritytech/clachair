require "rails_helper"

RSpec.describe ClaSignaturesController, type: :controller do
  let(:user) { create(:user, role: :user) }
  let(:cla) { create(:cla) }
  let(:cla_version) { create(:cla_version, cla: cla, license_text: "#First\n\n##Second") }
  let(:organization) { create(:organization) }
  let(:repository) { create(:repository, cla: cla, organization_id: organization.id) }

  describe "POST #create" do
    let(:valid_params) { { cla_signature: { real_name: "Real Name", repository_id: repository.id, cla_version_id: cla_version.id, user_id: user.id }} }

    context "role: Unregistered user" do
      it "doesn't create new cla signature" do
        expect { post :create, params: valid_params }.to_not change(ClaSignature, :count)
        expect(response).to redirect_to root_path
      end
    end

    context "role: user" do
      before { sign_in user }

      it "create new cla signature" do
        expect do
          post :create, params: valid_params
        end.to change(ClaSignature, :count).by(1).and change(ClaSignature, :count).by(1)
      end

      it "redirect to show view" do
        post :create, params: valid_params
        expect(response).to redirect_to cla_repository_path(repository.organization.login, repository.name)
      end
    end
  end
end