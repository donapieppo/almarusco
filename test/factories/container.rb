FactoryBot.define do
  factory :container do
    name { "tanica" }
    sequence(:volume) { |n| n }
  end
end
