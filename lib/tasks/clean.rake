namespace :almarusco do
  desc "clean old disposals"
  task clean_old_disposals: :environment do
    Disposal.where("disposals.approved_at IS NULL AND disposals.created_at < DATE_SUB(NOW(),INTERVAL 1 YEAR)").destroy_all
  end

  desc "change authorization expire"
  task change_authorization_expires: :environment do
    # DmUniboCommon::Permission.where("expiry < ?", Date.today + 40.days).load
    # update permissions set expiry = "2025-03-01" where expiry < NOW();
  end
end
