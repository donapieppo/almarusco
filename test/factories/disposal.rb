FactoryBot.define do
  factory :disposal do
    organization
    user
    disposal_type { association :disposal_type, organization: organization }
    lab { association :lab, organization: organization }
    kgs { 2 }
    container
  end
end
