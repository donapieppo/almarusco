class Organization < ApplicationRecord
  include DmUniboCommon::Organization

  has_many :buildings
  has_many :disposal_types
  has_many :disposals
  has_many :labs
  has_many :pickings
  has_many :legal_uploads
  has_many :legal_downloads
  has_many :legal_records
  has_many :compliances
  has_many :disposal_descriptions

  validate :check_mail_parameters

  before_destroy :manual_delete

  def to_s
    "#{self.name} - #{self.description}".upcase
  end

  # Ritorna tutti gli utenti che sono stati in qualche modo associati ad una certa struttura in passato
  # Di solito sono gli utenti che hanno fatto s/carichi o a cui sono stati associati scarichi
  # Andiamo indietro di un paio di anni (RECENTY in configuration for caching in mysql)
  def users_cache
    User.find_by_sql "SELECT DISTINCT users.id, users.upn, name, surname
                                 FROM users, disposals
                                WHERE organization_id = #{self.id.to_i}
                                  AND users.id = producer_id
                                   OR users.id = user_id
                             ORDER BY surname"
  end

  def all_compliances
    Compliance.where("organization_id is null or organization_id = ?", id)
  end

  private

  def check_mail_parameters
    # se abbiamo adminmail lo controlliamo
    self.adminmail.nil? and return true
    self.adminmail.gsub!(/\s+/, "")

    self.adminmail.split(",").each do |mail|
      (mail =~ /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/) and next
      errors.add(:adminmail, "indirizzo mail non corretto")
      throw(:abort)
    end
    true
  end
end
