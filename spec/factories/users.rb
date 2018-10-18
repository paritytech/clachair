FactoryBot.define do
  factory :user do
    sequence(:login)  { |i| "login#{i}" }
    sequence(:uid)    { |i| "12345#{i}" }
    sequence(:name)   { |i| "name#{i}" }
    sequence(:email)  { |i| "email#{i}@example.test" }
    provider  { 'github' }
    token     { 'valid_token' }
  end

  factory :user_with_invalid_token, class: User do
    sequence(:login)  { |i| "login#{i}" }
    sequence(:uid)    { |i| "12345#{i}" }
    sequence(:name)   { |i| "name#{i}" }
    sequence(:email)  { |i| "email#{i}@example.test" }
    provider  { 'github' }
    token     { 'invalid_token' }
  end
end
