FactoryBot.define do
  factory :disposal do
    organization
    user
    container
    disposal_type { association :disposal_type, organization: organization }
    lab { association :lab, organization: organization }
    kgs { 2 }
    volume { 10 }
  end
end

