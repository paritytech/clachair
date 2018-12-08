require "rails_helper"

RSpec.describe Cla, type: :model do
  subject { Cla.new(name: "Here is the content", license_text: "Here is the content") }

  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
  it { should have_many(:versions) }

  context "with multiple versions" do
    subject { create :cla }
    let(:oldest_cla) { ClaVersion.order(created_at: :asc).first }
    let(:freshest_cla) { ClaVersion.order(created_at: :asc).last }

    it "should sort versions be creation date, newest first" do
      expect(subject.versions.first).to eq freshest_cla
      expect(subject.versions.last).to eq oldest_cla
    end

    it "should expose freshest version as current_version" do
      expect(subject.current_version).to eq freshest_cla
    end
  end

  describe "#save" do
    let(:license_text) { "Something stupid in legalese" }
    subject { -> { cla.license_text = license_text; cla.save } } # Lambda is needed to enable one-liner syntax down there

    context "with no existing versions" do
      let(:cla) { create(:cla, versions_count: 0) }
      it { is_expected.to change { ClaVersion.count }.by 1 }
    end

    context "with existing versions" do
      let!(:cla) { create(:cla, versions_count: 5) }

      context "with a new license text" do
        it { is_expected.to change { ClaVersion.count }.by 1 }
      end

      context "with empty license text" do
        let(:license_text) { "" }
        it { is_expected.to_not change { ClaVersion.count } }
      end

      context "with the license text same as last time" do
        let(:license_text) { cla.current_version.license_text }
        it { is_expected.to_not change { ClaVersion.count } }
      end

      context "with the second-to-last license text" do
        let(:license_text) { cla.versions.second.license_text }
        it { is_expected.to change { ClaVersion.count }.by 1 }
      end

      context "with the same license text but with different whitespace" do
        let(:license_text) { "    \r\n   " + cla.current_version.license_text.gsub("\n", "\r\n") + "\r\n   " }
        it { is_expected.to_not change { ClaVersion.count } }
      end
    end
  end
end
