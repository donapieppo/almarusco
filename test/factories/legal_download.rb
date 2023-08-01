FactoryBot.define do
  factory :legal_download do
    organization
    date { Date.today }
    number { 1 }
  end
end
