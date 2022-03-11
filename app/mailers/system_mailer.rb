class SystemMailer < ApplicationMailer
  def notify_approved_disposals(user, organization, data_inizio, data_fine, subject, elenco)
    @user         = user
    @organization = organization
    @data_inizio  = data_inizio.strftime("%d/%m/%Y")
    @data_fine    = data_fine.strftime("%d/%m/%Y")
    @elenco       = elenco  

    mail(to:      @user.upn, 
         subject: subject)
  end
end
