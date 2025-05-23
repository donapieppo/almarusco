# approved_at = SUBDATE(CURDATE(),1) = ieri -> inviare alle 10 di ogni giorno
namespace :almarusco do
namespace :notifications do
  desc "invio notifiche carichi di ieri"
  task day: :environment do
    disposals_hash = Hash.new { |hash, key| hash[key] = [] }

    Disposal.includes(:producer).where("approved_at = SUBDATE(CURDATE(), 1)").order(:organization_id).each do |d|
      disposals_hash[d.producer] << d
    end

    disposals_hash.each do |user, disposals|
      notification = SystemMailer.with({})
      m = notification.notify_approved_disposals(user, disposals)
      p m
      puts m.body.raw_source
      m.deliver_now
      sleep 25
    end
  end
end
end
