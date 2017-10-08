Rails.application.routes.draw do
  post '/voices', to: 'voices#create'
  post '/voices/:id', to: 'voices#show', as: :voice # Twilio Voice URL へは POST アクセスされる
end
