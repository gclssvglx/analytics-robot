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
    if %w[pageviews random].include?(interaction_type)
      find_interaction_urls.each do |url|
        iterations.to_i.times do
          get_url(url)
          output_event_data
          # We may not need the sleep here, if in production the queue is slow enough
          # Anything lower than 5 does not generate random pages
          sleep 5 if interaction_type == "random"
        end
      end
    else
      find_interaction_urls.each do |url|
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
end
