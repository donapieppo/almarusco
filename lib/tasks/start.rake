require 'csv'

CONN = DmUniboUserSearch::Client.new

namespace :almarusco do

  desc "Import ULS"
  task import_uls: :environment do

    # ["1", " via Guaccimanni 42 (RA)", "34402", "Chiai", "Giaa", nil, "dal 01/01/2019", "-", nil], 
    CSV.read("doc/uls.csv", col_sep: ";").each do |line|
      id = line[0].to_i
      address = line[1]
      user_emplyeid = line[2].to_i
      resp = line[6]
      dele = line[7]
      note = line[8]

      next unless id > 0 

      # non più responsabile/delegato
      resp = '-' if resp =~ /dal\w+al/
      dele = '-' if dele =~ /dal\w+al/

      resp = get_date(resp)
      dele = get_date(dele)

      o = Organization.find_or_create_by(id: id) do |o|
        o.code = "UL#{id}"
        o.name = address
      end

      p o
      p user_emplyeid

      if user = find_or_create_user_by_employee_id(user_emplyeid)
        p user
        p = o.permissions.build(user_id: user.id)
        if resp
          p.created_at = resp
          p.authlevel = 60
          p.save
        elsif dele
          p.created_at = dele
          p.authlevel = 40
          p.save
        end
      end
    end
    exit
  end
end

# matricole uguali quando usuali senza zero iniziali
def self.same_employeeid?(a, b)
  a.to_s.strip.gsub(/^0+/, '') == b.to_s.strip.gsub(/^0+/, '')
end

DATE_REGEX = %r{dal\s+(?<day>\d{1,2})\/(?<month>\d{1,2})\/(?<year>\d{2,4})}

def find_or_create_user_by_employee_id(user_emplyeid)
  if user = User.find_by(employee_id: user_emplyeid)
    return user
  else
    CONN.find_user(user_emplyeid).users.each do |dsauser|
      if same_employeeid?(dsauser.employee_id, user_emplyeid)
        puts("Creating #{dsauser.inspect}")
        return User.create!(id: dsauser.id_anagrafica_unica.to_i,
                            upn: dsauser.upn,
                            name: dsauser.name,
                            surname: dsauser.sn,
                            employee_id: dsauser.employee_id,
                            email: dsauser.upn.downcase)
      end
    end
    return nil
  end
end

def get_date(str)
  if str && m = str.match(DATE_REGEX)
    y = m[:year].to_i
    y = (y + 2000) if y < 1900
    Date.new(y, m[:month].to_i, m[:day].to_i)
  else
    nil
  end
end
