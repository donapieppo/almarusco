# frozen_string_literal: true

class Supplier::ContractsFormComponent < ViewComponent::Base
  include DmUniboCommon::IconHelper

  def initialize(supplier)
    @supplier = supplier
    @contracts = @supplier.contracts.includes(:cer_code).order("cer_codes.name")
    @other_cer_codes = CerCode.where.not(id: @supplier.contracts.pluck(:cer_code_id))
  end
end
