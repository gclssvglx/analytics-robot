Rails.application.routes.draw do
  post "home/fake", as: "fake"
  root "home#index"
end
