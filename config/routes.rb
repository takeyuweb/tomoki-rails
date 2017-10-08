Rails.application.routes.draw do
  post '/', to: 'jobs#create'
end
