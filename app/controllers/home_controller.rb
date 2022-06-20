class HomeController < ApplicationController
  def index
    if params[:fake].present?
      FakerJob.perform_now
    end
  end
end
