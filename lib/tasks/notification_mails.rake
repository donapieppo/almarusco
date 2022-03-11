namespace :almarusco do
namespace :notifications do

  desc "invio notifiche carichi di ieri"
  task day: :environment do
    # notifications = Notification.new(Organization.where(sendmail: 'd').all)
    # notifications.from    = Date.yesterday 
    # notifications.to      = Date.yesterday 
    # notifications.subject = "Riassunto scarico materiale di consumo."
    # notifications.send
  end

end
end
