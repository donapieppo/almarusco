require "application_system_test_case"
require "users_and_organizations_helper"

class DisposalOperationsTest < ApplicationSystemTestCase
  include UsersAndOrganizationsHelpers

  test "uncomplete disposals" do
    prepare_users_and_organizations
    prepare_disposal_types

    d1 = @dt1.disposals.create(
      organization_id: @current_organization.id,
      user: @users[:operator],
      producer: @users[:operator],
      kgs: 0,
      container: @dt1.containers.first,
      lab: Lab.first
    )

    sign_in_as :manager
    visit disposals_url(__org__: @current_organization.code, uncomplete: 1)
    assert page.find(id: dom_id(d1))

    d1.update(kgs: 9)
    visit disposals_url(__org__: @current_organization.code, uncomplete: 1)

    assert_raise(Capybara::ElementNotFound) { page.find(id: dom_id(d1)) }
  end

  test "acceptable disposals" do
    prepare_users_and_organizations
    prepare_disposal_types

    d1 = @dt1.disposals.create(
      organization_id: @current_organization.id,
      user: @users[:operator],
      producer: @users[:operator],
      container: @dt1.containers.first,
      lab: Lab.first
    )

    sign_in_as :manager
    visit disposals_url(__org__: @current_organization.code, acceptable: 1)
    assert_raise(Capybara::ElementNotFound) { page.find(id: dom_id(d1)) }

    d1.update(kgs: 9)
    visit disposals_url(__org__: @current_organization.code, acceptable: 1)
    assert page.find(id: dom_id(d1))

    d1.approve!
    visit disposals_url(__org__: @current_organization.code, acceptable: 1)
    assert_raise(Capybara::ElementNotFound) { page.find(id: dom_id(d1)) }
  end

  test "accept disposals" do
    prepare_users_and_organizations
    prepare_disposal_types

    d1 = @dt1.disposals.create(
      organization_id: @current_organization.id,
      user: @users[:operator],
      kgs: 8,
      producer: @users[:operator],
      container: @dt1.containers.first,
      lab: Lab.first
    )

    sign_in_as :manager
    visit disposals_url(__org__: @current_organization.code, acceptable: 1)
    assert page.find(id: dom_id(d1))

    within(id: dom_id(d1)) do
      assert_text d1.producer.to_s
    end
  end
end

# https://github.com/teamcapybara/capybara
