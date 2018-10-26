FactoryBot.define do
  factory :user do
    sequence(:login)  { |i| "login#{i}" }
    sequence(:uid)    { |i| "12345#{i}" }
    sequence(:name)   { |i| "name#{i}" }
    sequence(:email)  { |i| "email#{i}@example.test" }
    provider  { 'github' }
    token     { 'valid_token' }
    role      { :user }
  end

  trait(:with_invalid_token) do
    token { 'invalid token' }
  end

  trait(:admin) do
    role { :admin }
  end
end
