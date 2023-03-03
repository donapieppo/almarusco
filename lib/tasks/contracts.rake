require 'csv'

namespace :almarusco do
  desc "Import contract"
  task import_contract: :environment do

    supplier = Supplier.find(4)
    CSV.read("doc/garc.csv", col_sep: "\t").each do |line|
      code = line[0].strip.split('-')[0].strip.gsub(/[^0-9]+/, '')
      price = line[1].to_f
      cer_code = CerCode.where(name: code).first
      if contract = cer_code.contracts.where(supplier_id: supplier.id).first
        contract.update(price: price)
      else
        contract = cer_code.contracts.create!(supplier_id: supplier.id, price: price)
      end
    end
  end
end
