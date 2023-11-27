require "application_system_test_case"
require "users_and_organizations_helper"

class DisposalUncomleteTest < ApplicationSystemTestCase
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

  test "manager find uncomplete disposal in disposals_url(uncomplete: 1)" do
    prepare_users_and_organizations
    prepare_disposal_types

    d = operator_disposal(@dt1)

    sign_in_as :manager
    visit disposals_url(__org__: @current_organization.code, uncomplete: 1)
    assert page.find(id: dom_id(d))
  end

  test "manager does not find complete disposal in disposals_url(uncomplete: 1)" do
    prepare_users_and_organizations
    prepare_disposal_types

    d = operator_disposal(@dt1)
    d.update(kgs: 9)

    sign_in_as :manager
    visit disposals_url(__org__: @current_organization.code, uncomplete: 1)
    assert_raise(Capybara::ElementNotFound) { page.find(id: dom_id(d)) }
  end
end

# https://github.com/teamcapybara/capybara
