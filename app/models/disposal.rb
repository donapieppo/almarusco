class Disposal < ApplicationRecord
  belongs_to :organization
  belongs_to :user
  belongs_to :producer, class_name: 'User', optional: true
  belongs_to :disposal_type
  belongs_to :lab
  belongs_to :picking, optional: true 

  validates :volume, presence: true, numericality: { greater_than: 0 }
  validates :kgs, numericality: { greater_than: 0 }, allow_blank: true

  scope :user_or_producer, -> (u_id) { where('user_id = ? or producer_id = ?', u_id, u_id) }
  scope :approved, -> { where.not(approved_at: nil) }
  scope :delivered, -> { where.not(delivered_at: nil) }
  scope :undelivered, -> { where(delivered_at: nil) }
  scope :include_all, -> { includes(:user, :producer, :lab, disposal_type: [:cer_code, :un_code, :hp_codes, :adrs]) }

  def to_s
    "#{self.volume} L - #{self.kgs} Kg #{self.disposal_type.to_s_short}"
  end

  def liquid?
    self.disposal_type.liquid?
  end

  def solid?
    self.disposal_type.solid?
  end

  def self.available_volumes
    { liquid: [5, 10, 20], solid: [5, 40, 60, 120] }
  end

  def approved?
    approved_at
  end

  def approve!
    self.update(approved_at: Time.now)
  end

  def unapprove!
    self.update(approved_at: nil)
  end

  def status
    approved_at ? 'accettato' : 'da accettare'
  end

  def delivered?
    delivered_at
  end

  def undelivered?
    ! delivered?
  end

  def producer_upn
    self.producer ? self.producer.upn : ""
  end

  # possiamo passare 'pietro.donatini' 'pietro.donatini@unibo.it' 'Pietro donatini pietro.donatini@unibo.it'
  def producer_upn=(upn)
    if upn =~ /(\w+\.\w+)/ 
      @_user_upn = "#{$1}@unibo.it"
    else
      @_user_upn = upn
    end
  end
end
