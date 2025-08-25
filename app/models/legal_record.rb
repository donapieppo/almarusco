class LegalRecord < ApplicationRecord
  belongs_to :organization
  belongs_to :disposal_type
  belongs_to :picking_document, optional: true
  # belongs_to :register
  has_many :disposals, foreign_key: "legal_record_id"

  # FIXME
  validate :unique_number_in_organizations_and_year
  validates :date, presence: true
  validates :number, numericality: {greater_than: 0}

  before_validation :set_year

  def to_s
    "#{self.number}/#{self.year}"
  end

  def unique_number_in_organizations_and_year
    if LegalRecord.where.not(id: self.id).where(organization_id: self.organization_id).where(number: self.number).where("YEAR(date) = ?", self.date.year).any?
      self.errors.add(:number, "Non univoco nell'anno #{year}")
      Rails.logger.info("LegalRecord not uniq in #{year} org: #{self.organization_id} number: #{self.number}")
    end
  end

  private

  def set_year
    self.year = self.date.year if self.date
  end
end
