class User < ApplicationRecord
  include DmUniboCommon::User
  has_many :disposals
  has_many :disposal_descriptions

  # for who use can operate?
  def permitted_producers(org)
    producer_ids = org.permissions
      .where(authlevel: Rails.configuration.authlevels[:operate], user_id: self.id)
      .map(&:producer_id)
      .uniq
    if producer_ids.any?
      User.find(producer_ids)
    else
      []
    end
  end

  def nuter?
    NUTER.include?(self.upn)
  end

  # refactor
  def can_manage?
    nuter? and return true
    super
  end
end
