require "application_system_test_case"
require "users_and_organizations_helper"

# Deposito temporaneo
class DisposalDepositTest < ApplicationSystemTestCase
  include UsersAndOrganizationsHelpers

  def operator_disposal(dt)
    dt.disposals.create(
      organization_id: @current_organization.id,
      user: @users[:operator],
      producer: @users[:operator],
      kgs: 0,
      container: dt.containers.first,
      lab: Lab.first
    )
  end

  test "operator can not visit deposit page" do
    prepare_users_and_organizations
    prepare_disposal_types

    sign_in_as :operator
    visit deposit_url(__org__: @current_organization.code)
    assert_raise(Pundit::NotAuthorizedError) { click_on "Deposito temporaneo" }
  end

  test "deposit page has approved disposals and not unapproved disposals" do
    prepare_users_and_organizations
    prepare_disposal_types

    d1 = operator_disposal(@dt1)
    d1.update(kgs: 10)
    d1.approve!

    d2 = operator_disposal(@dt1)
    d2.update(kgs: 9)

    sign_in_as :manager
    visit deposit_url(__org__: @current_organization.code)

    assert page.find(id: dom_id(d1))
    assert_raise(Capybara::ElementNotFound) { page.find(id: dom_id(d2)) }
  end
end

# https://github.com/teamcapybara/capybara
