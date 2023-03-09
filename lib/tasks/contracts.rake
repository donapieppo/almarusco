require "csv"

def update_contract(supplier, code, price)
  puts "update_contract #{supplier.name}, #{code} #{price}"
  cer_code = CerCode.where(name: code.to_s).first
  raise "No #{supplier} #{code}" if !cer_code
  if (contract = cer_code.contracts.where(supplier_id: supplier.id).first)
    contract.update(price: price)
  else
    contract = cer_code.contracts.create!(supplier_id: supplier.id, price: price)
  end
  p contract
end


namespace :almarusco do
  desc "Import contract"
  task import_contract: :environment do
    priority = [
      [180102, 2.0],
      [180103, 1.0],
      [180104, 2.0],
      [180106, 2.0],
      [180107, 2.0],
      [180108, 2.0],
      [180109, 2.0],
      [180201, 2.0],
      [180202, 1.0],
      [180203, 2.0],
      [180205, 2.0],
      [180206, 2.0]
    ]

    supplier = Supplier.find(1)
    priority.each do |contract|
      update_contract(supplier, contract[0], contract[1])
    end

    supplier = Supplier.find(4)
    CSV.read("doc/garc.csv", col_sep: "\t").each do |line|
      code = line[0].strip.split("-")[0].strip.gsub(/[^0-9]+/, "")
      price = line[1].to_f
      update_contract(supplier, code, price)
    end
  end
end
