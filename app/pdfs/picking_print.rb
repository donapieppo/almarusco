class PickingPrint
  include Prawn::View

  def initialize(picking, data)
    @picking = picking
    @document = Prawn::Document.new(page_size: 'A4', page_layout: :landscape, font_size: 8)
    font_size 8
    header
    content(data)
  end

  def header
    text "#{@picking.supplier.name.upcase} MODULO PRENOTAZIONE SERVIZIO", style: :bold, size: 10
    move_down 10
    table [["Unità locale: ", "#{@picking.organization.to_s.upcase} #{@picking.organization.description.to_s.upcase}"],
           ["Ritiro per il giorno: ", "#{I18n.l @picking.date}"],
           ["Contatti responsabili ul: ", "#{@picking.contact}"],
           ["Luogo del ritiro: ", "#{@picking.address}"]] do
      cells.borders = [] 
      cells.background_color = 'FFCA2C'
      column(0).align = :right
    end
    move_down 20
  end

  def volumes_table(volumes)
    volumes.keys.select {|v| volumes[v.to_s] != "0" }.map {|v| "#{volumes[v.to_s]} da #{v} litri"}.join("\n")
  end

  def data_array(data)
    res = [["CER", "Stato fisico", "Descrizione rifiuto", "Tipo di imbal.ggio", "N° e tipo di colli", "Peso (Kg)", "Caratteristiche di pericolo", "ADR", "N. ONU", "Classe ADR"]] 

    data[:dt].each do |dt_id, values|
      disposal_type = DisposalType.find(dt_id.to_i)
      next if values["kgs"] == "0"

      line = []
      line << disposal_type.cer_code.to_s
      line << disposal_type.physical_state_to_s
      line << disposal_type.cer_code.description
      line << values["volumes"].keys.map {|v| v == 200 ? 'Fusto' : 'Tanica'}.sort.uniq.join(' e ')
      line << volumes_table(values["volumes"])
      line << values["kgs"]
      line << disposal_type.hp_codes_to_s
      line << (disposal_type.adr ? 'si' : '')
      line << disposal_type.un_code.to_s
      line << disposal_type.adrs_to_s
      res << line
    end
    res
  end

  def content(data)
    table data_array(data) do
      row(0).style {|c| c.font_style = :bold; c.background_color = 'eeeeee' }
      column(4).style {|c| c.align = :right }
      column(5).style {|c| c.align = :right }
    end
  end
end
