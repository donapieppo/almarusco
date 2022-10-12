require "test_helper"

class DisposalTest < ActiveSupport::TestCase
  test "ciao" do
    d = FactoryBot.create(:disposal)
    assert_instance_of(Disposal, d)
  end
end
