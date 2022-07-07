class SystemMailer < ApplicationMailer
  def notify_approved_disposals(user, disposals)
    @user      = user
    @disposals = disposals

    mail(to:      @user.upn, 
         bcc:     'pietro.donatini@unibo.it', 
         subject: "Conferimento rifiuti.")
  end
end
