require "test_helper"

class DisposalTypeTest < ActiveSupport::TestCase
  test "phisical state liq -> .liquid? true and .solid? false" do
    dt = FactoryBot.build(:disposal_type, physical_state: :liq)
    assert_equal true, dt.liquid?
    assert_equal false, dt.solid?
  end

  test "phisical state sp -> .liquid? false and .solid? true" do
    dt = FactoryBot.build(:disposal_type, physical_state: :sp)
    assert_equal false, dt.liquid?
    assert_equal true, dt.solid?
  end

  test "phisical state snp -> .liquid? false and .solid? true" do
    dt = FactoryBot.build(:disposal_type, physical_state: :snp)
    assert_equal false, dt.liquid?
    assert_equal true, dt.solid?
  end

  test "cer_and_hps_uniqueness" do
    hp = FactoryBot.create(:hp_code, id: 1)
    p hp
    dt = FactoryBot.create(:disposal_type, physical_state: :liq)
    p dt
    dt.hp_codes << hp
    dt2 = FactoryBot.create(:disposal_type, physical_state: :liq,
                                            cer_code: dt.cer_code,
                                            un_code: dt.un_code, 
                                            organization: dt.organization)
    dt2.hp_codes << hp
    p dt
    p dt2
    p dt.hp_codes
    p dt2.hp_codes
  end
end
