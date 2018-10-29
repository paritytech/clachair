FactoryBot.define do
  factory :repository do
    sequence(:uid)          { |i| "12345#{i}" }
    sequence(:name)         { |i| "name#{i}" }
    sequence(:license_name) { |i| "license_name#{i}" }
    sequence(:spdx_id)      { |i| "spdx_id#{i}" }
    sequence(:github_url)   { |i| "https://github.com/#{i}" }
    sequence(:desc)         { |i| "description#{i}" }
  end
end
