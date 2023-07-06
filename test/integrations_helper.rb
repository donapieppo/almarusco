module IntegrationHelpers
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
  end

  def sign_in_as(auth)
    prepare_users_and_organizations
    p auth
    p @current_organization
    p @other_organization
    p @users
    p @users[auth].id
    get dm_unibo_common.auth_test_callback_path, params: {user_id_id: @users[auth].id}
    follow_redirect!
  end
end
