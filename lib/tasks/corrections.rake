namespace :almarusco do

  desc "Correct cers"
  task fix_cers_uniqueness: :environment do
    #p c_ok = CerCode.find(26)
    #p c_no = CerCode.find(10)
    p c_ok = CerCode.find(19)
    p c_no = CerCode.find(20)

    c_no.disposal_types.each do |d|
      p "----------------------------"
      x = d.organization.disposal_types.where(cer_code_id: c_ok.id, un_code_id: d.un_code_id).first
      if x && x.hp_code_ids.sort == d.hp_code_ids.sort
        p "ERRROR"
        p d
        p x
      else
        d.update(cer_code_id: c_ok.id)
      end
    end
    c_no.suppliers = []
    c_no.delete
  end
end