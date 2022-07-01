class HomeController < ApplicationController
  def index
    if params[:env] && params[:runs]
      @environment = params[:env]
      @runs = params[:runs]
    end

    @interaction_types = ApplicationController.helpers.interaction_types
    @environments = %w[integration] # just add 'staging' when the time comes!
  end

  def fake
    params[:runs].each do |key, value|
      value[:environment] = params[:environment]
      FakerJob.perform_now value
    end
  end
end
