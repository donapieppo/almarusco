class User < ApplicationRecord
  include DmUniboCommon::User
  has_many :disposals

  def available_producers(org)
    producer_ids = org.permissions.where(authlevel: Rails.configuration.authlevels[:operate], 
                                         user_id: self.id).map(&:producer_id)
    User.find(producer_ids)
  end
end
