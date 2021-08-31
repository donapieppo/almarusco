class PrintsController < ApplicationController
  helper DisposalHelper
  require "prawn"

  def new
    if policy(current_organization).manage?
      @disposals = current_organization.disposals
    else
      @disposals = current_user.disposals.where(organization: current_organization)
    end
    @disposals = @disposals.order(:user_id).order('created_at desc')
    authorize :print
  end

  # "paper_boxes"=>["1-1", "2-2"]
  def create
    authorize :print

    if policy(current_organization).manage?
      @disposals = current_organization.disposals.where(id: params[:disposal_ids]).to_a
    else
      @disposals = current_user.disposals.where(organization: current_organization).where(id: params[:disposal_ids]).to_a
    end

    pdf = Prawn::Document.new(page_size: 'A4') # 595.28 x 841.89
                                               # :margin Sets the margin on all sides in points [0.5 inch]
                                               # :left_margin :right_margin
    pdf.font_size 8
    pdf.define_grid(columns: 3, rows: 3, gutter: 10)

    params['paper_boxes'].each do |rc|
      row, col = rc.split('-')
      disposal = @disposals.pop
      dt = disposal.disposal_type
      pdf.grid(col.to_i - 1, row.to_i - 1).bounding_box do
        qr = RQRCode::QRCode.new(disposal_url(disposal))
        IO.binwrite("/tmp/pippo#{disposal.id}.png", qr.as_png.to_s)
        pdf.text disposal.id.to_s, size: 16
        pdf.text dt.un_code.to_s, style: 'bold'
        pdf.text dt.cer_code.to_s
        pdf.text dt.adr ? 'ADR' : ''
        pdf.text dt.hp_codes.map(&:code).join(', ')
        pdf.text dt.physical_state_to_s
        pdf.text dt.notes
        pdf.image "/tmp/pippo#{disposal.id}.png", width: 100, height: 100
      end
    end
    send_data pdf.render, filename: "print.pdf", type: :pdf

    return

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
  end
end

