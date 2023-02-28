FactoryBot.define do
  factory :supplier do
    sequence(:id) { |n| n }
    name { "supplier name #{id}" }
    pi { "1234567890#{id}" }
  end
end

