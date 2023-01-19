class LegalDownloadPolicy < LegalRecordPolicy
  def create?
    @record && @user && PickingDocumentPolicy.new(@user, @record.picking_document).edit?
  end

  def update?
    @record && @user && PickingDocumentPolicy.new(@user, @record.picking_document).edit?
  end
end
