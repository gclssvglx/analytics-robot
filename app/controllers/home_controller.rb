class HomeController < ApplicationController
  def index
    @interaction_types = ApplicationController.helpers.interaction_types
    @environments = %w[integration] # just add 'staging' when the time comes!
  end

  def fake
    params[:display] = "browser"
    FakerJob.perform_now params
  end
end
