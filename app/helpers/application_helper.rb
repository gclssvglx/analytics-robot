module ApplicationHelper
  def interactions
    @interactions ||= YAML.load_file('data/interactions.yml')
  end

  def interaction_types
    @interaction_typs ||= interactions.keys
  end

  def environment_url(url, environment)
    url.gsub("[ENVIRONMENT]", environment)
  end
end
