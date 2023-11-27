require "application_system_test_case"
require "users_and_organizations_helper"

class DisposalAcceptableTest < ApplicationSystemTestCase
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

  test "manager does not find uncomplete disposal in acceptable disposals" do
    prepare_users_and_organizations
    prepare_disposal_types

    d = operator_disposal(@dt1)

    sign_in_as :manager
    visit disposals_url(__org__: @current_organization.code, acceptable: 1)
    assert_raise(Capybara::ElementNotFound) { page.find(id: dom_id(d)) }
  end

  test "manager does find complete and unaccepted disposal in acceptable disposals" do
    prepare_users_and_organizations
    prepare_disposal_types

    d = operator_disposal(@dt1)
    d.update(kgs: 9)

    sign_in_as :manager
    visit disposals_url(__org__: @current_organization.code, acceptable: 1)
    assert page.find(id: dom_id(d))
  end

  test "manager does not find accepted disposal in acceptable disposals" do
    prepare_users_and_organizations
    prepare_disposal_types

    d = operator_disposal(@dt1)
    d.update(kgs: 9)
    d.approve!

    sign_in_as :manager
    visit disposals_url(__org__: @current_organization.code, acceptable: 1)
    assert_raise(Capybara::ElementNotFound) { page.find(id: dom_id(d)) }
  end
end

# https://github.com/teamcapybara/capybara
