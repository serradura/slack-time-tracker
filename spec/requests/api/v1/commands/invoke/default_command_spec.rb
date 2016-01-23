require "rails_helper"

RSpec.describe "POST /api/v1/commands/invoke", type: :request do
  describe "default command" do
    let(:payload) { create(:slack_payload, text: " ") }

    before do
      post api_v1_commands_invoke_path, payload.to_h
    end

    it "responds with command help" do
      expect(response).to have_http_status(200)
      expect(response.body).to be == SlashCommand::Commands::Help.help
    end
  end
end
