require "yaml"
require "fileutils"

class GtmEventGenerator
  include InteractionConcern
  attr_reader :options, :interactions, :driver, :capabilities, :output_file

  def initialize(options)
    @options = options
    @interactions = interaction_data
    @capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
      "goog:chromeOptions": { args: ["headless", "disable-gpu", "user-agent=Analytics Robot"] },
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
    elements = []
    find_interaction_class.each do |klass|
      elements += driver.find_elements(css: klass)
    end
    elements
  end

  def events
    # execute_script should be used over #evaluate_script whenever possible.
    # evaluate_script will always return a result. The return value will be
    # converted back to Ruby objects, which in case of complex objects is very expensive
    # https://makandracards.com/makandra/12317-capybara-selenium-evaluate_script-might-freeze-your-browser-use-execute_script

    driver.execute_script("if(window.dataLayer){ return window.dataLayer } else { return ['The dataLayer is unavailable on this page'] }")
  end

  def get_url(url)
    url = environment_url(url, environment)
    driver.get url
  end

  def display
    options[:display]
  end
end
