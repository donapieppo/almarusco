# Avery (10 etichette per foglio, codice L7992 - 25)
class PrintsController < ApplicationController
  helper DisposalHelper
  require "prawn"
  require "prawn/measurement_extensions"

  def new
    if policy(current_organization).manage?
      @disposals = current_organization.disposals.undelivered.order(:id)
    else
      @disposals = current_user.disposals.undelivered.where(organization_id: current_organization.id)
    end
    @disposals = @disposals.order(:user_id).order('created_at desc').include_all
    authorize :print
    if @disposals.empty?
      redirect_to root_path, alert: 'Non sono presenti rifiuti da stampare.'
    end
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

    # pdf = Prawn::Document.new(page_size: 'A4', margin: 20) # 595.28 x 841.89
    pdf = Prawn::Document.new(page_size: 'A4', margin_top: 6.mm, margin_bottom: 4.mm, margin_left: 6.mm, margin_right: 8.mm) # 595.28 x 841.89
    # :margin Sets the margin on all sides in points [0.5 inch] :left_margin :right_margin
    pdf.font_size 8
    pdf.define_grid(columns: 2, rows: 5, gutter: 0)
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
          pdf.move_down 8 
          pdf.indent(10) do
            pdf.text " n.#{disposal.id.to_s}      <font size='9'>#{disposal.organization.code} - #{disposal.lab}</font>", size: 12, inline_format: true
          end

          y_position = pdf.cursor - 6 

          qr = RQRCode::QRCode.new(disposal_url(disposal))
          IO.binwrite("/tmp/gr_image_#{disposal.id}.png", qr.as_png(size: 240).to_s)

          pdf.bounding_box([0, y_position], width: 100, height: 100) do
            # pdf.stroke_bounds
            pdf.image "/tmp/gr_image_#{disposal.id}.png", width: 80, height: 80
          end

          pdf.bounding_box([70, y_position], width: 200, height: 120) do
            # pdf.stroke_bounds
            
            pdf.indent(10) do
              if dt.un_code
                pdf.text dt.un_code.to_s, style: 'bold', size: 20
              end
              pdf.text dt.cer_code.to_s, size: 20
              pdf.text dt.hp_codes_to_s + " - " + dt.adrs_to_s, size: 13
              pdf.text dt.physical_state_to_s.upcase, size: 6
            end
          end

          disposal.disposal_type.pictograms.each_with_index do |pict, i|
            if pict.filename =~ /\.png/
              pdf.image open(pict.full_filename), height: 26, at: [80+28*i, 30]
            else
              pdf.svg IO.read(pict.full_filename), height: 26, at: [80+28*i, 30]
            end
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
            IO.binwrite("/tmp/gr_image_#{disposal.id}.png", qr.as_png.to_s)
            rows << { image: "/tmp/gr_image_#{disposal.id}.png", image_width: 80, image_height: 80 }
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
