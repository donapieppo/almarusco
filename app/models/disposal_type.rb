class DisposalType < ApplicationRecord
  belongs_to :organization
  belongs_to :cer_code
  belongs_to :un_code, optional: true
  has_and_belongs_to_many :hp_codes
  has_and_belongs_to_many :adrs
  has_and_belongs_to_many :pictograms

  has_many :disposals

  # TODO uniqneness with also hps
  # validates :cer_code_id, uniqueness: { scope: [:organization_id, :un_code_id], message: 'La tipoligia è già presente nella ul.', case_sensitive: false }
  validates :physical_state, presence: true

  scope :with_all_includes, -> { includes(:cer_code, :hp_codes, :un_code, :pictograms, :adrs) }

  def liquid?
    self.physical_state == 'liq'
  end

  def solid?
    ! liquid?
  end

  def to_s
    "#{self.cer_code} - #{self.un_code ? self.un_code.to_s + ' - ' : ''} (#{self.physical_state_to_s})" 
  end

  def to_s_short
    "#{self.cer_code} #{self.un_code ? ' - ' + self.un_code.to_s : ''}" 
  end

  def physical_state_to_s
    I18n.t(self.physical_state)
  end

  def hp_codes_to_s
    hp_codes.map(&:code).join(', ')
  end

  def adrs_to_s
    adrs_string = self.adrs.map(&:name).join(', ')
    adrs_string.empty? ? '' : "ADR #{adrs_string}"
  end

  def adr_classes
    hp_codes.map do |hp|
      hp.adr_class(liquid: self.liquid?)
    end.compact
  end
end
