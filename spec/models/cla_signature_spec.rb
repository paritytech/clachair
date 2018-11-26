require "rails_helper"

RSpec.describe ClaSignature, type: :model do
  it { should validate_presence_of(:real_name) }
  it { should belong_to(:cla) }
  it { should belong_to(:cla_version) }
  it { should belong_to(:user) }
  it { should belong_to(:repository) }
end
