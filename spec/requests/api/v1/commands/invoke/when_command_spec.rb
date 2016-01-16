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

    context "help" do
      let(:payload) do
        create(:slack_when_command_payload).tap {|pay| pay.text = "#{pay.text} help" }
      end

      it "responds with command instructions" do
        expected_message = SlashCommand::Commands::When::HELP

        expect(response).to have_http_status(200)
        expect(response.body).to be == expected_message
      end
    end
  end
end
