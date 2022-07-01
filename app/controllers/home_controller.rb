class HomeController < ApplicationController
  def index
    @interaction_types = ApplicationController.helpers.interaction_types
    @environments = %w[integration] # just add 'staging'
  end

  def fake
    FakerJob.perform_now(params)
  end
end
