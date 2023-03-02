require 'csv'

CONN = DmUniboUserSearch::Client.new

namespace :almarusco do

  desc "Import CERS"
  task import_cers: :environment do
    File.open('./doc/cer_codes.txt') do |f|
      for line in f.readlines do
        # 160508* - Sostanze chimiche organiche di scarto contenenti o costituite da sostanze pericolose (cisterna anatomia)
        (c, des) = line.strip.split('-')
        if c 
          danger = (c =~ /\*/)
          code = c.strip.gsub(/[^0-9]+/, '')
          dbcer = CerCode.where(name: code).first
          if dbcer && !! dbcer.danger != !! danger
            p line
            p "ERRORE DANGER #{dbcer.inspect}"
          end
          if ! dbcer
            p code.strip
            p danger
            p des.strip
            CerCode.create!(name: code, description: des, danger: danger)
          end
        end
      end
    end
  end

  desc "Import ULS"
  task import_uls: :environment do

    # ["1", " via Guaccimanni 42 (RA)", "34402", "Chiai", "Giaa", nil, "dal 01/01/2019", "-", nil], 
    CSV.read("doc/uls.csv", col_sep: ";").each do |line|
      id = line[0].to_i
      address = line[1]
      user_emplyeid = line[2].to_i
      resp_str = line[6].strip
      dele_str = line[7].strip
      note = line[8]

      next unless id > 0 

      # non più responsabile/delegato
      resp_str = nil if resp_str =~ /dal.+al/ || resp_str == '-'
      dele_str = nil if dele_str =~ /dal.+al/ || dele_str == '-'

      p resp_str
      p dele_str

      resp_date = get_date(resp_str)
      dele_date = get_date(dele_str)

      p resp_date
      p dele_date

      next unless (resp_date || dele_date)

      o = Organization.find_or_create_by(id: id) do |o|
        o.code = "UL#{id}"
        o.name = address
      end

      p o
      p user_emplyeid

      if user = find_or_create_user_by_employee_id(user_emplyeid)
        p user
        p = o.permissions.build(user_id: user.id)
        if resp_date
          p.created_at = resp_date
          p.authlevel = 60
          p.save
        elsif dele_date
          p.created_at = dele_date
          p.authlevel = 40
          p.save
        end
      end
      pippo = STDIN.gets
    end
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
  if str && (m = str.match(DATE_REGEX))
    y = m[:year].to_i
    y = (y + 2000) if y < 1900
    Date.new(y, m[:month].to_i, m[:day].to_i)
  else
    nil
  end
end
