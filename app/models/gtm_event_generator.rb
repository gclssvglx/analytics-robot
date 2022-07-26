require "webdrivers"
require "yaml"
require "fileutils"

class GtmEventGenerator
  include InteractionConcern
  attr_reader :options, :interactions, :driver, :output_file

  def initialize(options, interactions = interaction_data)
    @options = options
    @interactions = interactions
    @capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
      "goog:chromeOptions": { args: %w(headless disable-gpu) }
    )
    @driver = Selenium::WebDriver.for :chrome, capabilities: @capabilities
    FileUtils.mkdir_p "log"
  end

  def environment
    options[:environment]
  end

  def interaction_type
    options[:interaction_type]
  end

  def iterations
     options[:iterations] ||= 1
  end

  def clickables
    driver.find_elements(class: find_interaction_class)
  end

  def events
    #execute_script should be used over #evaluate_script whenever possible.
    #evaluate_script will always return a result. The return value will be
    #converted back to Ruby objects, which in case of complex objects is very expensive
    #https://makandracards.com/makandra/12317-capybara-selenium-evaluate_script-might-freeze-your-browser-use-execute_script
    begin
      driver.execute_script("return dataLayer")
    rescue
      puts "dataLayer is not configured for that page"
    end
  end

  def get_url(url)
    url = environment_url(url, environment)
    driver.get url
  end

  def display
    options[:display]
  end
end
