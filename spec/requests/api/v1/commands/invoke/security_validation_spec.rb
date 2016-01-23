require "rails_helper"

RSpec.describe "POST /api/v1/commands/invoke", type: :request do
  describe "security validation" do
    before do
      post api_v1_commands_invoke_path, payload.to_h
    end

    context "with an invalid token" do
      let(:payload) { create :slack_payload, token: Faker::Lorem.characters(24) }

      it "responds with an error message" do
        expect(response).to have_http_status(200)
        expect(response.body).to be == SlashCommand::PayloadValidator::TOKEN_ERROR
      end
    end

    context "with a valid token" do
      let(:payload) { create(:slack_payload) }

      it "responds with success" do
        expect(response).to have_http_status(200)
        expect(User.count).to_not be_zero
      end
    end
  end
end
