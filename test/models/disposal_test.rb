require "test_helper"

class DisposalTest < ActiveSupport::TestCase
  test ".danger? responds true for danger cer" do
    cer_code = FactoryBot.create(:cer_code, danger: true)
    dt = FactoryBot.create(:disposal_type, cer_code: cer_code)
    d = FactoryBot.create(:disposal, organization: dt.organization, disposal_type: dt)

    assert d.danger?
  end

  test ".danger? responds false for not-danger cer" do
    cer_code = FactoryBot.create(:cer_code, danger: false)
    dt = FactoryBot.create(:disposal_type, cer_code: cer_code)
    d = FactoryBot.create(:disposal, organization: dt.organization, disposal_type: dt)

    assert_not d.danger?
  end

  test "A disposal with not danger cer is legalized when approved" do
    cer_code = FactoryBot.create(:cer_code, danger: true)
    dt = FactoryBot.create(:disposal_type, cer_code: cer_code)
    d = FactoryBot.create(:disposal, organization: dt.organization, disposal_type: dt)

    assert d.approve!
    assert d.approved_at
    assert d.legalized_at
  end

  test "A disposal with danger cer is not legalized when approved" do
    cer_code = FactoryBot.create(:cer_code, danger: false)
    dt = FactoryBot.create(:disposal_type, cer_code: cer_code)
    d = FactoryBot.create(:disposal, organization: dt.organization, disposal_type: dt)

    assert d.approve!
    assert d.approved_at
    assert_not d.legalized_at
  end
end
