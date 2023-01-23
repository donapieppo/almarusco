class LegalRecord < ApplicationRecord
  belongs_to :organization
  belongs_to :disposal_type

  # FIXME
  validate :unique_number_in_organizations_and_year
  validates :date, :number, presence: true

  after_save :set_year

  def to_s
    "#{self.number}/#{self.year}"
  end

  def unique_number_in_organizations_and_year
    if LegalRecord.where.not(id: self.id).where(organization_id: self.organization_id).where(number: self.number).where('YEAR(date) = ?', self.date.year).any?
      self.errors.add(:number, "non univoco in nell'anno #{year}")
      Rails.logger.info("LegalRecord not uniq in #{year} org: #{self.organization_id} number: #{self.number}")
    end
  end

  private

  def set_year
    self.year = self.date.year
  end
end
