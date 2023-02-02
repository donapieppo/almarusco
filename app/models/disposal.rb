# created approved legalized delivered conpleted

class DisposalHistoryError < RuntimeError
  def to_s
    "incorrect order in actions"
  end
end

class Disposal < ApplicationRecord
  belongs_to :organization
  belongs_to :user
  belongs_to :producer, class_name: 'User', optional: true
  belongs_to :disposal_type
  belongs_to :lab
  belongs_to :picking, optional: true 
  belongs_to :legal_upload, foreign_key: 'legal_record_id', optional: true

  validates :volume, presence: true, numericality: { greater_than: 0 }
  validates :units, presence: true, numericality: { greater_than: 0 }
  validates :kgs, numericality: { greater_than_or_equal_to: 0 }
  # validates_with RegistrationNumberValidator

  before_validation :fix_units
  # TODO
  # after_create :update_local_id

  scope :user_or_producer, -> (u_id) { where('user_id = ? or producer_id = ?', u_id, u_id) }
  scope :uncomplete, -> { where(kgs: nil) }
  scope :complete, -> { where.not(kgs: nil) }
  scope :unapproved, -> { where(approved_at: nil) }
  scope :approved, -> { where.not(approved_at: nil) }
  scope :unlegalized, -> { where(legalized_at: nil) }
  scope :legalized, -> { where.not(legalized_at: nil) }
  scope :unassigned, -> { where(picking_id: nil) }
  scope :assigned, -> { where.not(picking_id: nil) }
  scope :undelivered, -> { where(delivered_at: nil) }
  scope :include_all, -> { includes(:user, :producer, :lab, disposal_type: [:cer_code, :un_code, :hp_codes, :adrs]) }

  def to_s
    "#{self.volume_tot} L - #{self.kgs} Kg #{self.disposal_type.to_s_short}"
  end

  def multiple_units_to_s
    self.units > 1 ? 'M' : ''
  end

  def volume_to_s
    "#{self.units} #{volume_type} da #{self.volume}L."
  end

  def volume_tot
    self.volume * self.units
  end

  def liquid?
    self.disposal_type.liquid?
  end

  def solid?
    self.disposal_type.solid?
  end

  # STATUS
  # APPROVE. first action from responsible
  def approved?
    approved_at
  end

  def approve!
    self.kgs.to_f > 0 or return false
    self.approved_at and raise DisposalHistoryError
    self.update(approved_at: Time.now)
  end

  def unapprove!
    self.update(approved_at: nil)
  end

  # LEGALIZE. responsible writes the disposal on legal book
  def legalized?
    legalized_at
  end

  def legalize!(legal_record)
    self.approved? or raise DisposalHistoryError
    self.update(legalized_at: Time.now, legal_record_id: legal_record.id)
  end

  # ASSIGN TO PICKING
  def assigned?
    self.picking_id
  end

  # DELIVER
  def delivered?
    delivered_at
  end

  def undelivered?
    ! delivered?
  end

  def legal_download
    return unless delivered?
    self.picking.picking_document_by_disposal_type(self.disposal_type)
  end

  def deliver!
    self.legalized? or raise DisposalHistoryError
    self.update(delivered_at: Time.now)
  end

  # COMPLETE
  def completed?
    completed_at
  end

  def complete!
    self.delivered? or raise DisposalHistoryError
    self.update(completed_at: Time.now)
  end

  def status
    if self.completed?
      'archiviato'
    elsif self.delivered?
      'consegnato'
    elsif self.picking_id
      'ritiro prenotato'
    elsif self.approved?
      'accettato' 
    else
      'da accettare'
    end
  end

  def producer_upn
    self.producer ? self.producer.upn : ""
  end

  # possiamo passare 'pietro.donatini' 'pietro.donatini@unibo.it' 'Pietro donatini pietro.donatini@unibo.it'
  # FIXME check before use :-) For now see disposals_controller set_producer
  def producer_upn=(upn)
    if upn =~ /(\w+\.\w+)/ 
      _producer = User.find_or_syncronize("#{$1}@unibo.it")
    else
      _producer = User.find_or_syncronize(upn)
    end
    if _producer
      self.producer = _producer
    end
  end

  def fix_units
    self.units = 1 if self.units.to_i < 1
    unless self.disposal_type.separable
      self.units = 1
    end
  end

  def volume_type
    return "" if self.volume.to_i == 0 
    if self.units.to_i == 1
      self.volume.to_i == 200 ? 'fusto' : 'tanica'
    elsif self.units.to_i > 1
      self.volume.to_i == 200 ? 'fusti' : 'taniche'
    else
      ""
    end
  end

  # https://dev.mysql.com/doc/refman/5.6/en/innodb-locking-reads.html
  # FIXME
  # def update_local_id
  #   ActiveRecord::Base.transaction do
  #     ActiveRecord::Base.connection.execute("UPDATE disposals SET local_id = (SELECT next_local_id FROM organizations where id=#{self.organization_id.to_i} FOR UPDATE) WHERE id=#{self.id.to_i}")
  #     ActiveRecord::Base.connection.execute("UPDATE organizations SET next_local_id=(next_local_id + 1) where id=#{self.organization_id.to_i}")
  #   end
  # end

  def local_id_to_s
    # self.local_id
    self.id.to_s
  end
end
