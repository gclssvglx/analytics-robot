class TestEvents < GoogleTagManager
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

  def event_name(clickable)
    clickable.attribute("data-gtm-event-name")
  end

  def data_attributes(clickable)
    JSON.parse(clickable.attribute("data-gtm-attributes"))
  end

  def test_result(expected_event)
    puts events.last == expected_event ? "😀" : "🤮 : #{diff_events(events.last, expected_event)}"
  end

  def test_tab_events(tab)
    tab.click

    expected_event = create_event(event_name(tab), events.length, data_attributes(tab), data_attributes(tab)["state"])
    test_result(expected_event)
  end

  def test_accordion_events(accordion)
    %w[opened closed].each do |state|
      accordion.click

      expected_event = create_event(event_name(accordion), events.length, data_attributes(accordion), state)
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

  def create_event(event_name, id, data_attributes, state)
    {
      "event" => "analytics",
      "event_name" => event_name,
      "gtm.uniqueEventId" => id,
      "link_url" => current_url,
      "ui" => {
        "index" => data_attributes["index"],
        "index-total" => data_attributes["index-total"],
        "section" => data_attributes["section"],
        "action" => state,
        "text" => data_attributes["text"],
        "type" => data_attributes["type"]
      }
    }
  end

  def diff_events(event_a, event_b)
    Hash[*(
      (event_b.size > event_a.size) ? event_b.to_a - event_a.to_a : event_a.to_a - event_b.to_a
    ).flatten]
  end
end
