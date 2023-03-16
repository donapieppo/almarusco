# frozen_string_literal: true

class LegalRecord::LastComponent < ViewComponent::Base
  def initialize(organization)
    @year = Date.today.year
    @number = organization.legal_records.where(year: @year).maximum(:number)
  end
end
