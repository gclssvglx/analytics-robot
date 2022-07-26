require 'webdrivers'
require 'capybara'

class FakerJob < ApplicationJob
  queue_as :default

  def perform(options)
    faker_job = FakeEvents.new(options, YAML.load_file('data/myapp.yml'))
    # faker_job = FakeEvents.new(options)
    faker_job.run
  end
end
