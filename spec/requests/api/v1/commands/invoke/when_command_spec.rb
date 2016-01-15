require "rails_helper"

RSpec.describe "POST /api/v1/commands/invoke", type: :request do
  describe "'when' command" do
    before do
      post api_v1_commands_invoke_path, payload.to_h
    end

    let(:payload) { create(:slack_when_command_payload) }

    it "responds with the event location" do
      user_reference = "Hopefully see you then #{payload.user_name}"
      expected_url   = "http://hey.wearestac.com/"

      expect(response).to have_http_status(200)
      expect(response.body).to include user_reference
      expect(response.body).to include expected_url
    end
  end
end
