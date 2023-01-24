# update pickings set legal_record_id = NULL;
# delete from legal_records;

namespace :almarusco do
  desc "Fix registers for new table LegalRecord"
  task start_legal_record: :environment do
    PickingDocument.where('register_number is not null').includes(:picking).order(:register_number).find_each do |pd|
      ld = pd.create_legal_download(organization_id: pd.picking.organization_id, 
                                    disposal_type: pd.disposal_type,
                                    number: pd.register_number, 
                                    year: pd.picking.date.year, 
                                    date: pd.picking.date)
      p ld
    end
  end
end
