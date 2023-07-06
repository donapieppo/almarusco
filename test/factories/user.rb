FactoryBot.define do
  factory :user do
    upn { "name_surname@unibo.it" }
    name { "user_name" }
    surname { "user_surname" }
  end
end
