FactoryBot.define do
  factory :legal_record do
    organization
    year { Date.today.year }
    date { Date.today }
    number { 1 }
  end
end

