Rails.application.routes.draw do
  mount DmUniboCommon::Engine => "/dm_unibo_common", :as => "dm_unibo_common"

  get "/choose_organization", to: "organizations#choose_organization", as: "choose_organization"

  get "up123", to: "rails/health#show", as: :rails_health_check

  # cesia list (more than dm_unibo_common)
  resources :organizations, only: [:index, :show]

  scope :nuter do
    get "charts", to: "nuter#charts", as: :charts
    get "report", to: "nuter#report", as: :report
  end

  get "helps/contacts", to: "helps#contacts", as: "contacts"
  get "/home", to: "home#index", as: "home"

  scope ":__org__" do
    # current_organization implicit
    get "/edit", to: "organizations#edit", as: "current_organization_edit"
    patch "/update", to: "organizations#update", as: "current_organization_update"

    get "dsausers/popup_find", to: "dsausers#popup_find", as: "popup_find_user"
    get "dsausers/find", to: "dsausers#find", as: "find_user"

    resources :prints, only: [:new, :create]

    post "search", to: "disposals#search", as: "search"

    # get "helps", to: "helps#index"
    # get "helps/images", to: "helps#images", as: "help_images"

    get "/", to: "disposals#index", as: "current_organization_root"

    resources :producers do
      resources :operators, only: [:new, :create]
    end
    resources :operators, only: [:edit, :update, :destroy]

    resources :disposals do
      get "choose_disposal_type", as: :choose_disposal_type, on: :collection
      get "archive", as: :archive, on: :collection
      get "clone", on: :member
      post "approve", on: :member
      post "unapprove", on: :member
      post "legalize", on: :collection
    end
    resources :disposal_types do
      resources :disposals, only: [:new, :create]
      resources :legal_uploads, only: [:new, :create, :edit, :update]
    end

    resources :suppliers do
      post :find, on: :collection
      get :find, on: :collection
      resources :contracts, only: [:new, :create]
    end
    resources :contracts, only: [:edit, :update, :destroy]

    resources :labs
    resources :buildings
    resources :cer_codes
    resources :un_codes
    resources :pickings do
      resources :picking_documents
      get :new_print_request, on: :member
      post :print_request, on: :member
      put :deliver, on: :member
      put :complete, on: :member
    end

    resources :picking_documents, only: [:show, :edit, :update] do
      resources :legal_downloads, only: [:new, :create]
    end

    resources :legal_records, only: [:index] do
      get :todo, on: :collection, as: :todo
    end
    resources :legal_uploads, only: [:show, :edit, :update]
    resources :legal_downloads, only: [:show, :edit, :update]

    resources :archives
    resources :reports

    resources :disposal_descriptions do
      resources :component_details
    end
    resources :hazards, only: [:index]
    resources :compliances

    get "mud", to: "mud#show", as: :mud
    get "deposit", to: "deposits#index", as: :deposit
    get "to_legalize", to: "deposits#to_legalize", as: :to_legalize
  end

  root to: "home#index"

  # samrtphone zxing
  get "zxing_search/(:bc)", controller: :barcodes, action: :zxing_search
end
