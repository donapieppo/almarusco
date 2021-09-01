module DisposalHelper
  def qrcode(disposal)
    qr = RQRCode::QRCode.new(disposal_url)
    image_tag qr.as_png(size: 180).to_data_url
  end

  def adr_images(disposal)
    disposal.adr_classes.each do |adrc|
      concat image_pack_tag("labels/adr_#{adrc}.svg", size: 100)
    end
  end
end

