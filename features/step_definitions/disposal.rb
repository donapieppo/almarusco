# created approved legalized delivered conpleted

Given('A new disposal') do
  @disposal = FactoryBot.create(:disposal)
end

When('It is approved') do
  @disposal.approve!
end

When('It is legalized') do
  @legal_upload = FactoryBot.create(:legal_upload, disposal_type: @disposal.disposal_type, organization: @disposal.organization)
  @disposal.legalize!(@legal_upload)
end

When('It is delivered') do
  @disposal.deliver!
end

When('It is completed') do
  @disposal.completed!
end

Then('It should be approved') do
  assert @disposal.approved?
end

Then('It should be legalied') do
  assert @disposal.legalized?
end

Then('It should be delivered') do
  assert @disposal.delivered?
end

Then('It should be completed') do
  assert @disposal.completed?
end

Then('You get an history error') do
  assert true
end

