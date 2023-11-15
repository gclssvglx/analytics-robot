class HomeController < ApplicationController
  def index
    @interaction_types = ApplicationController.helpers.interaction_types
    @environments = %w[staging integration]
  end

  def fake
    params[:display] = "browser"
    FakerJob.perform_now params
  end
end
