# frozen_string_literal: true

class Disposal::GroupDetailsComponent < ViewComponent::Base
  def initialize(disposals)
    @volume_data = Hash.new {|h, k| h[k] = { units: 0, kgs: 0.0 }} 

    disposals.each do |disposal|
      @volume_data[disposal.volume][:units] += disposal.units 
      @volume_data[disposal.volume][:kgs] += disposal.kgs.to_f
    end
  end
end

