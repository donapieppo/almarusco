module UsersAndOrganizationsHelpers
  def prepare_users_and_organizations
    @users = {}
    @users[:operator] = FactoryBot.create(:user, upn: "u.operator@it", id: 1000)
    @users[:disposer] = FactoryBot.create(:user, upn: "n.disposer@it", id: 1001)
    @users[:manager] = FactoryBot.create(:user, upn: "n.manager@it", id: 1002)
    @users[:admin] = FactoryBot.create(:user, upn: "n.admin@it", id: 1003)

    @current_organization = FactoryBot.create(:organization)
    @other_organization = FactoryBot.create(:organization, code: "code_2", name: "org_name_2")

    @current_organization.permissions.create(user: @users[:operator], authlevel: Rails.configuration.authlevels[:operate])
    @current_organization.permissions.create(user: @users[:disposer], authlevel: Rails.configuration.authlevels[:dispose])
    @current_organization.permissions.create(user: @users[:manager], authlevel: Rails.configuration.authlevels[:manage])
    @current_organization.permissions.create(user: @users[:admin], authlevel: Rails.configuration.authlevels[:admin])

    FactoryBot.create(:lab, organization: @current_organization, name: "primo lab")
    FactoryBot.create(:lab, organization: @current_organization, name: "secondo lab")

    @con1 = FactoryBot.create(:container, name: "tanica", volume: 5)
    @con2 = FactoryBot.create(:container, name: "tanica", volume: 10)
    @con3 = FactoryBot.create(:container, name: "fusto", volume: 10)
  end

  def prepare_disposal_types
    @un_code1 = FactoryBot.create(:un_code)
    @un_code2 = FactoryBot.create(:un_code)
    @cer_code1 = FactoryBot.create(:cer_code)
    @cer_code2 = FactoryBot.create(:cer_code)
    @dt1 = FactoryBot.create(:disposal_type, organization: @current_organization, un_code: @un_code1, cer_code: @cer_code1, containers: [@con1, @con3])
    @dt2 = FactoryBot.create(:disposal_type, organization: @current_organization, un_code: @un_code2, cer_code: @cer_code2, containers: [@con2])
  end

  def sign_in_as(auth)
    # p auth
    # p @current_organization
    # p @other_organization
    # p @users
    # p @users[auth].id
    visit dm_unibo_common.auth_test_callback_path(user_id_id: @users[auth].id)
  end
end
