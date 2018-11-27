FactoryBot.define do
  factory :cla_signature do
    sequence(:real_name) { |i| "real_name#{i}" }
  end
end
