require "spec_helper"

RSpec.describe FakerJob, type: :job do
  it "enqueues the job with the given options" do
    options = {
      environment: "integration",
      interaction_type: "random",
      iterations: "1",
    }

    ActiveJob::Base.queue_adapter = :test

    expect {
      described_class.perform_later options
    }.to have_enqueued_job(described_class)
  end
end
