require "test_helper"

class DisposalHistoryTest < ActiveSupport::TestCase
  test "disposal can not be legalized if not approved" do
    disposal = FactoryBot.create(:disposal)
    legal_upload = FactoryBot.create(:legal_upload, disposal_type: disposal.disposal_type, organization: disposal.organization)
    assert_raise(DisposalHistoryError) { disposal.legalize!(legal_upload) }
  end
  
  test "disposal can not be deliverd if not legalized" do
    disposal = FactoryBot.create(:disposal)
    disposal.approve!
    assert_raise(DisposalHistoryError) { disposal.deliver! }
  end

  test "disposal can not be completed if not delivered" do
    disposal = FactoryBot.create(:disposal)
    legal_upload = FactoryBot.create(:legal_upload, disposal_type: disposal.disposal_type, organization: disposal.organization)

    disposal.approve!
    disposal.legalize!(legal_upload)

    assert_raise(DisposalHistoryError) { disposal.complete! }
  end
end
