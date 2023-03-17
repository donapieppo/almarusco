class PickingPrint
  include Prawn::View

  def initialize(picking, data)
    @picking = picking
    @document = Prawn::Document.new(page_size: "A4", page_layout: :landscape, font_size: 8)
    font_size 8
    header
    other_requests(data)
    content(data)
  end

  def header
    text "#{@picking.supplier.name.upcase} MODULO PRENOTAZIONE SERVIZIO", style: :bold, size: 10
    move_down 10
    text "ALMA MATER STUDIORUM UNIVERSITÀ DI BOLOGNA Codice fiscale 8007010376", style: :bold, size: 10
    move_down 10
    table [
      ["Unità locale: ", "#{@picking.organization.to_s.upcase} #{@picking.organization.description.to_s.upcase}"],
      ["Ritiro per il giorno: ", @picking.date.to_s],
      ["Contatti responsabili ul: ", @picking.contact.to_s],
      ["Luogo del ritiro: ", @picking.address.to_s]
    ] do
      cells.borders = []
      cells.background_color = "FFCA2C"
      column(0).align = :right
    end
    move_down 20
  end

  def other_requests(data)
    text "Imballaggi da consegnare:", style: :bold
    move_down 5
    Picking.other_requests.each do |req|
      if data[req[0].to_sym] && data[req[0].to_sym].to_i > 0
        text "  - #{req[1]}: #{data[req[0].to_sym]}"
      end
    end
    move_down 10
  end

  def volumes_table(volumes)
    volumes.keys.select { |v| volumes[v.to_s] != "0" }.map { |v| "#{volumes[v.to_s]} da #{v} litri" }.join("\n")
  end

  def data_array(data)
    res = [["CER", "Stato fisico", "Descrizione rifiuto", "Tipo di imbal.ggio", "N° e tipo di colli", "Peso (Kg)", "Classi di pericolo", {content: "ADR", width: 30}, "Classe ADR", {content: "ONU", width: 40}]]

    data[:dt].each do |dt_id, values|
      disposal_type = DisposalType.find(dt_id.to_i)
      next if values["kgs"] == "0"

      line = []
      line << disposal_type.cer_code.to_s
      line << disposal_type.physical_state_to_s
      line << disposal_type.cer_code.description
      line << values["volumes"].keys.map { |v| (v == 200) ? "Fusto" : "Tanica" }.sort.uniq.join(" e ")
      line << volumes_table(values["volumes"])
      line << values["kgs"]
      line << disposal_type.hp_codes_to_s
      line << (disposal_type.adr? ? "si" : "")
      line << disposal_type.adrs.map(&:name).join(", ")
      line << disposal_type.un_code.to_s
      res << line
    end
    res
  end

  def content(data)
    table data_array(data) do
      row(0).style { |c|
        c.font_style = :bold
        c.background_color = "eeeeee"
      }
      column(4).style { |c| c.align = :right }
      column(5).style { |c| c.align = :right }
    end
  end
end
