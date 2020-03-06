Rails.application.routes.draw do
  get '/', to: 'shows#index'
  get '/shows', to: 'shows#show', as: 'show_page'

  root 'shows#index'
end