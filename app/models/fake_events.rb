class FakeEvents < GoogleTagManager
  def initialize(options)
    super
  end

  def run
    if display == "browser"
      fake_events
    else
      events_output_to_file
    end
  end

  private

  def fake_events
    begin
      if interaction_type == "pageviews"
        find_interaction_urls.each do |url|
          iterations.to_i.times do
            get_url(url)
            output_event_data
          end
        end
      else
        find_interaction_urls.each do |url|
          iterations.to_i.times do
            get_url(url)
            clickables.each do |clickable|
              clickable.click
              output_event_data
            end
          end
        end
      end
    ensure
      driver.quit
    end
  end

  def output_event_data
    if display == "browser"
      ActionCable.server.broadcast 'faker_channel', get_event.to_json
    else
      @output_file.puts get_event
      @output_file.puts "\n"
    end
  end

  def events_output_to_file
    begin
      @output_file = File.open("log/#{Time.now.strftime('%Y-%m-%d-%H-%M-%S')}.log", "w")
      fake_events
    ensure
      @output_file.close
    end
  end

  def get_event
    events.each do |event|
      if interaction_type == "pageviews"
        return event if event["event"] == "config_ready"
      else
        return event if event["event"] == "analytics"
      end
    end
    { error: "Unknown interaction type #{interaction_type}" }.to_json
  end
end
