FactoryBot.define do
  factory :organization do
    sequence(:login)      { |i| "login#{i}" }
    sequence(:uid)        { |i| "12345#{i}" }
    sequence(:name)       { |i| "name#{i}" }
    sequence(:github_url) { |i| "https://github.com/#{i}" }

    trait :with_repositories do
      transient do
        count { 5 }
      end

      after(:create) do |organization, evaluator|
        create_list(:repository, evaluator.count, organization_id: organization.id)
      end
    end
  end
end
