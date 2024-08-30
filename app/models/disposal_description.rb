class DisposalDescription < ApplicationRecord
  has_many :component_details

  def to_s
    name
  end
end
