Rails.application.routes.draw do
  post 'file_upload/upload'
  post 'file_upload/big_upload'

  get 'home/download_file'
  post 'home/filter_by_app'
  post 'home/filter_by_dates'
  get 'home/index'

  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
