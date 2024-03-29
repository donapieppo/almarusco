# approved_at = SUBDATE(CURDATE(),1) = ieri -> inviare alle 10 di ogni giorno
namespace :almarusco do
namespace :expitarions do

  desc "Mostra operatori scaduti"
  task show_expired: :environment do
    DmUniboCommon::Permission.where("expiry < NOW()").each do |p|
      puts p.user
    end
  end

  desc "Eliminazione permessi operatori scaduti"
  task clear_expired: :environment do
    DmUniboCommon::Permission.where("expiry < NOW()").each do |p|
      puts p.user
      p.delete
      sleep 1
    end
  end

  desc "Notifica operatori scaduti"
  task notify_expired: :environment do
    DmUniboCommon::Permission.where("expiry < DATE_ADD(NOW(), INTERVAL 10 DAY)").includes(:organization).each do |permission|
      notification = SystemMailer.with({})
      m = notification.notify_expiration(permission)
      p m
      puts m.body.raw_source
      m.deliver_now
      sleep 25
      raise "ciao"
    end
  end

end
end
