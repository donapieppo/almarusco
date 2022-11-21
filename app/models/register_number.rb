class RegisterNumber
  def initialize(number, organization)
    @number = number
    @organization = organization
  end

  def invalid?
    year = Date.today.year
    pids = @organization.pickings.where('YEAR(date) = ?', year).ids
    if PickingDocument.where(register_number: @number).where(picking_id: pids).any?
      return(true)
    end
    if @organization.disposals.where(register_number: @number.to_i).any? 
      return(true)
    end
   false
  end
end
