require 'rails_helper'

RSpec.describe "Developers", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/developer/index"
      expect(response).to have_http_status(:success)
    end
  end

end
