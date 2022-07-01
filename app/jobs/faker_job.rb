require 'webdrivers'
require 'capybara'

class FakerJob < ApplicationJob
  queue_as :default

  def perform(options)
    puts options.inspect
    capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
      'goog:chromeOptions': { args: %w(headless disable-gpu) }
    )
    driver = Selenium::WebDriver.for :chrome, capabilities: capabilities

    begin
      interaction_type = options[:interaction_type]
      interactions = ApplicationController.helpers.interactions[interaction_type]

      options[:iterations].to_i.times do
        if interaction_type == "pageviews"
          interactions["urls"].each do |url|
            driver.get ApplicationController.helpers.environment_url(url, options[:environment])
            ActionCable.server.broadcast 'faker_channel', find_event(driver, interaction_type).to_json
          end
        else
          interactions["urls"].each do |url|
            driver.get ApplicationController.helpers.environment_url(url, options[:environment])
            clickables = driver.find_elements(class: interactions["class"])
            clickables.each do |clickable|
              clickable.click
              ActionCable.server.broadcast 'faker_channel', find_event(driver, interaction_type).to_json
            end
          end
        end
      end
    ensure
      driver.quit
    end
  end

  private

  def find_event(driver, interaction_type)
    events = driver.execute_script("return dataLayer")
    events.each do |event|
      if interaction_type == "pageviews"
        return event if event["event"] == "config_ready"
      else
        return event if event["event"] == "analytics"
      end
    end
    { error: "Unknown interaction type #{interaction_type}" }
  end
end
