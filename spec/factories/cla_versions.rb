FactoryBot.define do
  factory :cla_version do
    sequence(:license_text) { |i| "#First\n\n##Second\n\nLicense number #{i}" }

    association :cla
  end
end
