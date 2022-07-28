class TestEvents < GtmEventGenerator
  def initialize(options)
    super
  end

  def run
    tester
  end

  private

  def tester
    begin
      find_interaction_urls.each do |url|
        iterations.to_i.times do
          get_url(url)
          clickables.each do |clickable|
            if interaction_type == "tabs"
              test_tab_events(clickable)
            elsif interaction_type == "accordions"
              test_accordion_events(clickable)
            end
          end
        end
      end
    ensure
      driver.quit
    end
  end

  def test_result(expected_event)
    last_event = events.last.except("gtm.uniqueEventId")
    print last_event.eql?(expected_event) ? "😀" : "\n🤮 : #{diff_events(last_event, expected_event)}\n"
  end

  def test_tab_events(tab)
    tab.click
    expected_event = create_event(events.last["event_data"])
    test_result(expected_event)
  end

  def test_accordion_events(accordion)
    %w[opened closed].each do |state|
      accordion.click
      expected_event = create_event(events.last["event_data"])
      test_result(expected_event)
    end
  end

  def current_url
    uri = URI.parse(driver.current_url)
    if uri.fragment
      "#{uri.path}##{uri.fragment}"
    else
      "#{uri.path}"
    end
  end

  def create_event(data_attributes)
    {
      "event" => "event_data",
      "event_data" => {
        "action" => data_attributes["action"],
        "event_name" => data_attributes["event_name"],
        "external" => data_attributes["external"],
        "index" => data_attributes["index"],
        "index_total" => data_attributes["index_total"],
        "section" => data_attributes["section"],
        "text" => data_attributes["text"],
        "type" => data_attributes["type"],
        "url" => data_attributes["url"],
      }
    }
  end

  def diff_events(event_a, event_b)
    Hash[*(
      (event_b.size > event_a.size) ? event_b.to_a - event_a.to_a : event_a.to_a - event_b.to_a
    ).flatten]
  end
end
