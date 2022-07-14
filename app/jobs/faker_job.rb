require 'webdrivers'
require 'capybara'

class FakerJob < ApplicationJob
  queue_as :default

  def perform(options)
    faker_job = CreateEvents.new(options)
    faker_job.run
  end
end
