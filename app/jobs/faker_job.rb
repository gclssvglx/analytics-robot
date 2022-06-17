require 'webdrivers'
require 'capybara'

class FakerJob < ApplicationJob
  queue_as :default

  def perform(*args)
    capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
      'goog:chromeOptions': { args: %w(headless disable-gpu) }
    )
    driver = Selenium::WebDriver.for :chrome, capabilities: capabilities

    begin
      driver.get 'https://bright-tartufo-3c9320.netlify.app/ga4'
      clickables = driver.find_elements(class: 'event-link-click')
      clickables.each do |clickable|
        clickable.click
        last_event = driver.execute_script('return dataLayer').last
        puts last_event.inspect

        ActionCable.server.broadcast 'faker_channel', last_event.inspect
      end
    ensure
      driver.quit
    end
  end
end
