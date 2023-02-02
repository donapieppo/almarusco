FactoryBot.define do
  factory :disposal_type do
    organization
    cer_code
    un_code
    physical_state { "liq" } # enum('liq','sp','snp')"
    notes { "" }
  end
end

