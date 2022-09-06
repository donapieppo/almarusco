FactoryBot.define do
  factory :un_code do
    sequence(:id) { |n| n }
    name { "un_code_name" }
  end
end
