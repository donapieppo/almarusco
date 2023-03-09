class Contract < ApplicationRecord
  belongs_to :supplier
  belongs_to :cer_code

  def price_to_s
    ("%.2f &euro;" % price).html_safe
  end
end
