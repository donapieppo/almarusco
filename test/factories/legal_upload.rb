FactoryBot.define do
  factory :legal_upload do
    organization
    date { Date.today }
    number { 1 }
  end
end
