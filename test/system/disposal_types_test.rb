require "application_system_test_case"

class DisposalTypesTest < ApplicationSystemTestCase
  test "visiting the index" do
    sign_in_as(:manager)
    visit disposal_types_url(__org__: @current_organization.code)

    assert_selector "h1", text: "Tipologie di rifiuti"
  end
end
