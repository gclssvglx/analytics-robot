Rails.application.routes.draw do
  get "developer/index", as: "developer"
  get "/healthcheck/live", to: proc { [200, {}, %w[OK]] }
  get "/healthcheck/ready", to: GovukHealthcheck.rack_response

  post "home/fake", as: "fake"
  post "developer/runner", as: "runner"
  root "home#index"
end
