class User < ApplicationRecord
  include DmUniboCommon::User

  has_many :disposals

  # Ritorna tutti gli utenti che sono stati in qualche modo associati ad una certa struttura in passato
  # Di solito sono gli utenti che hanno fatto s/carichi o a cui sono stati associati scarichi 
  # Andiamo indietro di un paio di anni (RECENTY in configuration for caching in mysql)
  def self.all_in_cache(organization_id, booking = false)
    if booking 
      User.find_by_sql "SELECT DISTINCT users.id, users.upn, name, surname 
                                   FROM users, operations 
                                  WHERE organization_id = #{organization_id.to_i} 
                                        AND operations.from_booking IS NOT NULL
                                        AND users.id  = user_id
                                    AND operations.date > #{RECENTLY}
                               ORDER BY surname"
    else
      User.find_by_sql "SELECT DISTINCT users.id, users.upn, name, surname
                                   FROM users 
                                   WHERE id IN (SELECT recipient_id FROM operations WHERE organization_id = #{organization_id.to_i}
                                                UNION DISTINCT SELECT user_id FROM operations WHERE organization_id = #{organization_id.to_i})
                                   ORDER BY surname"
    end
  
    #and_user    = booking ? 'AND users.id  = user_id' : 'AND ( users.id = recipient_id OR users.id  = user_id )' 
    #User.find_by_sql "SELECT DISTINCT users.id, users.upn, name, surname 
    #                             FROM users, operations 
    #                            WHERE organization_id = #{organization_id.to_i} 
    #                                  #{and_booking} 
    #                                  #{and_user}
    #                              AND operations.date > DATE_SUB(NOW(), INTERVAL 1 YEAR)
    #                         ORDER BY surname"
  end

  def self.recipient_cache(organization_id, interval = 365)
    User.find_by_sql "SELECT DISTINCT users.id, users.upn, name, surname 
                                 FROM users, operations 
                                WHERE organization_id = #{organization_id.to_i} 
                                  AND operations.recipient_id IS NOT NULL
                                  AND users.id = recipient_id
                                  AND operations.date > DATE_SUB(CURDATE(), INTERVAL #{interval} DAY)
                             ORDER BY surname"
  end
end
