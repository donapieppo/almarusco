class PrintsController < ApplicationController
  helper DisposalHelper
  require "prawn"

  def new
    if policy(current_organization).manage?
      @disposals = current_organization.disposals.undelivered.order(:id)
    else
      @disposals = current_user.disposals.undelivered.where(organization_id: current_organization.id)
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

    unless params['paper_boxes']
      redirect_to new_print_path, alert: "Selezionare le etichette sul foglio"
      return
    end

    pdf = Prawn::Document.new(page_size: 'A4') # 595.28 x 841.89
    # :margin Sets the margin on all sides in points [0.5 inch]
    # :left_margin :right_margin
    pdf.font_size 8
    pdf.define_grid(columns: 2, rows: 5, gutter: 15)
    # pdf.grid.show_all

    # 96 x 51mm rettangolari
    # ["1-1", "2-2", "1-5"]
    params['paper_boxes'].each do |rc|
      row, col = rc.split('-')
      if disposal = @disposals.pop
        dt = disposal.disposal_type
        # :rows, :columns, :gutter, :row_gutter, :column_gutter 
        pdf.grid(col.to_i - 1, row.to_i - 1).bounding_box do
          # pdf.stroke_bounds
          qr = RQRCode::QRCode.new(disposal_url(disposal))
          IO.binwrite("/tmp/pippo#{disposal.id}.png", qr.as_png(size: 240).to_s)
          pdf.text "<font size='9'>#{disposal.organization.code} - #{disposal.lab}</font>    n. #{disposal.id.to_s}", align: :right, size: 14, inline_format: true
          if dt.un_code
            pdf.text dt.un_code.to_s, style: 'bold', size: 12
          end
          pdf.text dt.cer_code.to_s + " " + dt.physical_state_to_s, size: 12
          pdf.text dt.hp_codes_to_s + " - " + dt.adrs_to_s 
          pdf.text dt.notes, size: 6
          pdf.image "/tmp/pippo#{disposal.id}.png", width: 80, height: 80
          disposal.disposal_type.adr_classes.each_with_index do |adrc, i|
            pdf.svg IO.read(Rails.root.join('app', 'javascript', 'images', 'labels', "adr_#{adrc}.svg")), height: 30, at: [80+38*i, 40]
          end
        end
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
