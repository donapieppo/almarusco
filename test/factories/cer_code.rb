FactoryBot.define do
  factory :cer_code do
    sequence(:id) { |n| n }
    name { "cer_code_name" }
    description { "cer code description" }
    danger { false }
  end
end
