class FakeEvents < GtmEventGenerator
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
      if %w(pageviews random).include?(interaction_type)
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
      ActionCable.server.broadcast 'faker_channel', get_event
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
    event = nil
    if %w(pageviews random).include?(interaction_type)
      events.each do |e|
        event = e if e["event"] == "config_ready"
      end
    else
      event = events.last
    end
    event.to_json
  end
end
