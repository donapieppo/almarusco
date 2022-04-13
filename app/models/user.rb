class User < ApplicationRecord
  include DmUniboCommon::User
  has_many :disposals

  # for who use can operate?
  def permitted_producers(org)
    producer_ids = org.permissions.where(authlevel: Rails.configuration.authlevels[:operate], 
                                         user_id: self.id).map(&:producer_id).uniq
    User.find(producer_ids)
  end

  # Ritorna tutti gli utenti che sono stati in qualche modo associati ad una certa struttura in passato
  # Di solito sono gli utenti che hanno fatto s/carichi o a cui sono stati associati scarichi 
  # Andiamo indietro di un paio di anni (RECENTY in configuration for caching in mysql)
  def self.all_in_cache(organization_id, booking = false)
    User.find_by_sql "SELECT DISTINCT users.id, users.upn, name, surname 
                                   FROM users, disposals 
                                  WHERE organization_id = #{organization_id.to_i} 
                                    AND users.id = producer_id
                               ORDER BY surname"
  end
end
