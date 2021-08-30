class PrintsController < ApplicationController
  helper DisposalHelper
  require "prawn"

  def new
    if policy(current_organization).manage?
      @disposals = current_organization.disposals
    else
      @disposals = current_user.disposals.where(organization: current_organization)
    end
    @disposals = @disposals.order(:user_id, :created_at)
    authorize :print
  end

  # "paper_boxes"=>["1-1", "2-2"]
  def create
    if policy(current_organization).manage?
      @disposals = current_organization.disposals.where(id: params[:disposal_ids]).to_a
    else
      @disposals = current_user.disposals.where(organization: current_organization).where(id: params[:disposal_ids]).to_a
    end

    pdf = Prawn::Document.new
    cells = []
    [1,2,3].each do |row|
      rows = []
      [1,2,3].each do |col| 
        if params['paper_boxes'].include?("#{row}-#{col}")
          if disposal = @disposals.pop
            rows << disposal_cell_content(disposal)
            qr = RQRCode::QRCode.new(disposal_url(disposal))
            IO.binwrite("/tmp/pippo#{disposal.id}.png", qr.as_png.to_s)
            rows << { image: "/tmp/pippo#{disposal.id}.png", image_width: 80, image_height: 80 }
          else
            rows << "--"
            rows << "--"
          end
        else
          rows << "---"
          rows << "---"
        end
      end
      cells << rows
    end
    pdf.table(cells, cell_style: { width: 90, height: 180, border_width: 1, size: 8 })

    send_data pdf.render, filename: "print.pdf", type: :pdf

    authorize :print
  end

  private

  def disposal_cell_content(disposal)
    dt = disposal.disposal_type
    res = "#{dt.un_code} - #{dt.cer_code} #{dt.adr ? ' - ADR' : ''} (#{dt.physical_state})" 
  end
end

