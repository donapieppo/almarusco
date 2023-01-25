class Supplier::DisposalTypesComponent < ViewComponent::Base
  def initialize(supplier, organization_id)
    @supplier = supplier
    @organization_id = organization_id
    @disposal_types = @supplier.contract_disposal_types(@organization_id).includes(:cer_code, :un_code, :hp_codes).order(:cer_code_id).to_a
  end
end
