class HomeController < ApplicationController
  def index
    @interaction_types = ApplicationController.helpers.interaction_types
    @environments = %w[gov.uk staging.publishing.service.gov.uk integration.publishing.service.gov.uk]
  end

  def fake
    params[:display] = "browser"
    FakerJob.perform_now params
  end
end
