class Organization < ApplicationRecord
  include DmUniboCommon::Organization

  has_many :disposal_types
  has_many :disposals

  validates :name, uniqueness: { message: 'Struttura già presente.', case_sensitive: false }

  validate :check_mail_parameters

  before_destroy :manual_delete

  private 

  def check_mail_parameters
    # se abbiamo adminmail lo controlliamo
    self.adminmail.nil? and return true
    self.adminmail.gsub!(/\s+/, '')

    self.adminmail.split(/,/).each do |mail|
      (mail =~ /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/) and next
      errors.add(:adminmail, 'indirizzo mail non corretto')
      throw(:abort) 
    end
    true
  end
end
