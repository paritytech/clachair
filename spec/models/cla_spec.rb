require 'rails_helper'

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
end
