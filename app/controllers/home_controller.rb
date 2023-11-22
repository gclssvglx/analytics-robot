class HomeController < ApplicationController
  def index
    @interaction_types = ApplicationController.helpers.interaction_types
    @environments = %w[integration.publishing.service.gov.uk staging.publishing.service.gov.uk gov.uk]
  end

  def fake
    params[:display] = "browser"
    FakerJob.perform_now params
  end
end
