require "spec_helper"

RSpec.describe ApplicationHelper, type: :helper do
  describe ".interactions" do
    it "loads the data/interactions.yml file" do
      expect(ApplicationController.helpers.interactions).not_to be_nil
    end
  end

  describe ".interactions_types" do
    it "gets the keys from the data/interactions.yml file" do
      expect(ApplicationController.helpers.interaction_types).to include("random")
    end
  end
end
