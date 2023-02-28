require "test_helper"

class ContractTest < ActiveSupport::TestCase
  test "ciao" do
    supplier = FactoryBot.create(:supplier)
    cer_code = FactoryBot.create(:cer_code)
    p supplier
    p cer_code
    c = supplier.contracts.new(cer_code_id: cer_code.id, price: 100)
    c.save
    p supplier.cer_codes
    p cer_code.suppliers
  end
end
