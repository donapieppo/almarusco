require "application_system_test_case"

class NewDisposalsTest < ApplicationSystemTestCase
  test "visiting new disposal" do
    prepare_users_and_organizations
    visit choose_disposal_type_disposals_url(__org__: @current_organization.code)

    assert_selector "h1", text: "Scegli la tipologia di rifiuto"
  end
end
