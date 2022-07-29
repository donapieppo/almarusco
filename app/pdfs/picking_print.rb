class PickingPrint
  include Prawn::View

  def initialize(picking, data)
    @picking = picking
    @document = Prawn::Document.new(page_size: 'A4', page_layout: :landscape, font_size: 8)
    header
    content(data)
  end

  def header
    text "#{@picking.supplier.name.upcase} MODULO PRENOTAZIONE SERVIZIO", style: :bold
    move_down 10
    table [["Unità locale: ", "#{@picking.organization.to_s.upcase} #{@picking.organization.description.to_s.upcase}"],
           ["Ritiro per il giorno: ", "#{I18n.l @picking.date}"],
           ["Contatti responsabili ul: ", "#{@picking.contact.to_s.upcase}"],
           ["Luogo del ritiro: ", "#{@picking.address.to_s.upcase}"]] do
      cells.borders = [] 
      cells.background_color = 'eeeeee'
      column(0).align = :right
    end
    move_down 20
  end

  def extraction(disposal_type, vols_and_kgs)
    volumes = vols_and_kgs[:volumes].keys.map(&:to_i).sort 
    res = []
    res << disposal_type.cer_code.to_s
    res << disposal_type.physical_state_to_s
    res << disposal_type.cer_code.description
    res << volumes.map {|v| v == 200 ? 'Fusto' : 'Tanica'}.sort.uniq.join(' e ')
    res << volumes.map {|v| "da #{v} litri: #{vols_and_kgs[:volumes][v.to_s]}"}.join("\n")
    res << vols_and_kgs[:kgs]
    res << disposal_type.hp_codes_to_s
    res << (disposal_type.adr ? 'si' : '')
    res << disposal_type.un_code.to_s
    res << disposal_type.adrs_to_s
    res
  end

  def content(data)
    font_size 8
    # @volumes_and_kgs.each do |disposal_type, vols_and_kgs|   
    #   lines << extraction(disposal_type, vols_and_kgs)
    # end
    table data do
      row(0).style {|c| c.font_style = :bold; c.background_color = 'eeeeee' }
      column(5).style {|c| c.align = :right }
    end
  end
end
