class PickingPrint
  include Prawn::View

  def initialize(picking)
    @picking = picking
    header
    content
  end

  def header
    text @picking.supplier.name.upcase, bold: true
    text 'MODULO PRENOTAZIONE SERVIZIO', bold: true
    text "#{@picking.organization.name} #{@picking.organization.description}"
  end

  def content
    text "Hello World!"
    text @picking.supplier.name
  end
end
