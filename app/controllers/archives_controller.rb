class ArchivesController < ApplicationController
  def index
    authorize :archive
  end
end
