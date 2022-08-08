class TestEvents < GtmEventGenerator
  def run
    tester
  end

private

  def tester
    find_interaction_urls.each do |url|
      iterations.to_i.times do
        get_url(url)
        if interaction_type == "pageviews"
          test_pageview_events if interaction_type == "pageviews"
        elsif %w[tabs accordions].include?(interaction_type)
          clickables.each do |clickable|
            case interaction_type
            when "tabs"
              test_tab_events(clickable)
            when "accordions"
              test_accordion_events(clickable)
            end
          end
        end
      end
    end
  ensure
    driver.quit
  end

  def test_result(actual_event, expected_event)
    event = actual_event.except("gtm.uniqueEventId")
    Rails.logger.debug event.eql?(expected_event) ? "😀" : "\n🤮 : #{diff_events(event, expected_event)}\n"
  end

  def test_tab_events(tab)
    tab.click
    expected_event = create_event_data(events.last["event_data"])
    test_result(events.last, expected_event)
  end

  def test_accordion_events(accordion)
    %w[opened closed].each do |_state|
      accordion.click
      expected_event = create_event_data(events.last["event_data"])
      test_result(events.last, expected_event)
    end
  end

  def test_pageview_events
    events.reverse.each do |event|
      if event["event"] == "page_view"
        expected_event = create_page_view_data(event["page_view"])
        test_result(event, expected_event)
      end
    end
  end

  def current_url
    uri = URI.parse(driver.current_url)
    if uri.fragment
      "#{uri.path}##{uri.fragment}"
    else
      uri.path.to_s
    end
  end

  def create_event_data(data_attributes)
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
      },
    }
  end

  def create_page_view_data(data_attributes)
    {
      "event" => "page_view",
      "page_view" => {
        "content_id" => data_attributes["content_id"],
        "document_type" => data_attributes["document_type"],
        "first_published_at" => data_attributes["first_published_at"],
        "history" => data_attributes["history"],
        "language" => data_attributes["language"],
        "location" => data_attributes["location"],
        "organisations" => data_attributes["organisations"],
        "political_status" => data_attributes["political_status"],
        "primary_publishing_organisation" => data_attributes["primary_publishing_organisation"],
        "public_updated_at" => data_attributes["public_updated_at"],
        "publishing_app" => data_attributes["publishing_app"],
        "publishing_government" => data_attributes["publishing_government"],
        "referrer" => data_attributes["referrer"],
        "rendering_app" => data_attributes["rendering_app"],
        "schema_name" => data_attributes["schema_name"],
        "section" => data_attributes["section"],
        "status_code" => data_attributes["status_code"],
        "taxon_id" => data_attributes["taxon_id"],
        "taxon_ids" => data_attributes["taxon_ids"],
        "taxon_slug" => data_attributes["taxon_slug"],
        "taxon_slugs" => data_attributes["taxon_slugs"],
        "themes" => data_attributes["themes"],
        "title" => data_attributes["title"],
        "updated_at" => data_attributes["updated_at"],
        "withdrawn" => data_attributes["withdrawn"],
        "world_locations" => data_attributes["world_locations"],
      },
    }
  end

  def diff_events(event_a, event_b)
    Hash[*(
      event_b.size > event_a.size ? event_b.to_a - event_a.to_a : event_a.to_a - event_b.to_a
    ).flatten]
  end
end
