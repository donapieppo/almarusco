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
    # pdf = Prawn::Document.new(page_size: 'A4', margin_top: 1.mm, margin_bottom: 1.mm, margin_left: 6.mm, margin_right: 8.mm) # 595.28 x 841.89
    pdf = Prawn::Document.new(page_size: 'A4', margin: 6.mm) # 595.28 x 841.89
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
        qr = RQRCode::QRCode.new(disposal_url(disposal))
        IO.binwrite("/tmp/gr_image_#{disposal.id}.png", qr.as_png(size: 240).to_s)

        # :rows, :columns, :gutter, :row_gutter, :column_gutter 
        pdf.grid(col.to_i - 1, row.to_i - 1).bounding_box do

          # pdf.stroke_bounds
          pdf.move_down 10
          pdf.indent(10) do
            pdf.text " n.#{disposal.id.to_s}    <font size='9'>#{disposal.organization.code} - #{disposal.lab}</font>", size: 14, inline_format: true
          end

          y_position = pdf.cursor - 4

          pdf.bounding_box([5, y_position], width: 90, height: 90) do
            # pdf.stroke_bounds
            pdf.image "/tmp/gr_image_#{disposal.id}.png", width: 90, height: 90
          end

          pdf.bounding_box([100, y_position], width: 170, height: 130) do
            # pdf.stroke_bounds
            
            if dt.un_code
              pdf.text dt.un_code.to_s, style: 'bold', size: 16
            end
            pdf.text dt.cer_code.to_s, size: 16
            pdf.text dt.hp_codes_to_s + " - " + dt.adrs_to_s, size: 10
            pdf.text dt.physical_state_to_s.upcase, size: 8
            pdf.text disposal.volume_to_s, size: 8
          end

          disposal.disposal_type.pictograms.each_with_index do |pict, i|
            if pict.filename =~ /\.png/
              pdf.image open(pict.full_filename), height: 24, at: [10+26*i, 35]
            else
              pdf.svg IO.read(pict.full_filename), height: 24, at: [10+26*i, 35]
            end
          end

        end
      end
    end
    send_data pdf.render, filename: "etichette.pdf", type: :pdf
  end
end
