Rails.application.routes.draw do
  get '/rails/info/properties' => "rails/info#properties"
  get '/rails/info/routes'     => "rails/info#routes"
  get '/rails/info'            => "rails/info#index"
  root to: "rails/welcome#index"

  get '/env' => "env#env"
end
