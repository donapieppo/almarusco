require 'csv'

namespace :almarusco do

  desc "Import ULS"
  task import_uls: :environment do
    #conn = DmUniboUserSearch::Client.new

    # ["1", " via Guaccimanni 42 (RA)", "34402", "Chiapponi", "Gianluca", nil, "dal 01/01/2019", "-", nil], 
    CSV.read("doc/uls.csv", col_sep: ";").each do |line|
      id = line[0].to_i
      address = line[1]
      user_emplyeid = line[2].to_i
      resp = line[6]
      dele = line[7]
      note = line[8]

      next unless id > 0 

      # finito
      resp = '-' if resp =~ /dal\w+al/
      dele = '-' if dele =~ /dal\w+al/

      resp = get_date(resp)
      dele = get_date(dele)

      p resp
      p dele
      next

      o = Organization.find_or_create_by(id: id) do |o|
        o.code = "UL#{id}"
        o.name = address
      end

      conn.find_user(id).users.each do |dsauser|
        if same_employeeid?(dsauser.employee_id, id)
          puts("Creating #{dsauser.inspect}")
          user = User.create!(id: dsauser.id_anagrafica_unica.to_i,
                              upn: dsauser.upn,
                              name: dsauser.name,
                              surname: dsauser.sn,
                              employeeNumber: dsauser.employee_id,
                              email: dsauser.upn.downcase)
        end
      end
    end
  end
end

# matricole uguali quando usuali senza zero iniziali
def self.same_employeeid?(a, b)
  a.to_s.strip.gsub(/^0+/, '') == b.to_s.strip.gsub(/^0+/, '')
end

DATE_REGEX = %r{dal\s+(?<day>\d{1,2})\/(?<month>\d{1,2})\/(?<year>\d{2,4})}

def get_date(str)
  if str && m = str.match(DATE_REGEX)
    y = m[:year].to_i
    y = (y + 2000) if y < 1900
    Date.new(y, m[:month].to_i, m[:day].to_i)
  else
    nil
  end
end
