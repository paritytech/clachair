require 'rails_helper'

RSpec.describe ClaVersion, type: :model do
  it { should belong_to(:cla) }
  it { should validate_presence_of(:license_text) }
end
