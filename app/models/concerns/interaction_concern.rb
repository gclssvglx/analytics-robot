module InteractionConcern
  extend ActiveSupport::Concern

  def interaction_data
    ApplicationController.helpers.interactions
  end

  def find_interactions_by_type
    interactions[interaction_type]
  end

  def find_interaction_class
    find_interactions_by_type["class"]
  end

  def find_interaction_urls
    find_interactions_by_type["urls"]
  end

  def environment_url(url, environment)
    url.gsub("[ENVIRONMENT]", environment)
  end
end
