Healthchecker::Engine.routes.draw do

  get '/status' => 'health#show'
  get '/metrics' => 'metrics#show'
end
