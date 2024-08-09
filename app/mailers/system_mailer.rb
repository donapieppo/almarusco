class SystemMailer < ApplicationMailer
  def notify_expiration(permission)
    @user = permission.user
    @organization = permission.organization
    @expiration_date = permission.expiry
    @producer = User.find(permission.producer_id)

    mail(
      to: @user.upn,
      bcc: "pietro.donatini@unibo.it",
      subject: "Avviso scadenza accesso applicativo AlmaRusco."
    )
  end

  def notify_approved_disposals(user, disposals)
    @user = user
    @disposals = disposals

    mail(
      to: @user.upn,
      bcc: "pietro.donatini@unibo.it",
      subject: "Conferimento rifiuti."
    )
  end
end
