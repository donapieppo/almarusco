namespace :almarusco do
namespace :notifications do

  desc "invio notifiche carichi di ieri"
  task day: :environment do
    disposals_hash = Hash.new { |hash, key| hash[key] = [] }

    Disposal.includes(:producer).where('approved_at = SUBDATE(CURDATE(),1)').each do |d|
      disposals_hash[d.producer] << d
    end

    disposals_hash.each do |user, disposals|
      notification = SystemMailer.with({})
      raise notification.notify_approved_disposals(user, disposals).inspect
    end
  end

end
end
