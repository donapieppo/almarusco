class NuterController < ApplicationController
  def chart
    authorize :nuter
    @labels = (1..12).map { |month| Date::MONTHNAMES[month] }
    @disposals = (1..12).map { |month| Disposal.where("created_at >= ? and created_at <= ?", "2023/#{month}/01", "2023/#{month}/31").approved.count }
  end
end
