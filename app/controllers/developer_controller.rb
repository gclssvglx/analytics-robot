require "webdrivers"

class DeveloperController < ApplicationController
  def index; end

  def runner
    url = params[:url]
    capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
      "goog:chromeOptions": { args: ["headless", "disable-gpu", "user-agent=Analytics Robot"] },
    )
    driver = Selenium::WebDriver.for :chrome, capabilities: capabilities

    driver.get url
    accept_cookies(driver)
    click_elements(driver)

    events = driver.execute_script("return dataLayer")
    ActionCable.server.broadcast "developer_channel", events
    driver.quit
  end

private

  def accept_cookies(driver)
    element = driver.find_element(:xpath, "//*[@data-accept-cookies='true']")
    element.click unless element.nil?
  rescue StandardError
    Rails.logger.debug "No GOV.UK cookies on page"
  end

  def click_elements(driver)
    elements = driver.find_elements(:xpath, "//*[@data-ga4]")
    elements.each do |element|
      data_ga4 = JSON.parse(element.attribute("data-ga4"))
      begin
        if data_ga4["type"] == "accordion"
          %w[opened closed].each do |_state|
            element.click
          end
        else
          element.click
        end
      rescue StandardError
        Rails.logger.debug "Element [#{element.tag_name} - #{element.accessible_name}] is not interactable!"
      end
    end
  end
end
