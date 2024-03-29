namespace :almarusco do
  desc "Fix registers for new table LegalRecord"
  task start_legal_record: :environment do
    PickingDocument.where('register_number is not null').includes(:picking).order(:register_number).find_each do |picking_document|
      picking = picking_document.picking
      ld = picking_document.create_legal_download(organization_id: picking.organization_id, 
                                                  disposal_type_id: picking_document.disposal_type.id,
                                                  number: picking_document.register_number, 
                                                  year: picking.date.year, 
                                                  date: picking.date)
      p ld
    end
  end
end
