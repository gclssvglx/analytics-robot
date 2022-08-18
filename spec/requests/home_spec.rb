require "spec_helper"

RSpec.describe "Home", type: :request do
  describe "GET /" do
    it "returns http success" do
      get root_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /home/fake" do
    it "returns http success" do
      options = {
        environment: "integration",
        interaction_type: "random",
        iterations: "1",
      }

      post fake_path, params: options

      expect {
        FakerJob.perform_later options
      }.to have_enqueued_job(FakerJob)

      expect(response).to have_http_status(:success)
    end
  end
end
