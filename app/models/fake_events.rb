class FakeEvents < GtmEventGenerator
  def run
    if display == "browser"
      fake_events
    else
      events_output_to_file
    end
  end

private

  def fake_events
    # This is a problem - at this point we don't have a url!
    accept_all_cookies("https://www.integration.publishing.service.gov.uk")

    if %w[pageviews random].include?(interaction_type)
      find_interaction_urls.each_with_index do |url, _index|
        iterations.to_i.times do
          get_url(url)
          output_event_data
          # We may not need the sleep here, if in production the queue is slow enough
          # Anything lower than 5 does not generate random pages
          sleep 5 if interaction_type == "random"
        end
      end
    else
      find_interaction_urls.each_with_index do |url, _index|
        iterations.to_i.times do
          get_url(url)
          clickables.each do |clickable|
            if interaction_type == "accordions"
              %w[opened closed].each do |_state|
                clickable.click
                output_event_data
              end
            else
              clickable.click
              output_event_data
            end
          end
        end
      end
    end
  ensure
    driver.quit
  end

  def output_event_data
    if display == "browser"
      ActionCable.server.broadcast "faker_channel", get_event
    else
      @output_file.puts get_event
      @output_file.puts "\n"
    end
  end

  def events_output_to_file
    @output_file = File.open("log/#{Time.zone.now.strftime('%Y-%m-%d-%H-%M-%S')}.log", "w")
    fake_events
  ensure
    @output_file.close
  end

  def get_event
    event = nil
    if %w[pageviews random].include?(interaction_type)
      events.reverse.each do |e|
        event = e if e["event"] == "page_view"
      end
    else
      event = events.last
    end
    event.to_json
  end

  def accept_all_cookies(url)
    url = environment_url(url, environment)
    uri = URI.parse(url)
    root_url = "#{uri.scheme}://#{uri.host}"

    driver.get root_url
    driver.find_element(:xpath, "//*[@data-accept-cookies='true']").click
    driver.find_element(:xpath, "//*[@data-hide-cookie-banner='true']").click
  end

  def get_url(url)
    url = environment_url(url, environment)
    url = ApplicationController.helpers.append_utm(url, interaction_type, environment)
    driver.get url
  end
end
