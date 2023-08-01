FactoryBot.define do
  factory :disposal_type do
    organization
    cer_code
    un_code
    physical_state { "liq" } # enum('liq','sp','snp')"
    notes { "" }
    before(:create) do |dt|
      dt.containers << Container.where(name: "tanica").find_or_create_by(volume: 5)
      dt.containers << Container.where(name: "fusto").find_or_create_by(volume: 10)
      if dt.cer_code.danger?
        dt.hp_codes << HpCode.where(name: "Hp1", description: "ddd").find_or_create_by(id: 123)
      end
    end
  end
end
