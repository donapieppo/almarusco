module DisposalHelper
  def qrcode(disposal)
    qr = RQRCode::QRCode.new(disposal_url)
    image_tag qr.as_png(size: 180).to_data_url
  end
end

