class ReportsController < ApplicationController
  def index
    authorize :report
    @supplier = Supplier.find(4)
  end
end
