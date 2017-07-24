Rails.application.routes.draw do

  mount Healthchecker::Engine => "/healthchecker"
end
