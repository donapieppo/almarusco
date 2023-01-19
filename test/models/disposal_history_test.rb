require "test_helper"

class DisposalHistoryTest < ActiveSupport::TestCase
  test "disposal can not be legalized if not accepted" do
    disposal = FactoryBot.create(:disposal)
    legal_record = FactoryBot.create(:legal_record, organization: disposal.organization)
    assert_raise(DisposalHistoryError) { disposal.legalize!(legal_record) }
  end
  
  test "disposal can not be deliverd if not legalized" do
    disposal = FactoryBot.create(:disposal)
    disposal.approve!
    assert_raise(DisposalHistoryError) { disposal.deliver! }
  end

  test "disposal can not be completed if not delivered" do
    disposal = FactoryBot.create(:disposal)
    legal_record = FactoryBot.create(:legal_record, organization: disposal.organization)

    disposal.approve!
    disposal.legalize!(legal_record)

    assert_raise(DisposalHistoryError) { disposal.complete! }
  end
end
