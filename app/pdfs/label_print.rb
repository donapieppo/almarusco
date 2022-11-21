class LabelPrint
  include Rails.application.routes.url_helpers

  def initialize(disposals)
    @disposals = disposals.to_a
    # :margin Sets the margin on all sides in points [0.5 inch] :left_margin :right_margin
    @pdf = Prawn::Document.new(page_size: 'A4', margin_top: 6.mm, margin_bottom: 4.mm, margin_left: 6.mm, margin_right: 8.mm) # 595.28 x 841.89
    @pdf.font_size 8
  end

  def content
    @pdf.define_grid(columns: 2, rows: 5, gutter: 0)
    # pdf.grid.show_all

    # 96 x 51mm rettangolari
    # ["1-1", "2-2", "1-5"]
    [1,2].each do |row|
      [1,2,3,4,5].each do |col|
        if disposal = @disposals.pop
          # :rows, :columns, :gutter, :row_gutter, :column_gutter 
          @pdf.grid(col.to_i - 1, row.to_i - 1).bounding_box do
            single_label(disposal)
          end
        end
      end
    end
    @pdf
  end

  def single_label(disposal)
    dt = disposal.disposal_type
    # pdf.stroke_bounds
    @pdf.move_down 8 
    @pdf.indent(10) do
      @pdf.text " n.#{disposal.id.to_s}      <font size='9'>#{disposal.organization.code} - #{disposal.lab}</font>", size: 12, inline_format: true
    end

    y_position = @pdf.cursor - 6 

    qr = RQRCode::QRCode.new(disposal_url(disposal.id, __org__: 1))
    IO.binwrite("/tmp/gr_image_#{disposal.id}.png", qr.as_png(size: 240).to_s)

    @pdf.bounding_box([0, y_position], width: 100, height: 100) do
      # @pdf.stroke_bounds
      @pdf.image "/tmp/gr_image_#{disposal.id}.png", width: 80, height: 80
    end

    @pdf.bounding_box([70, y_position], width: 200, height: 120) do
      # @pdf.stroke_bounds

      @pdf.indent(10) do
        if dt.un_code
          @pdf.text dt.un_code.to_s, style: 'bold', size: 20
        end
        @pdf.text dt.cer_code.to_s, size: 20
        @pdf.text dt.hp_codes_to_s + " - " + dt.adrs_to_s, size: 13
        @pdf.text dt.physical_state_to_s.upcase, size: 6
        @pdf.text disposal.volume_to_s, size: 6
      end
    end

    disposal.disposal_type.pictograms.each_with_index do |pict, i|
      if pict.filename =~ /\.png/
        @pdf.image open(pict.full_filename), height: 26, at: [80+28*i, 30]
      else
        @pdf.svg IO.read(pict.full_filename), height: 26, at: [80+28*i, 30]
      end
    end
  end
end
