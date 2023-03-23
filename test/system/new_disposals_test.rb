require "application_system_test_case"

class NewDisposalsTest < ApplicationSystemTestCase
  test "visiting new disposal" do
    set_current_user_and_organization
    visit choose_disposal_type_disposals_url(__org__: @current_organization.code)

    assert_selector "h1", text: "Scegli la tipologia di rifiuto"
  end
end
