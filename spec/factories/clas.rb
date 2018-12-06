FactoryBot.define do
  factory :cla do
    sequence(:name) { |i| "name#{i}" }

    transient do
      versions_count { 5 }
    end

    after(:create) do |cla, evaluator|
      create_list(:cla_version, evaluator.versions_count, cla_id: cla.id)
    end
  end
end
