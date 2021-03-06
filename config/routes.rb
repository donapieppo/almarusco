Rails.application.routes.draw do
  mount DmUniboCommon::Engine => "/dm_unibo_common"

  get '/logins/logout',  to: 'dm_unibo_common/logins#logout'

  get '/choose_organization',    to: "organizations#choose_organization", as: "choose_organization"
  get '/no_access',              to: "logins#no_access", as: "no_access"

  # cesia list (more than dm_unibo_common)
  get '/organizations',              to: 'organizations#index', as: "organizations"
  # get '/helps',                      to: 'helps#index' # OLD

  scope ":__org__" do
    # current_organization implicit
    get  '/edit',           to: 'organizations#edit',   as: "current_organization_edit"
    patch '/update',        to: 'organizations#update', as: "current_organization_update"

    get 'dsausers/popup_find', to: 'dsausers#popup_find', as: 'popup_find_user'
    get 'dsausers/find',       to: 'dsausers#find',       as: 'find_user'

    resources :prints, only: [:new, :create]

    post 'search', to: 'disposals#search', as: 'search'

    # get  'helps',          to: 'helps#index'
    get  'helps/contacts', to: 'helps#contacts', as: 'contacts'
    get  'helps/images',   to: 'helps#images', as: 'help_images'

    get '/', to: 'disposals#index', as: 'current_organization_root'

    resources :producers do 
      resources :operators, only: [:new, :create]
    end
    resources :operators, only: :destroy

    resources :disposals do
      get 'choose_disposal_type', as: :choose_disposal_type, on: :collection
      get 'archive', as: :archive, on: :collection
      get 'clone', on: :member
      post 'approve', on: :member
      post 'unapprove', on: :member
      post 'legalize', on: :collection
    end
    resources :disposal_types do
      resources :disposals, only: [:new, :create]
    end

    resources :suppliers do
      post :find, on: :collection
      get  :find, on: :collection
    end

    resources :labs
    resources :cer_codes
    resources :un_codes
    resources :pickings do
      resources :picking_documents
      get :print, on: :member
      put :deliver, on: :member
      put :complete, on: :member
    end

    resources :picking_documents, only: [:edit, :update]
    resources :archives

    get 'mud', to: 'mud#show', as: :mud
    get 'deposit', to: 'deposits#index', as: :deposit
    get 'to_legalize', to: 'deposits#to_legalize', as: :to_legalize
  end

  root to: 'disposals#index'

  # samrtphone zxing
  get "zxing_search/(:bc)", controller: :barcodes, action: :zxing_search
end


