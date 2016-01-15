require "rails_helper"

RSpec.describe "POST /api/v1/commands/invoke", type: :request do
  describe "security validation" do
    let(:error_message) { "Unknown slack token :astonished:" }

    before do
      post api_v1_commands_invoke_path, payload.to_h
    end

    context "with an invalid token" do
      let(:payload) { create(:slack_invalid_token_payload) }

      it "responds with an error" do
        expect(response).to have_http_status(500)
        expect(response.body).to be == error_message
      end
    end

    context "with a valid token" do
      let(:payload) { create(:slack_payload) }

      it "responds with success" do
        expect(response).to have_http_status(200)
      end
    end
  end
end
