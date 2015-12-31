Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  root 'imports#index'

  resources :imports, except: [:new, :edit, :update]

end
