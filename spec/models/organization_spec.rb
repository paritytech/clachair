require 'rails_helper'

RSpec.describe Organization, type: :model do
  it { should have_many(:repositories).dependent(:destroy) }
  it { should validate_presence_of :uid }
  it { should validate_presence_of :login }
  it { should validate_uniqueness_of(:uid) }
  it { should validate_uniqueness_of(:login) }
end
