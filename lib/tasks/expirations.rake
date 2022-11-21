# approved_at = SUBDATE(CURDATE(),1) = ieri -> inviare alle 10 di ogni giorno
namespace :almarusco do
namespace :expitarions do

  desc "Eliminazione permessi operatori scaduti"
  task clear_expired: :environment do
    raise DmUniboCommon::Permission.where("expiry < NOW()").inspect
  end

end
end
