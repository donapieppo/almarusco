class SystemMailer < ApplicationMailer
  def notify_approved_disposals(user, disposals)
    @user      = user
    @disposals = disposals

    mail(to:      @user.upn, 
         subject: "Oggetto: conferimento rifiuti.")
  end
end
