require "application_system_test_case"
require "users_and_organizations_helper"

class NewDisposalsTest < ApplicationSystemTestCase
  include UsersAndOrganizationsHelpers

  def operator_can_not_create_cer_code
    sign_in_as :operator
    visit new_cer_code_url(__org__: @current_organization.code)
    assert_raise(Pundit::NotAuthorizedError) { click_on "Crea Codice CER" }
  end

  def manager_creates_cer_code(code)
    sign_in_as :manager
    visit new_cer_code_url(__org__: @current_organization.code)
    fill_in "Codice", with: code
    fill_in "Descrizione", with: "descrizione #{code}"
    click_on "Crea Codice CER"
    assert_text code
  end

  def manager_creates_un_code(code)
    sign_in_as :manager
    visit new_un_code_url(__org__: @current_organization.code)
    fill_in "Numero", with: code
    fill_in "Nome", with: "nome di un #{code}"
    click_on "Crea"
    assert_text code
  end

  def manager_can_not_create_disposal_type_without_containers(cer_code, un_code)
    sign_in_as :manager
    visit new_disposal_type_url(__org__: @current_organization.code)
    # Rails.logger.info page.html.inspect
    choose "liquido", allow_label_click: true
    choose "CER 020108", visible: false, allow_label_click: true
    # choose "CER #{cer_code}"
    choose "UN #{un_code}", visible: false, allow_label_click: true
    click_on "Crea Tipologia"
    assert_text "L'operazione non è stata possibile"
  end

  def manager_creates_disposal_type(cer_code, un_code)
    sign_in_as :manager
    visit new_disposal_type_url(__org__: @current_organization.code)
    choose "liquido", allow_label_click: true
    choose "CER #{cer_code}", visible: false, allow_label_click: true
    # choose "CER #{cer_code}"
    choose "UN #{un_code}", visible: false, allow_label_click: true
    check "tanica 10 lt."
    check "fusto 10 lt."
    click_on "Crea Tipologia"
    assert_text "CER #{cer_code} - UN #{un_code} - (liquido)"
  end

  def operator_can_create_new_disposal(cer_code, un_code, kg: nil)
    sign_in_as :operator
    visit choose_disposal_type_disposals_url(__org__: @current_organization.code)
    click_on "CER #{cer_code} - UN #{un_code} - (liquido)"
    select Lab.first.name
    if kg
      fill_in "Peso", with: kg
    end
    choose "tanica 10 lt."
    click_on "Crea Rifiuto"
    assert_text "Salvata la richiesta"
    assert_text "Produttore: #{@users[:operator].name}"
    assert_text "Richiesta del #{I18n.l Date.today}"
    if kg.to_i <= 0
      assert_text "? Kg."
      assert_text "manca il peso"
    else
      assert_text "#{kg}.0 Kg."
    end
  end

  def manager_adds_kgs_to_disposal(cer_code, un_code, kg)
    sign_in_as :manager
    visit disposals_url(__org__: @current_organization.code)
    click_on "manca il peso"
    fill_in "Peso", with: kg
    click_on "Aggiorna Rifiuto"
    assert_text "#{kg}.0 Kg."
  end

  def manager_sees_uncomplete_disposals(cer_code, un_code, present: true)
    sign_in_as :manager
    visit disposals_url(__org__: @current_organization.code, uncomplete: 1)
    if present
      assert_text "CER #{cer_code} - UN #{un_code}"
    else
      assert_no_text "CER #{cer_code} - UN #{un_code}"
    end
  end

  def manager_sees_acceptable_disposals(cer_code, un_code, present: true)
    sign_in_as :manager
    visit disposals_url(__org__: @current_organization.code, acceptable: 1)
    if present
      assert_text "CER #{cer_code} - UN #{un_code}"
    else
      assert_no_text "CER #{cer_code} - UN #{un_code}"
    end
  end

  test "creation of disposal_types and disposals" do
    prepare_users_and_organizations
    operator_can_not_create_cer_code

    manager_creates_cer_code("020108")
    manager_creates_cer_code("020109")
    manager_creates_un_code("1090")
    manager_creates_un_code("1091")

    manager_can_not_create_disposal_type_without_containers("020108", "1090")
    manager_creates_disposal_type("020108", "1090")
    operator_can_create_new_disposal("020108", "1090", kg: 0)

    manager_sees_uncomplete_disposals("020108", "1090", present: true)
    manager_adds_kgs_to_disposal("020108", "1090", 11)
    manager_sees_uncomplete_disposals("020108", "1090", present: false)

    manager_creates_disposal_type("020109", "1091")
    operator_can_create_new_disposal("020109", "1091", kg: 17)

    manager_sees_acceptable_disposals("020108", "1090", present: true)
  end

  def uncomplete_disposals
    prepare_users_and_organizations
    d = FactoryBot.create(:disposal, user: @user[:operator])
  end
end
