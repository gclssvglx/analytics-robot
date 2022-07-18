module ApplicationHelper
  def interactions
    @interactions ||= YAML.load_file('data/interactions.yml')
  end

  def interaction_types
    @interaction_types ||= interactions.keys
  end
end
