FactoryBot.define do
  factory :disposal_type do
    organization
    cer_code
    un_code
    physical_state { "liq" } # enum('liq','sp','snp')"
    notes { "" }
    before(:create) do |dt|
      if dt.cer_code.danger?
        hp = FactoryBot.create(:hp_code, id: 123)
        dt.hp_codes << hp
      end
    end
  end
end
