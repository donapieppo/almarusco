module DisposalHelper
  def qrcode(disposal)
    qr = RQRCode::QRCode.new(disposal_url)
    image_tag qr.as_png(size: 180).to_data_url
  end

  def disposal_type_pictograms(disposal_type, size: 100)
    disposal_type.pictograms.each do |pictogram|
      concat image_tag(pictogram.image, size: size) 
    end
  end

  def adr_images(disposal)
    disposal.disposal_type.adr_classes.each do |adrc|
      concat image_tag("labels/adr_#{adrc}.svg", size: 100)
    end
  end
end

