require "rails_helper"

RSpec.describe "POST /api/v1/commands/invoke", type: :request do
  describe "Unknown command" do
    before do
      post api_v1_commands_invoke_path, payload.to_h
    end

    let(:payload) { create(:slack_unknown_command_payload) }

    it "responds with a sad message" do
      expected_message = "Unknown command :cry:"

      expect(response).to have_http_status(200)
      expect(response.body).to be == expected_message
    end
  end
end
