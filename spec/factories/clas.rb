FactoryBot.define do
  factory :cla do
    sequence(:name) { |i| "name#{i}" }

    trait :with_cla_versions do
      transient do
        count { 5 }
      end

      after(:create) do |cla, evaluator|
        create_list(:cla_version, evaluator.count, cla_id: cla.id)
      end
    end
  end
end
