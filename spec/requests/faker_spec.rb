require 'rails_helper'

RSpec.describe "Fakers", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/faker/index"
      expect(response).to have_http_status(:success)
    end
  end

end
