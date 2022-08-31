module ApplicationHelper
  def interactions
    @interactions ||= YAML.load_file("data/interactions.yml")
  end

  def interaction_types
    @interaction_types ||= interactions.keys
  end

  def append_utm(url, interaction_type, environment)
    # Appends Urchin Tracking Module (UTM) codes to the given URL.
    # https://agencyanalytics.com/blog/utm-tracking
    "#{url}?utm_source=analytics_robot&utm_medium=fake_#{interaction_type}_event&utm_campaign=#{environment}"
  end
end
