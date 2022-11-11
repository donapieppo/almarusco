class Supplier::DisposalTypesComponent < ViewComponent::Base
  def initialize(supplier, organization_id)
    @supplier = supplier
    @organization_id = organization_id
  end
end
