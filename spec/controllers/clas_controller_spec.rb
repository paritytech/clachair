# frozen_string_literal: true

require "rails_helper"

RSpec.describe ClasController, type: :controller do

  describe "GET #new" do
    context "role: Admin" do
      let(:admin_user) { create(:user, role: :admin) }
      before do
        sign_in admin_user
        get :new
      end

      it "assigns a new Cla to @cla" do
        expect(assigns(:cla)).to be_a_new(Cla)
      end

      it "renders new view" do
        expect(response).to render_template :new
      end
    end

    context "role: User" do
      let(:user)  { create(:user) }
      before do
        sign_in user
        get :new
      end

      it "doesn't assigns a new Cla to @cla" do
        expect(assigns(:cla)).to be_nil
        expect(response).to redirect_to root_path
      end
    end

    context "role: Unregistered user" do
      before { get :new }

      it "doesn't assigns a new Cla to @cla" do
        expect(assigns(:cla)).to be_nil
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "POST #create" do
    let(:valid_params) { { cla: { name: "New CLA", cla_version: { license_text: "New Cla version text" }}} }

    context "role: Admin" do
      let(:admin_user)      { create(:user, role: :admin) }
      let(:invalid_params)  { { cla: { name: "", cla_version: { license_text: "" }}} }

      before { sign_in admin_user }

      context "with valid attributes" do
        it "saves the new cla in the database" do
          expect do
            post :create, params: valid_params
          end.to change(Cla, :count).by(1).and change(ClaVersion, :count).by(1)
        end

        it "redirect to show view" do
          post :create, params: valid_params
          expect(response).to redirect_to cla_path(assigns(:cla))
        end
      end

      context "with invalid attributes" do
        it "doesn't save the cla to the database" do
          expect { post :create, params: invalid_params }.to_not change(Cla, :count)
        end

        it "re-renders new view" do
          post :create, params: invalid_params
          expect(response).to render_template :new
        end
      end
    end

    context "role: User" do
      let(:user) { create(:user) }

      before { sign_in user }

      it "doesn't create new cla" do
        expect { post :create, params: valid_params }.to_not change(Cla, :count)
        expect { post :create, params: valid_params }.to_not change(ClaVersion, :count)
        expect(response).to redirect_to root_path
      end
    end

    context "role: Unregistered user" do
      it "doesn't create new cla" do
        expect { post :create, params: valid_params }.to_not change(Cla, :count)
        expect { post :create, params: valid_params }.to_not change(ClaVersion, :count)
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "PATCH #update" do
    let(:valid_params) { { cla: { name: "Updated CLA", cla_version: { license_text: "Updated Cla version text" }}} }
    let!(:cla)         { create(:cla, :with_cla_versions) }

    context "role: Admin" do
      let(:admin_user)      { create(:user, role: :admin) }
      let(:invalid_params)  { { cla: { name: "", cla_version: { license_text: "" }}} }

      before { sign_in admin_user }

      it "with valid attributes, changes all fields" do
        expect { patch :update, params: valid_params.merge!(id: cla.id) }.to change{ cla.versions.count }.by(1)

        cla.reload

        expect(cla.name).to eq("Updated CLA")
        expect(cla.current_version.license_text).to eq("Updated Cla version text")
        expect(response).to redirect_to cla_path(assigns(:cla))
      end

      it "with valid attributes, changed only cla name, not changed cla_versions count" do
        with_same_license_text = { cla: { name: "Updated CLA", cla_version: { license_text: cla.current_version.license_text }}}

        expect { patch :update, params: with_same_license_text.merge!(id: cla.id) }.to change{ cla.versions.count }.by(0)

        cla.reload

        expect(cla.name).to eq("Updated CLA")
        expect(cla.current_version.license_text).to eq(with_same_license_text[:cla][:cla_version][:license_text])
        expect(response).to redirect_to cla_path(assigns(:cla))
      end

      it "with invalid attributes, changed nothing" do
        params = invalid_params.merge!(id: cla.id)

        expect { patch :update, params: params }.to_not change(Cla, :count)
        expect { patch :update, params: params }.to_not change(ClaVersion, :count)
        expect(response).to render_template :edit
      end
    end

    context "role: User" do
      let(:user) { create(:user) }

      before { sign_in user }

      it "doesn't update cla" do
        expect { patch :update, params: valid_params.merge!(id: cla.id) }.to_not change(Cla, :count)
        expect { patch :update, params: valid_params.merge!(id: cla.id) }.to_not change(ClaVersion, :count)
        expect(response).to redirect_to root_path
      end
    end

    context "role: Unregistered user" do
      it "doesn't update cla" do
        expect { patch :update, params: valid_params.merge!(id: cla.id) }.to_not change(Cla, :count)
        expect { patch :update, params: valid_params.merge!(id: cla.id) }.to_not change(ClaVersion, :count)
        expect(response).to redirect_to root_path
      end
    end
  end
end