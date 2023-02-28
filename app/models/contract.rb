class Contract < ApplicationRecord
  belongs_to :supplier
  belongs_to :cer_code
end
