FactoryBot.define do
  factory :user do
    sequence(:login)  { |i| "login#{i}" }
    sequence(:uid)    { |i| "12345#{i}" }
    sequence(:name)   { |i| "name#{i}" }
    sequence(:email)  { |i| "email#{i}@example.test" }
    provider { 'github' }
  end
end
