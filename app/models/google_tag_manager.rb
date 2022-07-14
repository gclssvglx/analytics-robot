require "webdrivers"
require "yaml"
require "fileutils"

class GoogleTagManager
  include InteractionConcern
  attr_reader :options, :interactions, :driver, :output_file

  def initialize(options)
    @options = options
    @interactions = interaction_data
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
end
