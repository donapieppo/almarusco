class DisposalType < ApplicationRecord
  belongs_to :organization
  belongs_to :compliance, optional: true
  belongs_to :cer_code
  belongs_to :un_code, optional: true
  has_and_belongs_to_many :hp_codes
  has_and_belongs_to_many :adrs
  has_and_belongs_to_many :pictograms
  has_and_belongs_to_many :containers

  has_many :disposals
  has_many :legal_records
  has_many :picking_documents

  validate :cer_and_hps_and_compliance_uniqueness
  validate :danger_coherence
  validates :physical_state, presence: true
  validates :containers, presence: true

  scope :with_all_includes, -> { includes(:cer_code, :hp_codes, :un_code, :pictograms, :adrs) }
  scope :order_by_cer_and_un, -> { order("cer_codes.name, un_codes.id") }

  def liquid?
    self.physical_state == "liq"
  end

  def solid?
    !liquid?
  end

  def danger?
    self.cer_code_id && self.cer_code.danger?
  end

  def legalizable?
    self.legalizable || self.danger?
  end

  def compliance_to_s
    compliance ? "(om: #{compliance.id_to_s})" : ""
  end

  def to_s
    %{#{self.cer_code} - #{self.un_code ? self.un_code.to_s + " -" : ""} (#{self.physical_state_to_s}) #{compliance_to_s}}
  end

  def to_s_short
    %(#{cer_code} #{un_code ? " - " + un_code.to_s : ""} #{compliance_to_s})
  end

  def to_s_complete
    "#{self} #{self.hp_codes_to_s}"
  end

  def physical_state_to_s
    I18n.t(self.physical_state)
  end

  def hp_codes_to_s
    hp_codes.map(&:code).join(", ")
  end

  def adrs_to_s
    adrs_string = self.adrs.map(&:name).join(", ")
    adrs_string.empty? ? "" : "ADR #{adrs_string}"
  end

  def adr_classes
    hp_codes.map do |hp|
      hp.adr_class(liquid: self.liquid?)
    end.compact
  end

  def adr?
    self.adrs.any?
  end

  def cer_and_hps_and_compliance_uniqueness
    DisposalType.where(
      organization_id: self.organization_id,
      cer_code_id: self.cer_code_id,
      un_code_id: self.un_code_id,
      compliance_id: self.compliance_id
    ).each do |dt|
      if self.id && dt.id == self.id
        next
      end
      if self.physical_state == dt.physical_state && self.hp_code_ids.to_set == dt.hp_code_ids.to_set
        errors.add(:cer_code_id, "Esiste già una tipologia con gli stessi parametri CER/UN/HP/OMOLOGA e lo stesso stato nella tua UL.")
        return false
      end
    end
  end

  def danger_coherence
    if self.danger?
      self.hp_codes.any? or errors.add(:hp_codes, "È necessario selezionare gli HP per un rifiuto pericoloso.")
    else
      self.hp_codes.any? and errors.add(:hp_codes, "Non è possibile associare codici HP a un rifiuto non pericoloso.")
      self.pictograms.any? and errors.add(:pictograms, "Non è possibile associare pittogrammi a un rifiuto non pericoloso.")
    end
  end

  # TODO old
  def available_volumes
    if self.liquid?
      [5, 10, 20]
    else
      [5, 40, 60, 120]
    end
  end
end
