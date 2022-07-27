class PickingPrint
  include Prawn::View

  def initialize(picking, volumes_and_kgs)
    @picking = picking
    @volumes_and_kgs = volumes_and_kgs
    @document = Prawn::Document.new(page_size: 'A4', page_layout: :landscape, font_size: 8)
    header
    content
  end

  def header
    text @picking.supplier.name.upcase, style: :bold
    text 'MODULO PRENOTAZIONE SERVIZIO', style: :bold
    move_down 10
    text "UNITA’ LOCALE: #{@picking.organization.name} #{@picking.organization.description}"
    text "CONTATTI RESPONSABILI UL: ........."
    move_down 10
    text "RITIRO PER IL GIORNO: #{I18n.l @picking.date}"
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

  def content
    font_size 8
    lines = [["CER", "Stato fisico", "Descrizione rifiuto", "Tipo di imbal.ggio", "N° e tipo di colli", "Peso (Kg)", "Caratteristiche di pericolo", "ADR", "N. ONU", "Classe ADR"]]
    @volumes_and_kgs.each do |disposal_type, vols_and_kgs|   
      lines << extraction(disposal_type, vols_and_kgs)
    end
    table lines do
      row(0).style {|c| c.font_style = :bold; c.background_color = 'eeeeee' }
      column(5).style {|c| c.align = :right }
    end
  end
end
