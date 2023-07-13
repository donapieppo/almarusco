require "test_helper"
require "integrations_helper"

class PippoTest < ActionDispatch::IntegrationTest
  include IntegrationHelpers

  test "visiting the index as manager is ok" do
    sign_in_as(:manager)
    disposal_type = FactoryBot.create(:disposal_type, organization: @current_organization)
    get edit_disposal_type_url(id: disposal_type.id, __org__: @current_organization.code)

    assert_select "h1", text: "Modifica tipologia di rifiuti"
  end

  test "visiting disposal_types index as manager in other organization redirects to no_access" do
    sign_in_as(:manager)
    disposal_type = FactoryBot.create(:disposal_type, organization: @other_organization)
    get edit_disposal_type_url(id: disposal_type.id, __org__: @other_organization.code)

    assert_redirected_to dm_unibo_common.no_access_path
  end

  test "visiting disposal_types the index as operator raises Pundit::NotAuthorizedError" do
    sign_in_as(:operator)
    disposal_type = FactoryBot.create(:disposal_type, organization: @current_organization)
    assert_raise(Pundit::NotAuthorizedError) { get edit_disposal_type_url(id: disposal_type.id, __org__: @current_organization.code) }
  end

  def manager_creates_disposal_type
    sign_in_as(:manager)
    get new_disposal_type_url
    click_on :disposal_type_physical_state_snp
    click_om :disposal_type_cer_code_id_36
  end

  test "pippo" do
    manager_creates_disposal_type
  end
end
