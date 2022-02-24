class User < ApplicationRecord
  include DmUniboCommon::User
  has_many :disposals

  # for who use can operate?
  def available_producers(org)
    producer_ids = org.permissions.where(authlevel: Rails.configuration.authlevels[:operate], 
                                         user_id: self.id).map(&:producer_id).uniq
    User.find(producer_ids)
  end
end
