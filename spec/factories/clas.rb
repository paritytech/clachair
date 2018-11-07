FactoryBot.define do
  factory :cla do
    sequence(:name) { |i| "name#{i}" }
  end
end
