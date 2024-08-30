namespace :almarusco do
  desc "initializa containers"
  task initialize_containers: :environment do
    # select distinct volume from disposals left join disposal_types on disposal_type_id = disposal_types.id where physical_state = 'liq';
    liquid_container_ids = [1, 2, 3] # tanica 5, 10, 20
    # select distinct volume from disposals left join disposal_types on disposal_type_id = disposal_types.id where physical_state != 'liq';
    solid_container_ids = [6, 7] # fusto 40, 60

    DisposalType.find_each do |dt|
      next if dt.containers.any?
      dt.container_ids = if dt.liquid?
        liquid_container_ids
      else
        solid_container_ids
      end
      dt.save
    end
  end

  desc "Correct no danger no record"
  task no_danger_correction: :environment do
    Disposal.approved.not_danger.unlegalized.each do |disposal|
      p disposal
      disposal.update(legalized_at: disposal.approved_at)
      p disposal
    end
  end

  desc "Correct cers"
  task fix_cers_uniqueness: :environment do
    # p c_ok = CerCode.find(26)
    # p c_no = CerCode.find(10)
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

  desc "Check dangers"
  task check_dangers: :environment do
    DisposalType.includes(:cer_code, :un_code, :adrs).find_each do |dt|
      if dt.cer_code.danger?
        if dt.hp_codes.empty?
          puts "NO ADRS in #{dt}"
        end
      else
        if dt.adrs.any?
          puts "ADRS in #{dt}"
        end
      end
    end
  end

  desc "Correct buildings"
  task fix_buildings_start: :environment do
    Organization.find_each do |organization|
      if organization.buildings.empty?
        b = organization.buildings.new(name: organization.code, address: organization.name)
        b.save!
      else
        b = organization.buildings.first
      end

      organization.labs.each do |lab|
        lab.update(building_id: b.id)
      end
    end
  end

  desc "Correct users"
  task fix_users_missing_name: :environment do
    dsa = DmUniboUserSearch::Client.new
    User.where(name: nil).each do |u|
      res = dsa.find_user(u.upn).users[0]
      u.update(name: res.name, surname: res.sn)
      p u
      x = gets
    end
  end
end
