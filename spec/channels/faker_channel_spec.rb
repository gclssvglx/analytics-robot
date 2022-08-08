require "spec_helper"

RSpec.describe FakerChannel, type: :channel do
  it "successfully subscribes" do
    subscribe
    expect(subscription).to be_confirmed
  end

  it "successfully unsubscribes" do
    # subscribe
    # expect(subscription.unsubscribe_from_channel).to be_confirmed
  end
end
