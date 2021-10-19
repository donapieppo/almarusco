class DisposalType < ApplicationRecord
  belongs_to :organization
  belongs_to :cer_code
  belongs_to :un_code, optional: true
  has_and_belongs_to_many :hp_codes

  has_many :disposals

  validates :physical_state, presence: true

  def liquid?
    self.physical_state == 'liq'
  end

  def solid?
    ! liquid?
  end

  def to_s
    "#{self.un_code ? self.un_code.to_s + ' - ' : ''}#{self.cer_code} #{self.adr ? ' - ADR' : ''} (#{self.physical_state_to_s})" 
  end

  def to_s_short
    "#{self.un_code ? self.un_code.to_s + ' - ' : ''}#{self.cer_code}" 
  end

  def physical_state_to_s
    I18n.t(self.physical_state)
  end

  def hp_codes_to_s
    hp_codes.map(&:code).join(', ')
  end
end
