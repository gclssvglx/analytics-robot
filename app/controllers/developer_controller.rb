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

    events = driver.execute_script("if(window.dataLayer){ return window.dataLayer } else { return ['The dataLayer is unavailable on this page'] }")
    ActionCable.server.broadcast "developer_channel", events
    driver.quit
  end

private

  def accept_cookies(driver)
    element = driver.find_element(:css, "[data-accept-cookies]")
    element.click unless element.nil?
  rescue StandardError
    Rails.logger.debug "No GOV.UK cookies on page"
  end

  def click_elements(driver)

    header_search_button = driver.find_element(:css, "#super-search-menu-toggle")
    header_search_button.click unless header_search_button.nil?

    # We use JavaScript to fake the clicks, because Selenium errors when you try to interact with hidden elements.
    driver.execute_script('
      document.addEventListener("click", function(e) {
        e.preventDefault();
      })')
    driver.execute_script('
      document.addEventListener("submit", function(e) {
        e.preventDefault()
      })')

    driver.execute_script('window.ga4Links = document.querySelectorAll("[data-ga4-link]")')
    driver.execute_script('window.ga4Events = document.querySelectorAll("[data-ga4-event]")')
    driver.execute_script('window.ga4FormSubmits = document.querySelectorAll("[data-ga4-form] [type=submit]")')

    driver.execute_script(
      'for (var i = 0; i < window.ga4Links.length; i++) {
        window.GOVUK.triggerEvent(window.ga4Links[i], "click")
      }')

    driver.execute_script(
      'for (var i = 0; i < window.ga4Events.length; i++) {
        window.GOVUK.triggerEvent(window.ga4Events[i], "click")

        // If the element is expandable, like an accordion, click it twice so that it gives us both the open and closed state.
        if(window.ga4Events[i].closest("[data-ga4-expandable]")) {
          window.GOVUK.triggerEvent(window.ga4Events[i], "click")
        }
      }')

    driver.execute_script(
      'for (var i = 0; i < window.ga4FormSubmits.length; i++) {
        window.GOVUK.triggerEvent(window.ga4FormSubmits[i], "click")
      }')

  end
end
