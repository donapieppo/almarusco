# update pickings set legal_record_id = NULL;
# delete from legal_records;

namespace :almarusco do

  desc "Fix registers for new table LegalRecord"
  task start_legal_record: :environment do
    PickingDocument.includes(:picking).order(:register_number).find_each do |pd|
      if pd.register_number
        lr = LegalRecord.new(organization_id: pd.picking.organization_id, number: pd.register_number, year: pd.picking.date.year, date: Date.today)
        p lr
        lr.save!
        pd.picking.update(legal_record_id: lr.id)
      else
        puts "no register_number"
        p pd
      end
    end
  end
end
