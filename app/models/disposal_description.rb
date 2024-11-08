class DisposalDescription < ApplicationRecord
  has_many :component_details
  has_and_belongs_to_many :pictograms
  belongs_to :organization
  belongs_to :user

  def to_s
    name
  end
end
